---
title: On complete ordered fields
author: Andrej Bauer
layout: post
categories:
  - General
  - Constructive mathematics
---

[Joel Hamkins](http://jdh.hamkins.org) advertised the following theorem in Twitter:

> **Theorem:** *All complete ordered fields are isomorphic.*

By "complete" we mean the Dedekind-MacNeille completeness: every inhabited bounded subset has a supremum. [The proof](https://twitter.com/JDHamkins/status/1169935061480804352?s=20) posted by Joel has two parts:

1. Show that a complete ordered field is archimedean.
2. Using the fact that the rationals are dense in an archimedean ordered field, construct an isomorphism between any two of them.

The first step is proved using excluded middle, as follows. Suppose $F$ is a complete ordered field. Suppose $b \in F$ is an upper bound for the natural numbers (construed as a subset of $F$). Then $b - 1$ is also an upper bound, hence $\mathbb{N}$ cannot be bounded, or else its supremum $s$ would have to be smaller than the upper bound $s - 1$. Therefore, by excluded middle, above every $x \in F$ there is $n \in \mathbb{N}$.

So I asked myself and the [constructive news mailing list](https://groups.google.com/forum/#!topic/constructivenews/4jncQ9axrxI) what the status of the theorem is, constructively speaking. But something was amiss, as [Fred Richman](http://math.fau.edu/richman/) asked me to provide an example of a complete ordered field. Why would he do that, don't we have the [MacNeille reals](https://ncatlab.org/nlab/show/MacNeille+real+number)? After agreeing on definitions, [Toby Bartels](http://tobybartels.name) provided the answer, which I took the liberty to present here. But all credit is due to Toby, although I would not be surprised to learn the argument is older than Toby, and possibly me.

The theorem holds constructively, but for a bizarre reason: if there exists a complete ordered field, then the law of ecluded middle holds!

<!--more-->

As there are many constructive versions of order and completeness, let me spell out the definitions we are going to use. (I am fully aware of the fact that these are not constructively optimial, which is precisely one of the points of my post, namely that we should not use the usual order-theoretic notion of completeness.)

A *poset* is a set $P$ with a reflexive, transitive and antisymmetric relation $\leq$. An element $x \in P$ is an *upper bound* for $S \subseteq P$ when $y \leq x$ for all $y \in P$. An element $x \in P$ is the *supremum* of $S \subseteq P$ if it is an upper bound for $S$, and it is below all upper bounds for $S$. So far these are completely standard definitions. A *strict partial order* on a set $P$ is an [asymmetric](https://en.wikipedia.org/wiki/Asymmetric_relation) (and hence irreflexive) and transitive relation $<$ on $P$. Then the *associated* (non-strict) partial order $\leq$ is defined by $x \leq y \Leftrightarrow \lnot (y \leq x)$.

A poset $P$ is *conditionally complete* when every inhabited bounded subset has a supremum (in case you're classically trained, $S \subseteq P$ is *inhabited* if there exists $x \in S$, and this is *not* the same as $S \neq \emptyset$).

All these definitions sound quite reasonable, but 

> **Theorem:** *Let $<$ be a strict partial order on $P$, and suppose $P$ is conditionally complete for the associated partial order $\leq$. If there exist elements $a < b$ such that, $a < x$ or $x < b$ for all $x \in P$, then the [weak excluded middle](https://ncatlab.org/nlab/show/weak+excluded+middle) holds.*

*Proof.* Let $\phi$ be any proposition. Consider the set $S = \{x \in P \mid x = a \lor (\phi \land x = b)\}$. Observe that $\phi$ is equivalent to $b \in S$. Because $a \in S \subseteq \{b, d\}$, the set $S$ is inhabited and bounded, so let $s$ be its supremum. We know that $a < s$ or $s < b$, from which we can decide $\lnot\phi$:

1. If $a < s$ then $\lnot\phi$ cannot hold, or else we would have $b \notin S$, therefore $S = \{a\}$ and $a < s = a$. In this case $\lnot\lnot\phi$ holds.
2. If $s < b$ then $d \notin S$, or else we would have $d \leq s < c < d$, therefore $\lnot\phi$. $\Box$



