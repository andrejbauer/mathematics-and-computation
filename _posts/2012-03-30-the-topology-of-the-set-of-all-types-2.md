---
id: 1182
title: The topology of the set of all types
date: 2012-03-30T00:31:49+02:00
author: Martin Escardo
layout: post
guid: http://math.andrej.com/?p=1182
permalink: /2012/03/30/the-topology-of-the-set-of-all-types-2/
categories:
  - Computation
  - Constructive math
  - Guest post
---
It is well known that, both in constructive mathematics and in programming languages, types are secretly topological spaces and functions are secretly continuous. I have previously exploited this in the posts [Seemingly impossible functional programs](http://math.andrej.com/2007/09/28/seemingly-impossible-functional-programs/) and [A Haskell monad for infinite search in finite time](http://math.andrej.com/2008/11/21/a-haskell-monad-for-infinite-search-in-finite-time/), using the language Haskell. In languages based on [Martin-Löf type theory](http://en.wikipedia.org/wiki/Intuitionistic_type_theory) such as [Agda](http://wiki.portal.chalmers.se/agda/pmwiki.php), there is a set of all types. This can be used to define functions $\mathbb{N} \to \mathrm{Set}$ that map numbers to types, functions $\mathrm{Set} \to \mathrm{Set}$ that map types to types, and so on. 

Because $\mathrm{Set}$ itself is a type, a large type of small types, it must have a secret topology. What is it? There are a number of ways of approaching [topology](http://en.wikipedia.org/wiki/Topology). The most popular one is via [open sets](http://en.wikipedia.org/wiki/Open_set). For some spaces, one can instead use [convergent sequences](http://en.wikipedia.org/wiki/Limit_of_a_sequence), and this approach is more convenient in our situation. It turns out that the topology of the universe $\mathrm{Set}$ is [indiscrete](http://en.wikipedia.org/wiki/Trivial_topology): every sequence of types converges to any type! I apply this to deduce that $\mathrm{Set}$ satisfies the conclusion of [Rice's Theorem](http://en.wikipedia.org/wiki/Rice%27s_theorem): it has no non-trivial, extensional, decidable property. 

To see how this works, check:

  * A [short paper](http://www.cs.bham.ac.uk/~mhe/papers/universe-indiscrete-and-rice.pdf) with the proofs in mathematical vernacular, and further discussion of the intuitions, motivations and consequences.
  * [Literate](http://www.literateprogramming.com/) proofs in Agda of the [universe indiscreteness theorem](http://www.cs.bham.ac.uk/~mhe/papers/universe/TheTopologyOfTheUniverse.html) and [Rice's Theorem for the universe](http://www.cs.bham.ac.uk/~mhe/papers/universe/RicesTheoremForTheUniverse.html).
  * Agda proofs of [related facts](http://www.cs.bham.ac.uk/~mhe/agda/index.html).

The Agda pages can be navigated be clicking at any (defined) symbol or word, in particular by clicking at the imported module names.
