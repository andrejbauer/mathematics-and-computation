---
id: 1584
title: Univalent foundations subsume classical mathematics
date: 2014-01-13T19:10:16+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=1584
permalink: /2014/01/13/univalent-foundations-subsume-classical-mathematics/
categories:
  - Type theory
  - Logic
  - Tutorial
---
A [discussion on the homotopytypetheory mailing list](https://groups.google.com/d/msg/HomotopyTypeTheory/RJaSPUxx_60/C39pciRXfLoJ) prompted me to write this short note. Apparently a mistaken belief has gone viral among certain mathematicians that Univalent foundations is somehow limited to constructive mathematics. This is false. Let me be perfectly clear:

<p style="padding-left: 30px;">
  <strong><em>Univalent foundations subsume classical mathematics!</em></strong>
</p>

The next time you hear someone having doubts about this point, please refer them to this post. A more detailed explanation follows.

<!--more-->

In standard mathematics we take classical logic and set theory as a foundation:

> $\text{logic} + \text{sets}$

<span style="line-height: 1.5;">On top of this we build everything else. </span><span style="line-height: 1.5;">In Univalent foundations this picture is </span><em style="line-height: 1.5;">extended.</em><span style="line-height: 1.5;"> Logic and sets are still basic, but they become part of a much larger universe of objects that we call </span><em style="line-height: 1.5;">types.</em> <span style="line-height: 1.5;">The types are stratified into levels according to their homotopy-theoretic complexity. For a historical reason we start counting at $-2$:</span>

> $\text{$(-2)$-types} \subseteq \text{$(-1)$-types} \subseteq \text{$0$-types} \subseteq \text{$1$-types} \subseteq \cdots \subseteq \text{types}$

We have finite levels $-2, -1, 0, 1, 2, \ldots$, as well as types which lie outside finite levels. Levels $-1$ and $0$ correspond to logic and sets, respectively:

  * $(-2)$-types are the contractible ones,
  * <span style="line-height: 1.5;">$(-1)$-types are the truth values,</span>
  * $0$-types are the sets,
  * $1$-types are the groupoids,
  * etc.

For instance, $\mathbb{N}$ is a $0$-type, the circle $S^1$ is a $1$-type, while the sphere $S^2$ does not have a finite level. If you are familiar with homotopy theory it may be helpful to think of $n$-types as those homotopy types whose homotopy structure above dimension $n$ is trivial.

In Univalent foundations we _may_ assume excluded middle for $(-1)$-types and we _may_ assume the axiom of choice for $0$-types. This then precisely recovers classical mathematics, as sitting inside a larger foundation. Without excluded middle and choice we do indeed obtain a “constructive” version of Univalent foundations, which however is still _compatible_ with classical mathematics. Thus every theorem in the [HoTT book](http://homotopytypetheory.org/book/) is compatible with classical math, even though the HoTT book does _not_ assume excluded middle or choice (except in the sections on cardinals and ordinals).

Any mathematics that is formalized using Univalent foundations is compatible with classical mathematics. Moreover, in principle _all_ classical mathematics could be so formalized.

As the univalent universe is larger than just sets, we have to get used to certain phenomena. For instance, there is the “the quotient set $\mathbb{R}/\mathbb{Z}$” at level 0, and then there is the circle as a $1$-type (groupoid with one object and a generating loop). This is no different from classical mathematics, where we are used to talking about the circle as a set vs. the circle as a topological space.

A classical mathematician and a constructive type theorist will both ask about “excluded middle and axiom of choice for all types”, each for his own reasons. Such principles can indeed be formulated, and then shown to be inconsistent with the Axiom of Univalence. However, this is of little consequence because the “higher-level” versions of excluded middle and choice are simply the wrong statements to consider. Excluded middle is about logic and so it should only apply to $(-1)$-types, while choice is about sets and it should apply only to $0$-types. (To imagine a similar situation in classical mathematics, consider what the axiom of choice would say if we applied it to topological spaces: “every topological bundle whose fibers are non-empty has a continuous global section”, which is obvious nonsense.)
