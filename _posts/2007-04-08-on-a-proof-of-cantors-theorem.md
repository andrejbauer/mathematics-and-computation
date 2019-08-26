---
id: 57
title: 'On a proof of Cantor&#8217;s theorem'
date: 2007-04-08T21:40:20+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/2007/04/08/on-a-proof-of-cantors-theorem/
permalink: /2007/04/08/on-a-proof-of-cantors-theorem/
categories:
  - General
  - Tutorial
---
The famous theorem by Cantor states that the cardinality of a powerset $P(A)$ is larger than the cardinality of $A$. There are several equivalent formulations, and the one I want to consider is

> **Theorem (Cantor):** There is no onto map $A \to P(A)$.

In this post I would like to analyze the usual proof of Cantor&#8217;s theorem and present an insightful reformulation of it which has applications outside set theory. <!--more--> All of what is written here is quite easy and far from being new, but in my opinion still interesting enough to be presented to a wider audience.

If we open a book on set theory, we will find a proof of Cantor&#8217;s theorem which shows explicitly that for every map $e : A \to P(A)$ there is a subset of $A$ outside its image, namely  
$$S = \lbrace x \in A \mid x \not\in e(x) \rbrace$$  
If we had $S = e(y)$ for some $y \in A$ it would follow both that $y$ is and is not an element of $S$. A first observation is that this is a constructively valid proof, hence Cantor&#8217;s theorem holds in intuitionistic set theory just as well. But how wide is the scope of the theorem really? Let us rework it as abstractly as possible, to give it a wider applicability.

First we replace the powerset $P(A)$ with the set of functions $\Omega^A$ where $\Omega$ is the set of truth values. In the case of classical logic $\Omega = \lbrace 0,1 \rbrace$ but there is no need to rely on this fact. We prefer to think of the general situation in which the truth values correspond to subsets of the singleton set $\lbrace 0 \rbrace$, so that $\Omega = P(\lbrace 0 \rbrace)$. The bijection between $P(A)$ and $\Omega^A$ is then just the usual one between subsets and their characteristic maps: a subset $S subseteq A$ corresponds to the map $\chi_S(x) = \lbrace u \in \lbrace 0 \rbrace \mid x \in S\rbrace $, while a map $\chi : A \to \Omega$ corresponds to the subset $\lbrace x \in A \mid 0 \in \chi(x)\rbrace $.

Logical negation $\lnot$ can be seen as a map $N : \Omega \to \Omega$ defined by $N(p) = \lbrace u \in \lbrace 0 \rbrace \mid 0 \not\in p\rbrace $. Note that $N$ does not have a fixed point, for if there were $p \in \Omega$ such that $N(p) = p$ then we would have both $0 \in p$ and $0 \not\in p$.

Now our proof reads as follows: suppose we have a map $e : A \to \Omega^A$. Consider the map $s : A \to \Omega$ defined by $s(x) = N (e(x)(x))$. If there were $y \in A$ such that $s = e(y)$, we would have $e(y)(y) = s(y) = N(e(y)(y))$, a contradiction. Therefore $e$ is not onto. QED. How is this any better than what we had before? It gives us a chance to think about the _positive_ aspects of the situation: if $e$ were onto, then $\Omega$ could not have an endomap without fixed points. Because nothing in the proof specifically relies on $\Omega$ being the set of thruth values we may replace it with a general set to obtain:

> **Theorem (Lawvere):** If there is an onto map $e : A \to B^A$ then every $f : B \to B$ has a fixed point.

We already know how to prove this: consider the map $s : A \to B$ defined by $s(x) = f(e(x)(x))$. Because $e$ is onto, there is $y \in A$ such that $e(y) = s$. Then we have $e(y)(y) = s(y) = f(e(y)(y))$, therefore $e(y)(y)$ is a fixed point of $f$. QED.

Cantor&#8217;s theorem is a corollary of Lawvere&#8217;s theorem with $B = \Omega$ and the observation than negation does not have a fixed point.

Now consider Lawvere&#8217;s theorem in isolation and how one would go about proving it, perhaps something like this: &#8220;How can I have such an onto map $e : A \to B^A$? Surely $B$ cannot have too many elements, in fact, this can only happen if $B$ is a singleton or empty. I can see Lawvere&#8217;s theorem to be obviously true but is rubbish because it only holds in trivial cases.&#8221; There is a mistake in the last sentence: as we shall see shortly, Lawvere&#8217;s theorem is true in interesting cases, but _you_ (the imaginary mathematician, not the readers of this blog&#8230;) can only imagine it in trivial cases because you did not bother to look outside the narrow set-theoretic scope.

Lawvere&#8217;s theorem is a positive reformulation of the diagonalization trick that is at the heart of Cantor&#8217;s theorem. It can be formulated in any cartesian closed category, and its proof uses just equational reasoning with a modicum of first-order logic. We should expect it to have a much wider applicability than Cantor&#8217;s theorem. Indeed, immediately we see that other well-known proofs by diagonalization are corollaries, for example:

  1. The set of sequences of numbers $\mathbb{N} \to \mathbb{N}$ is uncountable because the successor operation does not have a fixed point.
  2. There is no continuous surjection $\mathbb{R} \to C(\mathbb{R}, \mathbb{R})$ from the real line onto the Banach space of continuous real functions, equipped with the compact-open topology, because the real map $x \mapsto x+1$ is continuous and has no fixed points.

More interestingly, there are positive consequences of Lawvere&#8217;s theorem, too:

  1. To contrast the second case above, we ask whether there is a continuous surjection from $\mathbb{R}$ onto $C(\mathbb{R}, [0,1])$, the space of continuous real functions taking values on the closed interval, and equipped with the sup metric. If there is such a map, it follows that the closed interval has the fixed-point property, and moreover that every cube $[0,1]^n$ has the fixed-point property too (exercise). So this might be a nice way to prove [Brouwer&#8217;s fixed point theorem](http://en.wikipedia.org/wiki/Brouwer_fixed_point_theorem), and even if it does not work, it is a nice idea that will get you thinking about [space filling curves](http://en.wikipedia.org/wiki/Space-filling_curve) for a while.
  2. In the _effective [topos](http://en.wikipedia.org/wiki/Topos_theory)_ the [c.e. sets](http://en.wikipedia.org/wiki/Recursively_enumerable) are represented as maps $\Sigma^\mathbb{N}$ where $\Sigma$ is the set of _semidecidable_ truth values. Because there is an effective enumeration of c.e. sets, in the effective topos there is an onto map $W : \mathbb{N} \to \Sigma^\mathbb{N}$, which immediately tells us that $\Sigma$ has the fixed-point property, and so does $\Sigma^\mathbb{N}$ because it is isomorphic to $(\Sigma^\mathbb{N})^\mathbb{N}$. Thus we obtain a theorem in computability theory stating that every [enumeration operator](http://eom.springer.de/E/e035810.htm) has a fixed point.

Lastly, let me comment on a [question by Paul Stadtmann](http://cs.nyu.edu/pipermail/fom/2007-April/011502.html) on the FOM mailing list. He wonders whether the axiom of separation (a.k.a. the subset axiom) is needed to prove Cantor&#8217;s theorem. If we are working just in straight set theory, then _bounded_ separation certainly suffices. (This is the form of separation in which the defining predicate has only bounded quantifiers of the form $\forall x \in A$ and $\exists x \in A$, but none of the form $\forall x$ and $\exists x$.) _However_, bounded separation is only needed to establish a general fact about the universe of sets, namely that it forms a cartesian closed category. After that Lawvere&#8217;s theorem kicks in and gets the job done. So I would say that separation is not used in an essential way here (for example, topos theory directly axiomatizes exponentials and so separation is not needed at all there).