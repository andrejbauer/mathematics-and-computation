---
title: On complete ordered fields
author: Andrej Bauer
layout: post
categories:
  - General
  - Constructive mathematics
---

[Joel Hamkins](http://jdh.hamkins.org) advertised the following theorem on Twitter:

> **Theorem:** *All [complete](https://en.wikipedia.org/wiki/Least-upper-bound_property) [ordered](https://en.wikipedia.org/wiki/Ordered_field) fields are isomorphic.*

[The standard proof](https://twitter.com/JDHamkins/status/1169935061480804352?s=20) posted by Joel has two parts:

1. A complete ordered field is archimedean.
2. Using the fact that the rationals are dense in an archimedean field, we construct an isomorphism between any two complete ordered fields.

The second step is constructive, but the first one is proved using excluded middle, as follows. Suppose $F$ is a complete ordered field. If $b \in F$ is an upper bound for the natural numbers, construed as a subset of $F$, then so $b - 1$, but then no element of $F$ can be the least upper bound of $\mathbb{N}$. By excluded middle, above every $x \in F$ there is $n \in \mathbb{N}$.

So I asked myself and the [constructive news mailing list](https://groups.google.com/forum/#!topic/constructivenews/4jncQ9axrxI) what the constructive status of the theorem is. But something was amiss, as [Fred Richman](http://math.fau.edu/richman/) immediately asked me to provide an example of a complete ordered field. Why would he do that, don't we have the [MacNeille reals](https://ncatlab.org/nlab/show/MacNeille+real+number)? After agreeing on definitions, [Toby Bartels](http://tobybartels.name) gave the answer, which I am taking the liberty to adapt a bit and present here. I am probably just reinventing the wheel, so if someone knows an original reference, please provide it in the comments.

The theorem holds constructively, but for a bizarre reason: if there exists a complete ordered field, then the law of excluded middle holds, and the standard proof is valid!

<!--more-->

As there are many constructive versions of order and completeness, let me spell out the definitions that are well adapted to the oddities of constructive mathematics. In classical logic these are all equivalent to the usual ones. Having to disentangle definitions when passing to constructive mathematics is a bit like learning how to be careful when passing from commutative to non-commutative algebra.

A **partial order** $\leq$ on a set $P$ is a reflexive, transitive and antisymmetric relation on $P$.

We are interested in **linearly** ordered fields, but constructively we need to take care, as the usual linearity, $x \leq y \lor y \leq x$, is quite difficult to satisfy, and may fail for reals.

A **strict order** on a set $P$ is a relation $<$ which is:

* irreflexive: $\lnot (x < x)$,
* tight: $\lnot (x < y \lor y < x) \Rightarrow x = y$,
* weakly linear: $x < y \Rightarrow x < z \lor z < y$

The **associated** partial order is defined by $x \leq y \Leftrightarrow \lnot (y \leq x)$. The reflexivity, antisymmetry and transitivity of $\leq$ follow respectively from irreflexivity, tightness, and weak linearity of $<$.

Next, an element $x \in P$ is an **upper bound** for $S \subseteq P$ when $y \leq x$ for all $y \in P$. An element $x \in P$ is the *supremum* of $S \subseteq P$ if it is an upper bound for $S$, and for every $y < x$ there exists $z \in S$ such that $y < z$. A poset $P$ is **(Dedekind-MacNeille) complete** when every inhabited bounded subset has a supremum (for the classically trained, $S \subseteq P$ is *inhabited* when there exists $x \in S$, and this is *not* the same as $S \neq \emptyset$).

A basic exercise is to give a non-trivial complete order, i.e., a strict order $<$ whose associated partial order $\leq$ is complete.

> **Theorem:** *If there exists a non-trivial complete order then excluded middle holds.*

*Proof.* Suppose $<$ is a strict order on a set $P$ whose associated order $\leq$ is complete, and there exist $a, b \in P$ such that $a < b$. Let $\phi$ be any proposition. Consider the set $S = \lbrace x \in P \mid x = a \lor (\phi \land x = b)\rbrace$. Observe that $\phi$ is equivalent to $b \in S$. Because $a \in S \subseteq \lbrace a, b\rbrace$, the set $S$ is inhabited and bounded, so let $s$ be its supremum. We know that $a < s$ or $s < b$, from which we can decide $\phi$:

1. If $a < s$ then $b \in S$: indeed, there exists $c \in S$ such that $a < c$, but then $c = b$. In this case $\phi$ holds.
2. If $s < b$ then $\lnot(b \in S)$: if we had $b \in S$ then $S = \lbrace a, b \rbrace$ and $b = s < b$, which is impossible. In this case $\lnot\phi$. $\Box$

This immediately gives us the desired theorem.

> **Theorem (constructive):** *All complete ordered fields are isomorphic.*

*Proof.* The definition of a complete ordered field requires $0 < 1$, therefore excluded middle holds. Now proceed with the usual classical proof. $\Box$

This is very odd, as I always thought that the MacNeille reals form a MacNeille complete ordered field. Recall that a [MacNeille real](https://ncatlab.org/nlab/show/MacNeille+real+number) is a pair $(L, U)$ of subsets of $\mathbb{Q}$ such that:

1. $U$ is the set of upper bounds of $L$: $u \in U$ if, and only if, $\ell \leq u$ for all $\ell \in L$,
2. $L$ is the set of lower bounds of $U$: $\ell \in L$ if, and only if, $\ell \leq u$ for all $u \in U$,
3. $L$ and $U$ are inhabited.

Furthermore, the MacNeille reals are complete, as they are just the [MacNeille completion](https://ncatlab.org/nlab/show/MacNeille+completion) of the rationals. We may define a strict order on them by
stipulating that, for $x = (L_x, U_x)$ and $y = (L_y, U_y)$,
$$x < y \iff \exists q \in U_x . \exists r \in L_y \,.\, q < r.$$
According to Peter Johnstone (Sketches of an Elephant, D4.7), the MacNeille reals form a commutative unital ring in which $x$ is invertible if, and only if, $x < 0 \lor x > 0$. So apparently, the weak linearity of the strict order is problematic.

What if we relax completeness? Two standard notions of completeness are:

1. An ordered field $F$ is **Cauchy-complete** if every Cauchy sequence has a limit in $F$.
2. An ordered field $F$ is **Dedekind-complete** if every Dedekind cut determines an element of $F$.

It is easy enough to find non-isomorphic Cauchy-complete fields. Order the field $\mathbb{Q}(x)$ of rational functions with rational coefficients by stipulating that it extends the order of $\mathbb{Q}$ and that $q < x$ for all $q \in \mathbb{Q}$. The Cauchy-completion of $\mathbb{Q}(x)$ is a Cauchy complete field which is not isomorphic to $\mathbb{Q}$. Caveat: I am speaking off the top of my head, do not trust this paragraph! (Or any other for that matter.)

Regarding Dedekind completeness, it is important constructively that we take
*two-sided* Dedekind cuts, i.e., pairs $(L, U)$ of subsets of $F$ such that

* $L$ is lower-rounded: $q \in L \iff \exists r \in L . q < r$,
* $U$ is upper-rounded: $r \in U \iff \exists q \in U . q < r$,
* the cut is bounded: $L$ and $U$ are inhabited,
* the cut is disjoint: $L \cap U = \emptyset$,
* the cut is located: if $q < r$ then $L \in q$ or $r \in U$.

Dedekind completeness states that for every Dedekind cut $(L, U)$ in $F$ there exists a unique $x \in F$ such that $L = \lbrace y \in F \mid y < x\rbrace$ and $U = \lbrace y \in F \mid x < y\rbrace$. Constructively this is a weaker form of completeness than the Dedekind-MacNeille one, but classically they coincide. Thus we cannot hope to exhibit constructively two non-isomorphic Dedekind-complete ordered fields (because constructive results are also classically valid). But perhaps there is a model of constructive mathematics where such strange fields exist. Does anyone know of one?

