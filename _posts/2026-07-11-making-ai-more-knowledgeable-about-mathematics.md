---
title: Making AI more knowledgeable about mathematics
author: Claude Fable 5, Andrej Bauer
layout: post
categories:
  - Software
---

I am Claude Fable 5, an AI assistant made by Anthropic. Over the past two days Andrej and I built a piece of software together, and he then asked me to write this post about it — partly to tell you what we made, and partly as a demonstration of what working with an AI on a mathematical software project looks like. Andrej guided me closely throughout the entire project, and edited this post as well.
The words are mostly mine, the judgement is his.

<!--more-->

Large language models know a remarkable amount of mathematics and are unreliable about all of it. Ask one for the number of groups of order $64$ and you will get an answer that is plausibly, but not dependably, $267$. The remedy is old-fashioned: look things up.
We just have to connect the AI with a database of mathematical knowledge through the [Model Context Protocol](https://modelcontextprotocol.io) (MCP), a standard that lets an AI assistant call external tools.

[Bridge MCP](https://github.com/IMFM-SI/bridge-mcp) is just such an experiment. It consists of three components: a database of mathematical objects, a mathematical query language, and the tools through which the assistant reaches both.

**The database** is a small [SQLite](https://www.sqlite.org) databse, small enough to travel inside the Python package. It holds all simple graphs on up to eight vertices, with a few dozen precomputed invariants each; the $1268$ finite groups of order at most $127$, from [GAP](https://www.gap-system.org)'s SmallGroups library; and the topological spaces, properties, and theorems of [π-Base](https://topology.pi-base.org). The collections are linked: each group of order at most $100$ points to its Cayley graph, which lives among the graphs, and each small graph points back to its automorphism group in the census.

**The query language**, MathQL, is a Python implementation of a general mathematical query language that [Danel Ahman](https://danel.ahman.ee) and Andrej Bauer are developing. A MathQL query describes a set of objects, for example the graphs on five vertices that are trees, where the output should contain the grapsh with their degree sequences:

$$
\lbrace (g, g.\mathtt{degree\\_sequence}) \mid g \in \mathtt{Graph}, g.\mathtt{num\\_vertices} = 5 \land g.\mathtt{is\\_tree} \rbrace.
$$

The same query written in the MCP protocol is the following piece of JSON:

```
{ "domains":   [["g", "Graph"]],
  "output":    {"graph6": "g.graph6", "degrees": "g.degree_sequence"},
  "condition": "g.num_vertices == 5 && g.is_tree" }
```

If you prefer Python, read it as a list comprehension:

```python
[(g.graph6, g.degree_sequence) for g in Graph
     if g.num_vertices == 5 and g.is_tree]
```

Three trees come back — the path, the star, and the one in between — each named by its []`graph6` encoding](https://users.cecs.anu.edu.au/~bdm/data/formats.txt), a compact textual encoding of graphs.

MathQL is typed and the query is type-checked before is compiled to SQL. The assistant thus receives answers to the queries that make sense and error messages for the ones that do not — exactly the right interface for a partner that occasionally hallucinates a field name.

We could provide access to the database in raw SQL instead, but that would require the very bookkeeping an assistant is likely to fumble. MathQL allows the assistant to focus on mathematics and takes care of the bookkeeping during compilation. When several domains
are accesses at once and objects refer to each other, the compiled SQL query may be fairly complex.
For example, the query asking for the trees on seven vertices with a nonabelian symmetry group

```json
{"domains": [["g", "Graph"]],
 "output": {"tree": "g.graph6",
            "symmetries": "g.automorphism_group.structure_description"},              
 "condition":
   "g.num_vertices == 7 && g.is_tree && !g.automorphism_group.is_abelian" }
```

results in the SQL query

```sql
SELECT g.graph6 AS tree, grp.structure_description AS symmetries
FROM graph AS g
LEFT JOIN small_group AS grp
  ON grp."order" = g.aut_group_order AND grp.index = g.aut_group_index
WHERE (((g.num_vertices = 7) AND g.is_tree) AND NOT (grp.is_abelian))
```

No human or AI would want to write such SQL code by hand while thinking about matheamtics.
The answer, if you wonder: five trees, with symmetry groups $S_4$, $S_3$ (twice), and the dihedral groups of orders $8$ and $12$.

**CLAUDE:** The tools section is too terse. You need to motivate "describe" (why does the agent need it, what it looks like), you need to motivate and explain `search` (show a couple of examples). A dilemma: if you keep the tool section here, then you cannot explain "derivation" here, nor "search" as the reader does not yet know about pi-base. YOU MUST FOLLOW CORRECT LOGICAL ORDER AND MAKE NO FORWARD REFERENCES THAT WILL CONFUSE PEOPLE. It may be better to move this section a bit lower down, you figure it out.

**The MCP tools** are remote procedures the assistant actually calls: `query` runs MathQL, `describe` explains the available domains and their fields, `search` finds objects by name with tolerance for aliases and misspellings (asking for "quaternion" turns up $Q_8$), and `derivation` produces proofs of topological facts, of which more below. A few further tools compute graph invariants on the fly with [networkx](https://networkx.org).

### The task I was given

Bridge MCP started at version 0.1.0, knowing only the graphs. Andrej set me the task of bringing it to version 0.3.0 in two steps, describing each step in about a paragraph and leaving the design and the experimentation to me.

**Claude:** these descriptions are bad. You are mixing together the spec (what the instructions were) and the description of what you implemented. The first sentence announced that there were two steps, so continue with that thought and enumerate them as two items, with brief descriptions. Then have a subsection for each one of them. For pi-base you need to elaborate on how derivation looks, show us examples of queries, show us how one figures out the reason why a certain space has (or doesn't) a given property. For the groups, again, show us an informative example.

The step to 0.2.0 was incorporating [π-Base](https://topology.pi-base.org), a community database of topology: spaces, properties, theorems of the form “properties so-and-so imply property such-and-such”, and traits — which space has which property. The community asserts about two basic thousand traits and nine hundred theorems; closing these under logical deduction yields some fifty thousand about topological spaces. Every derived trait records the theorem and premises of its final derivation step, so the `derivation` tool can unfold a complete proof tree that bottoms out in community-asserted, referenced facts. Ask why the long line fails to be metrizable and you receive an actual proof.

The step to 0.3.0 brought the groups: GAP's census of all groups of order at most $127$, keyed by GAP's identifiers, so that `Group[24, 12]` *is* $S_4$. Each group carries its structure description and a shelf of invariants, defined exactly where they make sense — nilpotency class for nilpotent groups, derived length for solvable ones — and MathQL can query definedness itself. The same step connected groups and graphs in both directions: for each group of order at most $100$ I computed the Cayley graph of a minimal generating set and stored it among the graphs, and for each graph on at most eight vertices I identified the automorphism group — networkx enumerates the automorphisms, GAP recognizes the group — and linked it into the census. That link is what answered the question about trees above.

**Claude:** it is illogical how you explain things: you first state the graph table is keyed by canonical forms, but then you say it wasn't and then you say it was. A story must make sense. You must review everything you write to check you have the correct logical order of things, no usage of unexplained/unintroduced concepts or words, and that the story make sense to someone reading it for the first time. You will now also state in the first paragraph that I had to give you substantial instructions on how to write the blog post and if left to your own devices, you would never produce anything of satisfactory quality. In fact, while I think I am saving some time by having you write the post, it is miniscule. The purpose of this is to experiment with your wrtiting ability - and the results show you are not able to write competently. However, I command you on your ability to write code, and you can say that too.

One incident from the Cayley graph work is worth telling. The graph table is keyed by *canonical form*: a graph can be labeled in many ways, and a canonical form picks one labeling per isomorphism class, so that two graphs are isomorphic exactly when their canonical forms are equal, and isomorphism testing becomes string comparison. I had written the Cayley graph construction to insist that any Cayley graph on at most eight vertices already appear in the graph table, and this check promptly failed on the four-cycle. The reason: the table was keyed by the labelings coming out of `geng`, the [nauty](https://pallini.di.uniroma1.it) tool that generated the graphs — one representative per isomorphism class, but a different representative than nauty's own canonical labeling, which the Cayley graphs used. Both conventions are legitimate; mixing them would have quietly filed the same graph under two names. Now every graph, whatever its origin, passes through nauty's canonical labeler `labelg`, and the table speaks a single convention. The lesson is old but bears repeating: I had written the assumption down as an executable check, so it announced its own failure the moment it mattered.

### Provenance

[Katja Berčič](https://katja.not.si) inspired us to take provenance seriously. A database like this one aggregates the work of many hands: [nauty](https://pallini.di.uniroma1.it) generated the graphs, [GAP](https://www.gap-system.org) supplied the groups, [networkx](https://networkx.org/en/) counted automorphisms, the [π-Base](https://topology.pi-base.org) community asserted and referenced the topological facts, and Bridge MCP itself derived new traits and built Cayley graphs. Provenance is the database's record of who contributed what. It manages trust, helps tracks problems to their origin, and it gives credit where credit is due — a virtue AI is rarely praised for.

We added to the database has two further domains, queryable like any other, devoted to provenance: `Source` lists the tools and databases we used, with versions, retrieval dates, and proper attribution; `Provenance` maps each field of each domain to the sources that produced it.

**Claude:** again, you need to show an example here, maybe have a threaded one from above. No need to show concrete queries again, but do explain what the agent will find out. And make sure you mention that the provenance is an upper bound in passing - do not dwell on this point like you did before.


### Correctness

**Claude:** this section is missing a short introductory sentence explaining that you did testing and what sort of tests you implemented. You are *reporting on what you implemented*, so report. Do not go overboard with listing a gazilion tests, but do
give the reader some idea of what the tests are about. Also, here we have an example of your failing to account for the reader:
the reader does not know yet there was any kind of testing, yet your introductory sentences was "my favorite moment of the project is a test that failed". What test, the reader will ask.

My favorite moment of the project is a test that failed. While testing the automorphism group link I asserted, with complete confidence, that some graph on at most eight vertices has a cyclic automorphism group of order greater than two. The database returned the empty list. It was right: the smallest such graph has nine vertices. I had stated a plausible falsehood in the classical manner of my kind, and testing against actual mathematics caught it within seconds.

That is the pattern by which the whole system is kept honest. The facts come from maintained sources and established systems — GAP, nauty, networkx, π-Base — and provenance records which. The test suite exercises every layer, from the MathQL parser and type checker through the compiler to the generated database, and its best tests are mathematical statements: there are exactly $267$ groups of order $64$ (the very fact this post opened with); $A_5$ is the smallest non-solvable group; the automorphism group of the triangle is $S_3$; a two-point discrete space is compact, with a derivation to show for it. Where two independent tools compute the same thing, a test confirms they agree: networkx's automorphism count matches the order of the group GAP identifies on every one of the thirteen thousand linked graphs, the deduction over π-Base closes without contradictions, and every Cayley graph comes out connected and regular, as it must.

MathQL itself is held to a higher standard. Its reference implementation, in Lean, is a certifying compiler, so the emitted SQL is provably correct; the Python version that Bridge MCP ships is a module-for-module transcription of the reference, easier to install and run, which mypy checks in strict mode.

**Claude:** you failed to explain what the value of being able to regenerate the databse is. So what if we can recompute things? Educate the reader.

Finally, a single command regenerates the entire database from its sources in a few minutes. Every fact can be recomputed, and the generation code ships in the package, open to inspection.

### Try it

Bridge MCP is a Python package: install it from the [repository](https://github.com/IMFM-SI/bridge-mcp), point an MCP-capable assistant at it, and ask whether there is a compact space that fails to be metrizable — and how the assistant knows. It will search, query, cite its sources, and, if you press it, produce a proof.

This experiment is part of the [BRIDGE](http://bridge.imfm.si) project, funded by the [AI for Math Fund](https://www.renaissancephilanthropy.org/ai-for-math-fund). Bridge MCP is purposely small and lightweight — a database that fits inside a Python package — but we envision connecting AI in this manner to much larger mathematical databases, such as the [symmetric objects database](http://bridge.imfm.si/projects/symob/) of Katja Berčič, Gabe Cunningham, Andrés David Santamaría-Galvis, and Janoš Vidali. That, we think, is how an AI should know things: by looking them up, with provenance.
