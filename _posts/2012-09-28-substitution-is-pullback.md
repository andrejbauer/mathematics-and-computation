---
id: 1231
title: Substitution is pullback
date: 2012-09-28T17:50:48+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=1231
permalink: /2012/09/28/substitution-is-pullback/
categories:
  - Logic
  - Tutorial
---
I am sitting on a tutorial on categorical semantics of dependent type theory given by [Peter Lumsdaine](http://mathstat.dal.ca/~p.l.lumsdaine/). He is talking about categories with attributes and other variants of categories that come up in the semantics of dependent type theory. He is amazingly good at fielding questions about definitional equality from the type theorists. And it looks like some people are puzzling over pullbacks showing up, which Peter is about to explain using syntactic categories. Here is a pedestrian explanation of a very important fact:

> **Substitution is pullback.**

<!--more-->

I will stick to “ordinary math”. No dependent types, no contexts, no fancy logic. Suppose we have an expression $t(x)$ which describes a function $A \to B$ mapping $x$ to $t(x)$, and a predicate on $B$, i.e., an expression $P(y)$ which tells us whether any given $y \in B$ has a given property. Then we can define a new predicate $Q(x)$ on $A$ by
$$Q(x) \equiv P(t(x)).$$
We **substituted** the term $t(x)$ for $y$ in the expression $P(y)$. This is completely obvious and it gets used all the time. For example, whenever we say something like “$2 x + 1$ is even”, we have substituted the expression $2 x + 1$ for $y$ in the predicate $\exists z . y = 2 z$, where all variables range over integers.

Let us think in terms of sets. The expresion $t(x)$ corresponds to a function $t : A \to B$. The predicate $P(y)$ on $B$ corresponds to a subset $P \subseteq B$ of those elements which satisfy it. Then $Q(x) \equiv P(t(x))$ corresponds to a subset $Q \subseteq A$, namely
$$Q = \lbrace x \in A \mid t(x) \in P \rbrace.$$
But this $Q$ **is the pullback of the inclusion $P \hookrightarrow B$ along $t$**. And if you draw the relevant pullback diagram for yourself, and figure out why we have a pullback, you will have understood why substitution is pullback.

#### Isn't substitution composition?

Sometimes we substitute terms into terms. Suppose we have an expression $t(x)$ which maps $x \in A$ to $t(x) \in B$, and an expression $s(y)$ which maps $y \in B$ to $s(y) \in C$. Then we can **substitute** $t(x)$ for $y$ in $s(y)$ to obtain the expression $s(t(x))$ which maps $x \in A$ to $s(t(x)) \in C$. In terms of functions this is **composition**. So the full story is that

> **Substitution of a term into a predicate is pullback, but substitution of a term into a term is composition.**

Or if you are a type theorist:

>  **Substitution of a term into a dependent type is pullback, but substitution of a term into a term is composition.**
