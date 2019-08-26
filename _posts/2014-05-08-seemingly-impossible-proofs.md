---
id: 1643
title: Seemingly impossible constructive proofs
date: 2014-05-08T16:15:57+02:00
author: Martin Escardo
layout: post
guid: http://math.andrej.com/?p=1643
permalink: /2014/05/08/seemingly-impossible-proofs/
categories:
  - Computation
  - Constructive math
  - Guest post
  - Homotopy type theory
tags:
  - Agda
---
In the post [Seemingly impossible functional programs](http://math.andrej.com/2007/09/28/seemingly-impossible-functional-programs/), I wrote increasingly efficient Haskell programs to [realize](http://en.wikipedia.org/wiki/Realizability) the mathematical statement

> $\forall p : X \to 2. (\exists x:X.p(x)=0) \vee (\forall x:X.p(x)=1)$

for $X=2^\mathbb{N}$, the [Cantor set](http://en.wikipedia.org/wiki/Cantor_set) of infinite binary sequences, where $2$ is the set of binary digits. Then in the post [A Haskell monad for infinite search in finite time](http://math.andrej.com/2008/11/21/a-haskell-monad-for-infinite-search-in-finite-time/) I looked at ways of systematically constructing such sets $X$ with corresponding Haskell realizers of the above _omniscience principle_. 

In this post I give examples of infinite sets $X$ and corresponding constructive _proofs_ of their omniscience that are intended to be valid in [Bishop](https://en.wikipedia.org/wiki/Errett_Bishop) mathematics, and which I have [formalized](http://www.cs.bham.ac.uk/~mhe/agda/) in [Martin-Löf](https://en.wikipedia.org/wiki/Per_Martin-L%C3%B6f) [type theory](http://en.wikipedia.org/wiki/Intuitionistic_type_theory) in [Agda](http://wiki.portal.chalmers.se/agda/pmwiki.php) notation. This rules out the example $X=2^\mathbb{N}$, as discussed below, but includes many interesting infinite examples. I also look at ways of constructing new omniscient sets from given ones. Such sets include, in particular, [ordinals](http://www.cs.bham.ac.uk/~mhe/agda/SearchableOrdinals.html), for which we can [find minimal witnesses](http://www.cs.bham.ac.uk/~mhe/agda/InfSearchable.html) if any witness exists. 

Agda is a dependently typed functional programming language based on Martin-Löf type theory. By the [Curry-Howard correspondence](https://en.wikipedia.org/wiki/Curry%E2%80%93Howard_correspondence), Agda is also a language for formulating mathematical theorems (types) and writing down their proofs (programs). Agda acts as a thorough referee, only accepting correct theorems and proofs. Moreover, Agda can run your proofs. Here is a [graph](http://www.cs.bham.ac.uk/~mhe/agda/index.ps) of the main Agda modules for this post, and here is a [full graph](http://www.cs.bham.ac.uk/~mhe/agda/big-index.ps) with all modules.

<!--more-->

## Some (counter)examples</p> 

## ### $X=\mathbb{N}$

The omniscience of $\mathbb{N}$ is not provable in [constructive mathematics](http://www.masfak.ni.ac.rs/cmfp2013/Nis%20lecture%20170113.pdf) and comes under the fancy name LPO, or [limited principle of omniscience](https://en.wikipedia.org/wiki/Limited_principle_of_omniscience). Its negation is not provable either, at least not in [Bishop&#8217;s](https://en.wikipedia.org/wiki/Errett_Bishop) or [Martin-Löf&#8217;s](https://en.wikipedia.org/wiki/Per_Martin-L%C3%B6f) schools of constructive mathematics, and so we can&#8217;t say that LPO is false. Following [Peter Aczel](https://en.wikipedia.org/wiki/Peter_Aczel), we call such statements _taboos_. They are also known as [Brouwerian counterexamples](https://en.wikipedia.org/wiki/Constructive_proof#Brouwerian_counterexamples):

> **Taboo (LPO).** $\quad\forall p : \mathbb{N} \to 2. (\exists x:\mathbb{N}.p(x)=0) \vee (\forall x:\mathbb{N}.p(x)=1)$.

### $X=\mathbb{N}_\infty$

However, if we enlarge the type of natural numbers with a point at infinity, we get a constructive proof of

> [Theorem.](http://www.cs.bham.ac.uk/~mhe/agda/ConvergentSequenceSearchable.html#2438) $\quad\forall p : \mathbb{N}\_\infty \to 2. (\exists x:\mathbb{N}\_\infty.p(x)=0) \vee (\forall x:\mathbb{N}_\infty.p(x)=1)$.

We remark that the proof doesn&#8217;t rely on continuity axioms, which are not available in Bishop&#8217;s and Martin-Löf&#8217;s approaches to constructive mathematics (see below).

How do we add a point at infinity to $\mathbb{N}$? We can&#8217;t simply take $\mathbb{N}\_\infty = \mathbb{N} + 1$, because this is isomorphic to $\mathbb{N}$. The folklore way to add a limit point to $\mathbb{N}$ is to let $\mathbb{N}\_\infty$ be the type of infinite, decreasing binary sequences. (There are other isomorphic possibilities, such as increasing sequences, or sequences with at most one $1$, among others.)

Such sequences represent finite and infinite counting processes of the form

> $\underline{n} = 1^n 0^\omega$, $\quad\infty = 1^\omega$

($n$ ones followed by infinitely many zeros, and infinitely many ones respectively). This gives the _extended natural numbers_, also known as the [generic convergent sequence](http://www.cs.bham.ac.uk/~mhe/agda/GenericConvergentSequence.html) or the _one-point compactification of the natural numbers_. The above encoding gives an [embedding](http://www.cs.bham.ac.uk/~mhe/agda/Embedding.html)

> $(n \mapsto \underline{n}) : \mathbb{N} \to \mathbb{N}_\infty$.

This shows that the reason why the omniscience of $\mathbb{N}$ fails is not simply that it is infinite, as the larger set $\mathbb{N}_\infty$ is omniscient.

Using this theorem, we can show that for every $p : \mathbb{N}_\infty \to 2$, the proposition [$\forall n : \mathbb{N}.p(\underline{n})=1$ is decidable](http://www.cs.bham.ac.uk/~mhe/agda/ADecidableQuantificationOverTheNaturals.html#3299). The point is that now the quantification is over the natural numbers without violating (weak )LPO. In turn, using this, it follows that [the non-continuity of a function $f : \mathbb{N}_\infty \to \mathbb{N}$ is decidable](http://www.cs.bham.ac.uk/~mhe/agda/DecidabilityOfNonContinuity.html#2116). It is also a corollary that the function type [$\mathbb{N}_\infty \to \mathbb{N}$ has decidable equality](http://www.cs.bham.ac.uk/~mhe/agda/ConvergentSequenceSearchable.html#2575).

The proof of the above theorem was presented at the [Types&#8217;2011](https://sites.google.com/site/types2011/Home/) meeting and is published in the [Journal of Symbolic Logic (JSL)](http://projecteuclid.org/euclid.jsl/1389032274), Volume 78, Number 3, September 2013, pages 764-784, under the title [Infinite sets that satisfy the principle of omniscience in any variety of constructive mathematics](http://www.cs.bham.ac.uk/~mhe/papers/omniscient-journal-revised.pdf). To save some work in the writing of this post, I offer the [slides](http://www.cs.bham.ac.uk/~mhe/.talks/types2011/omniscient.pdf) of the Types talk as an informal account of the [original formal proof in Agda](http://www.cs.bham.ac.uk/~mhe/papers/omniscient-original/AnInfiniteOmniscientSet.html) or the [current one](http://www.cs.bham.ac.uk/~mhe/agda/ConvergentSequenceSearchable.html#2438).

One (categorical) way of convincing ourselves that we have the right definition of $\mathbb{N}_\infty$ is to [prove](http://www.cs.bham.ac.uk/~mhe/agda/CoNaturals.html) that it is the final coalgebra of the functor $1+(-)$.

### $X=2^\mathbb{N}$

The realizer given in [Seemingly impossible functional programs](http://math.andrej.com/2007/09/28/seemingly-impossible-functional-programs/) relied on the hypothesis that all functions from the [Cantor set](http://en.wikipedia.org/wiki/Cantor_set) $2^\mathbb{N}$ of infinite binary sequences to the two-point set $2$ are [uniformly continuous](http://en.wikipedia.org/wiki/Uniform_continuity). 

This statement fails, or rather is independent, in [Bishop](https://en.wikipedia.org/wiki/Errett_Bishop) mathematics or [Martin-Löf](https://en.wikipedia.org/wiki/Per_Martin-L%C3%B6f)&#8216;s [type theory](http://en.wikipedia.org/wiki/Intuitionistic_type_theory): it can&#8217;t be proved or disproved. In [Brouwer](http://en.wikipedia.org/wiki/L._E._J._Brouwer)&#8216;s intuitionism, the statement holds, but it is false in [Markov&#8217;s](http://en.wikipedia.org/wiki/Andrey_Markov_%28Soviet_mathematician%29) Russian school of constructive mathematics, and so it is in [classical mathematics](https://en.wikipedia.org/wiki/Classical_mathematics), because discontinuous functions can be easily defined by case analysis using excluded middle. Bishop mathematics is by design intended to be compatible with both classical mathematics and all [varieties](http://www.cambridge.org/us/academic/subjects/mathematics/logic-categories-and-sets/varieties-constructive-mathematics) of [constructive mathematics](http://www.masfak.ni.ac.rs/cmfp2013/Nis%20lecture%20170113.pdf), in the sense that any theorem in Bishop mathematics is a theorem of classical mathematics and its constructive varieties. Martin-Löf&#8217;s type theory is a formal system intended to be capable of formalizing Bishop mathematics and run it on computers.

However, although Agda is based on Martin-Löf type theory, and hence the above remarks apply, we can disable the termination checker in a particular module to prove a [countable Tychonoff Theorem](http://www.cs.bham.ac.uk/~mhe/agda/CountableTychonoff.html) for inhabited omniscient sets, which gives [the omniscience of $X=2^\mathbb{N}$](http://www.cs.bham.ac.uk/~mhe/agda/CantorSearchable.html). This is the only place in our development that we commit such a sin, relying on an external termination proof. But notice that, although this goes beyond the realms of Bishop and Martin-Löf mathematics, the result is still compatible with classical mathematics, as all sets are omniscient in classical mathematics, by virtue of the principle of [excluded middle](https://en.wikipedia.org/wiki/Law_of_the_excluded_middle).

(At this point I should disclose that when I say _set_ I mean _type_. Apologies to [HoTT](http://homotopytypetheory.org/book/) people, for whom (h)sets are particular kinds of types.)

## Searchable sets

I formulated the above in terms of the notion of omniscience because it is perhaps more familiar. But, for many purposes, including showing the omniscience of $\mathbb{N}_\infty$, it is more convenient to work with the notion of searchable set. We say that $X$ is [searchable](http://www.cs.bham.ac.uk/~mhe/agda/Searchable.html#1279) if

> $\forall p:X \to 2.\exists x\_0 : X. p(x\_0)=1 \to \forall x:X.p(x)=1$.

This is the [Drinker Paradox](http://en.wikipedia.org/wiki/Drinker_paradox), which says that in every (inhabited) pub $X$ there is a person $x\_0$ such that if $x\_0$ drinks then everybody drinks, where $p(x)=1$ means that $x$ drinks. Thus, a pub $X$ is searchable iff it satisfies the Drinker Paradox for every $2$-valued notion $p$ of &#8220;drinking&#8221;. 

It is immediate that any searchable set is inhabited. To get the omniscience of $X$ from its searchability, given $p$ we first find a &#8220;universal witness&#8221; $x\_0$ by the searchability of $X$. We can then check whether $p(x\_0)=0$ or $p(x\_0)=1$ by the decidability of equality of the set $2$. In the first case we conclude $\exists x:X.p(x)=0$ directly, and the second case gives $\forall x:X.p(x)=1$ by the definition of searchability, and so $X$ is indeed omniscient. Conversely, if we know an inhabitant $a : X$ and that $\exists x:X.p(x)=0$ or $\forall x:X.p(x)=1$, in the first case we let $x\_0=x$ and in the second case we let $x=a$ to conclude that $X$ is searchable. This shows that [a set is searchable iff it is both inhabited and omniscient](http://www.cs.bham.ac.uk/~mhe/agda/Searchable.html#4447).

## Constructing new searchable sets from old

We have already mentioned the countable Tychonoff Theorem, but this is a rogue example, as it departs from the constructive foundations we are interested in in this post.

### Sums

If we have a searchable set $X$ and a family $(Y\_x)\_{x : X}$ of searchable sets, then its sum or disjoint union 

> $\sum\_{x : X} Y\_x$

is [also searchable](http://www.cs.bham.ac.uk/~mhe/agda/Searchable.html#6081). This follows directly the ideas discussed in the [paper](http://www.cs.bham.ac.uk/~mhe/papers/selection-escardo-oliva.pdf) with [Paulo Oliva](http://www.eecs.qmul.ac.uk/~pbo/) published in [Mathematical Structures in Computer Science](http://journals.cambridge.org/action/displayJournal?jid=MSC), Volume 20, Issue 2, April 2010, Cambridge University Press.

Two particular cases of interest are 

  1. (binary Tychonoff) If $X$ and $Y$ are searchable then so is $X \times Y$ (when $Y$ doesn&#8217;t depend on $X$), and 
  2. If $Y\_0$ and $Y\_1$ are searchable then so is $Y\_0 + Y\_1$ (when $X=2$).

The rogue proof of the countable Tychonoff Theorem mentioned above recursively iterates the binary Tychonoff Theorem, as in the above paper with Paulo.

### Squashed sums

The mysterious terminology comes from the above JSL paper, where this is a construction that really does perform some squashing (in a metric sense) within the Cantor space $2^\mathbb{N}$. Here we give a generalization of the construction that makes sense for sets that are not necessarily embedded in the Cantor space (unpublished, but done in 2011 and implemented in [Agda in 2012](http://www.cs.bham.ac.uk/~mhe/agda/SquashedSumOld.html)). 

Given countably many sets $X_n$, we want to [construct its disjoint sum with a limit point at infinity](http://www.cs.bham.ac.uk/~mhe/agda/SquashedSum.html), very much like we added a point at infinity to the natural numbers. We do this in two steps. We first extend the family $X : \mathbb{N} \to U$, where $U$ is the universe of types, to a family $Y : \mathbb{N}_\infty \to U$ as follows:

> $Y\_i = \prod\_{n : \mathbb{N}} X_n^{i = \underline{n}}$.

Here $=$ is the identity type and we used exponential notation for the function space $i = \underline{n} \to X_n$.  
The [idea](http://www.cs.bham.ac.uk/~mhe/agda/InjectivityOfTheUniverse.html#3438) is that this product has at most one non-trivial factor, so that we get

> $Y\_{\underline{n}} \cong X\_n$, $\quad Y_{\infty} \cong 1$

where $1$ is the one-point set. In the second step, we take the ordinary sum of the family $Y$. So, in summary, we [define](http://www.cs.bham.ac.uk/~mhe/agda/http://www.cs.bham.ac.uk/~mhe/agda/SquashedSum.html#467) the squashed sum of the family $X$ to be

> $\sum^1 X = \sum\_{i : \mathbb{N}\_\infty} \prod\_{n : \mathbb{N}} X\_n^{i = \underline{n}}$.

The [theorem](http://www.cs.bham.ac.uk/~mhe/agda/SquashedSum.html#511) is that if $X_n$ is searchable for every $n:\mathbb{N}$ then the squashed sum $\sum^1 X$ is also searchable. The [subtlety](http://www.cs.bham.ac.uk/~mhe/agda/HProp-Tychonoff.html#2146) is to prove that $Y\_i$ is searchable for every $i : \mathbb{N}\_\infty$ without performing the taboo case analysis $i=\underline{n}$ or $i = \infty$, as this amounts to LPO. This subtlety amounts a provable, curious instance of the Tychonoff Theorem.

### The world&#8217;s smallest Tychonoff Theorem for searchable sets

If $X$ has at most one point (any two of its points are equal), or, in [HoTT](http://homotopytypetheory.org/book/) terminology, $X$ is an [hproposition](http://www.cs.bham.ac.uk/~mhe/agda/HSets.html#311) or a $-1$-truncated type, and $Y : X \to U$ is a family of searchable sets, then

> $\prod\_{x : X} Y\_x$

is [also searchable](http://www.cs.bham.ac.uk/~mhe/agda/HProp-Tychonoff.html#2146). In other words, searchable sets are closed under the formation of products with at most one factor. This is clear with excluded middle, but the point is that it is not needed. 

### Injectivity of the universe and further generalized squashed sums

The above extension of $X : \mathbb{N} \to U$ to $Y:\mathbb{N}_\infty \to U$ is an instance of a more general phenomenon. If $A$ and $X : A \to U$ are arbitrary, and $j : A \to B$ is an embedding, then $X$ extends to a family $X / j : B \to U$ along $j$.  
For this we need the right definition of [embedding](http://www.cs.bham.ac.uk/~mhe/agda/Embedding.html#166), namely that each fiber

> $j^{-1}(b) = \sum_{a : A} b = j(a)$

is an hproposition. Then $X / j$ is [constructed](http://www.cs.bham.ac.uk/~mhe/agda/InjectivityOfTheUniverse.html#2725) as

> $(X / j)(b) = \prod\_{(a , r) : j^{-1}(b)} X\_a \cong \prod\_{a : A} X\_a^{b = j(a)}$.

We then have that if $X$ is a family of searchable sets, so is $X / j$, using the hproposition-indexed Tychonoff Theorem, and that [the extended sum $\sum(X / j)$ is searchable if $B$ is searchable](http://www.cs.bham.ac.uk/~mhe/agda/ExtendedSumSearchable.html#703), even if $A$ isn&#8217;t searchable, using the fact that sums preserve searchability.

## Final remarks

### A brief word about searchable ordinals

If $X_n$ is a family of ordinals in the sense of the HoTT book, then so is its squashed sum, under the lexicographic order with the added point at infinity as the largest element. I haven&#8217;t proved this in Agda yet (it is in my to do list). But I have proved in Agda some preliminary facts towards this. What needs to be done is to add order to [this](http://www.cs.bham.ac.uk/~mhe/agda/SearchableOrdinals.html). Some preliminary Agda modules toward that have been developed.

### Function extensionality: a second sin?

To avoid setoids (what Bishop actually calls sets) I have invoked the axiom of [function extensionality](http://www.cs.bham.ac.uk/~mhe/agda/Extensionality.html) (any two pointwise equal functions are equal). This will be available in the next generation of proof assistants / [programming languages based on HoTT](https://github.com/simhu/cubical) which are under active development in various research centers. However, for the moment, it turns out that for the majority of theorems, we can get away with the double negation of function extensionality, which [can be postulated without loss of computational content](http://www.cs.bham.ac.uk/~mhe/papers/negative-axioms.pdf). [Chuangjie Xu](http://www.cs.bham.ac.uk/about/people/X) has formally checked that doubly negated function extensionality is enough for a few of the theorems discussed above, starting from the crucial one that $\mathbb{N}_\infty$ is searchable. What one observes in practice in my implementation, which uses (positive) function extensionality, is that when one runs examples one gets numerical results that don&#8217;t get stuck in irreducible terms containing the function extensionality constant [funext](http://www.cs.bham.ac.uk/~mhe/agda/Extensionality.html). 

### Informal proofs

I plan to write a paper with the informalization of the Agda development (other than that already provided in the JSL paper mentioned above). For the moment, this blog post is a first approximation, with an informal discussion of some the results proved in the Agda development.