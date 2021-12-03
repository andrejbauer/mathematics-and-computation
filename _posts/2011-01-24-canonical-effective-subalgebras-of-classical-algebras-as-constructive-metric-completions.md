---
id: 431
title: Canonical Effective Subalgebras of Classical Algebras as Constructive Metric Completions
date: 2011-01-24T09:22:36+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=431
permalink: /2011/01/24/canonical-effective-subalgebras-of-classical-algebras-as-constructive-metric-completions/
categories:
  - Computation
  - Constructive math
  - Publications
---
[Jens Blanck](http://www.cs.swan.ac.uk/~csjens/) and I presented a paper at [Computability and Complexity in Analysis 2009](http://cca-net.de/cca2009/) with a complicated title (I like complicated titles):

> _[Canonical Effective Subalgebras of Classical Algebras as Constructive Metric Completions](http://www.jucs.org/jucs_16_18/canonical_effective_subalgebras_of)_

which has been published in [Volume 16, Issue 18 of the Journal of Universal Computer Science](http://www.jucs.org/jucs_16_18). I usually just post the abstract, but this time I would like to explain the general idea informally, the way one can do it on a blog. But first, here is the abstract:

**Abstract:** We prove general theorems about unique existence of effective subalgebras of classical algebras. The theorems are consequences of standard facts about completions of metric spaces within the framework of constructive mathematics, suitably interpreted in realizability models. We work with general realizability models rather than with a particular model of computation. Consequently, all the results are applicable in various established schools of computability, such as type 1 and type 2 effectivity, domain representations, equilogical spaces, and others.

**Download paper:** [effalg.pdf](/wp-content/uploads/2010/01/effalg.pdf) or [directly from JUCS](http://www.jucs.org/jucs_16_18/canonical_effective_subalgebras_of)

<!--more-->

### Computability via constructive mathematics

I have been going around [telling people](/2005/08/23/realizability-as-the-connection-between-computable-and-constructive-mathematics/) they should use constructive mathematics to study computability of structures in analysis and topology. This is supposed to work as follows:

  1. Develop the constructive theory of a mathematical gadget $X$.
  2. Interpret the constructive theory via the realizability interpretation in a model of computation, such as Turing machines (see [these notes](/2005/08/23/realizability-as-the-connection-between-computable-and-constructive-mathematics/)).
  3. The interpretation gives the computable version of $X$.

I still think this general approach to computable mathematics works really well. I have heard a number of talks in which the authors invented computable versions of their mathematical gadgets “by hand”, where all they had to do was to open [Bishop's book](http://books.google.com/books?as_isbn=0387150668) and calculate some realizability interpretations.

By the way, it does not really matter whether you use realizability to interpret the constructive theory, it might be something else, for example type theory (and here is [a tutorial](/2010/01/07/tutorial-on-videolecturesnet/) that does precisely that to real numbers and more).

However, there are practical obstacles to the above plan. The biggest one is the fact that mathematicians do not find it easy to switch from classical to constructive thinking. That's an understatement. In my experience deprogramming oneself from classical mathematics takes a considerable effort and at least some external guidance. It's just hard to know whether a proof uses excluded middle or choice if you're not trained to spot it. (But let me tell you it's a liberating experience to peek outside Hilbert's “Paradise”.)

A more serious practical obstacle is that the proposed program requires us to develop all of mathematics constructively. While this may be a worthy goal, often times I just do not have the time to, say, develop the constructive theory of overt compact groups when all I want is an implementation of the unit circle in the complex plane. And most of the time people have a pretty good idea how to equip their gadget $X$ with computable structure anyhow. They don't need heavy machinery that reconstructs everything from scratch.

Jens and I proved a couple of theorems which generalize previous work of Malcev, [Yiannis Moschovakis](http://www.math.ucla.edu/~ynm/), [Peter Hertling](http://www.unibw.de/inf1/personen/professoren/hertling/) and others, and allow us to skip the whole business of “do it constructively first”. I would like to spend a couple of kilobytes explaining how the theorems work.

### Assemblies

Let us consider a set $A$ with distinguished elements and operations. Some examples might be:

  * the set $\mathbb{N}$ of natural numbers with the constant $0$ and the operations $S$ (successor), $+$ and $\times$,
  * the set $\mathbb{R}$ of real numbers with constants $0$, $1$, and operations $+$, $-$, $\times$ and ${}^{-1}$,
  * the Hilbert space $L^2[0,1]$ with the usual vector-space operations and the inner product.

We shall call such a set with operations an _algebra_, but keep in mind that the structure may have little to do with traditional algebra.

A general question in computable mathematics is how to equip with a computability structure a given algebra $A$, or at least a canonically chosen subalgebra. In many cases the answer seems obvious, but when you start thinking about all possible computable structures that $A$ could receive, it is not obvious which one is “the correct” one.

Before we can answer the question we have to make it technically precise. A natural way of equipping $A$ with a computable structure is to provide its implementation, say in Haskell. This amounts to giving a datatype `t` whose values represent the elements of the set $A$ together with a _realizability relation_ which tells us which values $v$ of type `t` represent which elements $x \in A$. Let us write $v \vdash x$ for “the value $v$ of type `t` represents the element $x \in A$” (the symbol is supposed to be `\Vdash` in LaTeX but MathJax does not have it). We call $v$ a _realizer_ of $x$. The triple $(A, \mathtt{t}, {\vdash})$ is called an _assembly_. We require that every $x \in A$ has at least one $v$ of type `t` which realizes it, $v \vdash x$.

We say that a map $f : A \to B$ between assemblies $(A, \mathtt{s}, {\vdash\_A})$ and $(B, \mathtt{t}, {\vdash\_B})$ is _implemented_ or _realized_ by a value $g$ of type `s -> t` when we have for all $x \in A$ and $v$ of type `s`:

> if $v \;\vdash\_A x$ then $g \, v \;\vdash\_B  f(x)$.

The notions of assemblies and realized maps are just explicit mathematical manifestation of how mathematicians-programmers think when they implement mathematical gadgets.

In the context of type 2 effectivity assemblies are viewed as _multi-valued representations_: the realizability relation $\vdash$ may be viewed equivalently as a map $\delta: A \to P(t)$ which assigns to each $x \in A$ the set of those values which implement it, $\delta(x) = \lbrace v : t \mid v \vdash x$. I am mentioning this because type 2 effectivity is a fairly popular model of computation among mathematicians who do this sort of thing. We are going to stick to Haskell.

### What is a nice assembly?

We seek a “nice” assembly which implements our algebra $A$. One obvious criterion for “niceness” is that the operations of $A$ should be implementable. Let us look at a silly example to explain this point. Suppose we would like to implement the set of integers $\mathbb{Z}$ with the constants $0$, $1$, addition $+$ and subtraction $-$.  Probably everyone would agree that we should use Haskell's type `Integer` as the representing datatype, where each integer is represented by the corresponding value. Both constants $0$ and $1$ as well as the operations $+$ and $-$ on type `Integer` are of course implemented in Haskell. But there are also other implementations that programmers would never consider, although mathematicians might. For example, we might represent $\mathbb{Z}$ with the Haskell type `Integer ->` `Integer` and declare that $f \vdash n$ when $f$ is a monotone sequence of integers whose limit is $n$. Thus the value

> `\k -> min 3 k`

which is the sequence $\ldots, -1, 0, 1, 2, 3, 3, 3, \ldots$ represents the number $3$. Now again $0$ and $1$ are realized (every integer $n$ is realized by the constant sequence `const n`), and addition is implemented as

> `add f g = \k -> f k + g k`

With subtraction we face a problem because it is _anti_monotone in the second argument. In fact, it is impossible to implement it (exercise: assume it is implemented and derive from it the Halting oracle).

Here is another unreasonable representation of $\mathbb{Z}$: we implement integers with the unit type `()` and represent every integer $n$ with the unit value `()`. This is very silly, of course. But notice that the operations $+$ and $-$, and in fact _all_ maps, including the non-computable ones, are trivially implemented by the Haskell function which always returns `()`. So in a sense this representation is “better” because it allows implementation of more operations.

In order to eliminate the last example we need to require something more than just computability of constants and operations.

### The theorems

This brings me to the two theorems Jens and I proved. The starting point were the following known results:

  * If the algebra $A$ is finitely generated, then it has at most one computable structure such that equality is semidecidable. (Malcev 1961)
  * The recursive reals have a unique representation under which they form a recursive field which is recursively complete and the strict order $<$ is semidecidable. ([Moschovakis 1965](http://www.numdam.org/item?id=CM_1965-1966__17__40_0))
  * There is a unique type 2 representation of the reals under which they form a computable field which is computably complete and the strict order $<$ is computably open. ([Hertling 1997](http://researchspace.auckland.ac.nz/handle/2292/3566))

The second and the third result give us a hint as to what else is needed in order to get a canonical computable structure, namely _computable completeness_ and something involving semidecidability of $<$.

Completeness is a metric property, so we focus on _metric algebras_, which are metric spaces equipped with constants and continuous operations. The real numbers are a metric algebra (I am ignoring the fact that inverse is a partial operation, the paper deals with partial operations, too), while the case of finitely generated algebras can be brought into the picture by equipping them with the discrete metric, which is complete.

What is the common generalization of having semidecidable equality on a discrete space and having semidecidable $<$ in $\mathbb{R}$? It turns out to be the semidecidability of relation $d(x,y) < q$, where $d$ is the metric, $x, y \in A$ and $q$ is rational. So our two main theorems are as follows, slightly paraphrased:

> **Theorem 11:** Suppose $A$ is a metric algebra whose initial subalgebra is dense. Then there exists at most one computably complete computable subalgebra of $A$ for which the relation $d(x,y) < q$ is semidecidable.
> 
> **Theorem 12:** Suppose $A$ is a metric algebra such that its initial subalgebra has computably locally uniformly continuous operations and a semidecidable relation $d(x,y) < q$. Then there is at least one computably complete computable subalgebra of $A$ for which the relation $d(x,y) < q$ is semidecidable.

The first theorem restricts reasonable computability substructures and the second one guarantees their existence. Notice how the first theorem does not contain _any_ assumptions about computability. The conditions of the second theorem are a bit technical, however, they correspond precisely to what is usually needed in practice (see the paper for details).

The upshot of these two theorems is as follows. Suppose we have a classical algebra $A$ and we have a pretty good idea on how to implement it reasonably (by which we mean that the operations are computable and computably locally uniformly continuous, the limit operator is computable, and the metric is semidecidable). Then all we need to do is verify the conditions of the two theorems. If they are satisfied then there is precisely one reasonable implementation, up to computable isomorphism, hence it has to be the one we have in mind.
