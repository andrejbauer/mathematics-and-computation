---
title: On fixed-point theorems in synthetic computability
author: Andrej Bauer
layout: post
categories:
  - Synthetic computability
  - Publications
---

I forgot to record the fact that already two years ago I wrote a paper on
Lawvere's fixed-point theorem in synthetic computability:

> Andrej Bauer: [*On fixed-point theorems in synthetic computability*](https://doi.org/10.1515/tmj-2017-0107).
> Tbilisi Mathematical Journal, Volume 10: Issue 3, pp. 167–181.

It was a special issue in honor of Professors [Peter J.
Freyd](https://en.wikipedia.org/wiki/Peter_J._Freyd) and [F. William
Lawvere](https://en.wikipedia.org/wiki/William_Lawvere) on the occasion of their
80th birthdays.

Lawvere's paper ["Diagonal arguments and cartesian closed
categories](https://content.sciendo.com/view/journals/tmj/10/3/article-p167.xml) proves a
beautifully simple fixed point theorem.

> **Theorem:** (Lawvere) *If $e : A \to B^A$ is a surjection then every $f : B \to B$ has a fixed point.*

*Proof.* Because $e$ is a surjection, there is $a \in A$ such that $e(a) = \lambda x : A \,.\, f(e(x)(x))$, but then $e(a)(a) = f(e(a)(a)$. $\Box$

Lawvere's original version is a bit more general, but the one given here makes is very clear that Lawvere's fixed point theorem is the diagonal argument in crystallized form. Indeed, the contrapositive form of the theorem, namely

> **Corollary:** *If $f : B \to B$ has no fixed point then there is no surjection $e : A \to B^A$.*

immediately implies a number of famous theorems that rely on the diagonal argument. For example, there can be no surjection $A \to \lbrace 0, 1\rbrace^A$ because the map $x \mapsto 1 - x$ has no fixed point in $\lbrace 0, 1\rbrace$ -- and that is Cantors' theorem.

It not easy to find non-trivial instances to which Lawvere's theorem applies. Indeed, if excluded middle holds, then having a surjection $e : A \to B^A$ implies that $B$ is the singleton. We should look for interesting instances in categories other than classical sets. In my paper I do so: I show that countably based $\omega$-cpos in the effective topos are countable and closed under countable products, which gives us a rich supply of objects $B$ such that there is a surjection $\mathbb{N} \to B^\mathbb{N}$.

Enjoy the paper!

