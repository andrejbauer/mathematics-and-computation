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

The second step is constructive, but the first one is proved using excluded middle, as follows. Suppose $F$ is a complete ordered field. If $b \in F$ is an upper bound for the natural numbers, construed as a subset of $F$, then so $b - 1$, but then no element of $F$ can be the supremum of $\mathbb{N}$. By excluded middle, above every $x \in F$ there is $n \in \mathbb{N}$.

So I asked myself and the [constructive news mailing list](https://groups.google.com/forum/#!topic/constructivenews/4jncQ9axrxI) what the constructive status of the theorem is. But something was amiss, as [Fred Richman](http://math.fau.edu/richman/) immediately asked me to provide an example of a complete ordered field. Why would he do that, don't we have the [MacNeille reals](https://ncatlab.org/nlab/show/MacNeille+real+number)? After agreeing on definitions, [Toby Bartels](http://tobybartels.name) gave the answer, which I am taking the liberty to present here. All credit goes to Toby, although I would not be surprised to learn the argument is older than Toby, and possibly me.

The theorem holds constructively, but for a bizarre reason: if there exists a complete ordered field, then the law of ecluded middle holds!

<!--more-->

As there are many constructive versions of order and completeness, let me spell out the definitions we are going to use. (I am fully aware of the fact that these are not constructively optimial, which is precisely one of the points of my post, namely that we should not blindly use the usual order-theoretic notion of completeness.)

A *poset* is a set $P$ with a reflexive, transitive and antisymmetric relation $\leq$. An element $x \in P$ is an *upper bound* for $S \subseteq P$ when $y \leq x$ for all $y \in P$. An element $x \in P$ is the *supremum* of $S \subseteq P$ if it is an upper bound for $S$, and it is below all upper bounds for $S$.

We are interested in linearly ordered fields, but constructively we need to take care when defining linearity, as the usual $x \leq y \lor y \leq x$ is quite difficult to satisfy, and may fail for reals. Define a *strict linear order* on a set $P$ to be a transitive, irreflexive (and hence asymmetric), and weakly linear relation $<$, where weak linearity means $x < y \lor x < z \lor z < y$. (This notion is classically equivalent to the usual one.) Given a strict linear order, the *associated* (non-strict) partial order $\leq$ is defined by $x \leq y \Leftrightarrow \lnot (y \leq x)$.

A poset $P$ is *(Dedekind-MacNeille) complete* when every inhabited bounded subset has a supremum (for the classically trained, $S \subseteq P$ is *inhabited* when there exists $x \in S$, and this is *not* the same as $S \neq \emptyset$).

A basic exercise is to give a non-trivial complete linear order, i.e., a strict linear order $<$ whose associated partial order $\leq$ is complete.

> **Theorem:** *If there exists a non-trivial complete linear order then the  [weak excluded middle](https://ncatlab.org/nlab/show/weak+excluded+middle) holds.*

*Proof.* Suppose $<$ is a strict linear order on $P$ whose associated order $\leq$ is complete, and there exist $a, b \in P$ such that $a < b$. Let $\phi$ be any proposition. Consider the set $S = \lbrace x \in P \mid x = a \lor (\phi \land x = b)\rbrace$. Observe that $\phi$ is equivalent to $b \in S$. Because $a \in S \subseteq \lbrace a, b\rbrace$, the set $S$ is inhabited and bounded, so let $s$ be its supremum. We know that $a < s$ or $s < b$, from which we can decide $\lnot\phi$:

1. If $a < s$ then $\lnot\lnot(b \in S)$: if we had $b \notin S$ then $S = \lbrace a \rbrace$ and $a < s = a$, which is impossible. In this case $\lnot\lnot\phi$ holds.
2. If $s < b$ then $\lnot(b \in S)$: if we had $b \in S$ then $S = \lbrace a, b \rbrace$ and $b = s < b$, again impossible. In this case $\lnot\phi$. $\Box$

> *Lemma:** Suppose $S \subseteq P$ has supremum $s$ and $t < s$. Then there exists $u \in S$ such that $t \leq u$.



This result is not good enough for our purposes, but we can strengten it using the algebraic structure of a field.

> **Theorem:** *Let $F$ be a commutative unital ring with a complete linear order $<$, such that, for all $x, y, z \in F$:*
>
> 1. *$0 < 1$.*
> 2. *If $0 \leq x$ and $0 \leq y$ then $0 \leq x \cdot $.*
> 3. *$x < y$ if, and only if, $x + z < y + z$.*
> 4. *$x$ is invertible if, and only if, $x < 0 \lor 0 < x$.*
>
> *Then excluded middle holds.*

*Proof.* Following Toby Bartels, consider any proposition $\phi$ and define
$$S = \lbrace x \in F \mid x = -1 \lor (\phi \land x = 1) \rbrace.$$
Let $s$ be the supremum of $S$, which exists because $-1 \in S \subseteq \lbrace -1, 1 \rbrace$.
Observe that:

1. $0 < s$ implies $\phi$:
2. $s < 0$ implies $\lnot\phi$: if $\phi$ then $s = 1$, hence $1 = s < 0$, which contradicts $0 < 1$.

Let us show that $s^2 = 1$ by proving $s^2 \leq 1$ and $1 \leq s^2$:

* Clearly we have $-1 \leq s \leq 1$, from which we get $0 \leq 1 + s$ and $0 \leq 1 - s$, and hence $s^2 \leq 1$.
* Suppose we had $s^2 < 1$. Then $s^2 - 1 < 0$ and thus $1 - s^2$ is invertible, but then so are $s - 1$ and $s + 1$. It follows that $-1 < s < 1$. However, $s < 1$ implies $\lnot \phi$, which implies $s = -1$, contradicting $-1 < s$. Therefore, $1 \leq s^2$.

Now we know that $s$ is its own inverse, therefore $s < 0$ or $s > 0$. In the first case $\lnot\phi$ holds, and in the second $\phi$ holds. $\Box$


