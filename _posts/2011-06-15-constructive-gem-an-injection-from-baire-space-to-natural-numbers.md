---
id: 968
title: 'Constructive gem: an injection from Baire space to natural numbers'
date: 2011-06-15T15:48:19+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=968
permalink: /2011/06/15/constructive-gem-an-injection-from-baire-space-to-natural-numbers/
categories:
  - Constructive math
  - Gems and stones
  - Logic
  - Publications
---
I am not sure whether to call this one a constructive gem or stone. I suppose it is a matter of personal taste. I think it is a gem, albeit a very unusual one: there is a topos in which $\mathbb{N}^\mathbb{N}$ can be embedded into $\mathbb{N}$.<!--more-->

At the [Mathematical Foundations of Programming Semantics XVII](www.math.tulane.edu/~mfps/), which took place at Carnegie Mellon University in May 2011, [Paulo Oliva](http://www.eecs.qmul.ac.uk/~pbo/) and [Martín Escardó](http://www.cs.bham.ac.uk/~mhe/) showed a program which witnessed the fact that there was no injection from the Baire space $\mathbb{N}^\mathbb{N}$ to natural numbers $\mathbb{N}$. The program took as input a function $h : \mathbb{N}^\mathbb{N} \to \mathbb{N}$ and produced two sequences $x, y \in \mathbb{N}^\mathbb{N}$ such that $x \neq y$ and $h(x) = h(y)$. Martín Escardó [popularized the program](https://lists.chalmers.se/pipermail/agda/2011/003088.html) as interesting example of extraction of computational content from classical proofs, which [lead me to wonder](http://groups.google.com/group/constructivenews/browse_thread/thread/5f65c7ac479c15dd) whether there was a constructive proof of the statement  
$$\forall h : \mathbb{N}^\mathbb{N} \to \mathbb{N} .  
\exists x, y \in \mathbb{N}^\mathbb{N} .  
(x \neq y \land h(x) = h(y))$$  
that would yield such programs more directly. [Fred Richman](http://math.fau.edu/richman/) asked for a constructive proof of the weaker statement that there was no injection $\mathbb{N}^\mathbb{N} \to \mathbb{N}$, and nobody could come up with one.

Classically there is no injection $\mathbb{N}^\mathbb{N} \to \mathbb{N}$, of course. Constructively, it is easy to see that it must be wildly discontinuous, if it exists. Thus we cannot hope to find one in any of the usual varieties of constructive mathematics, as they all satisfy some kind of continuity principle.

If I am not mistaken, the realizability topos based on infinite time Turing machines by [Joel Hamkins](http://jdh.hamkins.org/) contains an injection $\mathbb{N}^\mathbb{N} \to \mathbb{N}$. This is possible because infinite time Turing machines are powerful enough to be able to compute canonical realizers for infinite time computable maps $\mathbb{N} \to \mathbb{N}$. The details are in the paper, attached below. It is likely that the topos can be used for other ominous purposes. For example, it validates the principle LPO but its logic is not classical.

**Download:** [injection.pdf](/wp-content/uploads/2011/06/injection.pdf)