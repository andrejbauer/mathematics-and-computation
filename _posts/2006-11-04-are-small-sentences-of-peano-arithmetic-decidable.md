---
id: 47
title: Are small sentences of Peano arithmetic decidable?
date: 2006-11-04T23:44:56+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/2006/11/04/are-small-sentences-of-peano-arithmetic-decidable/
permalink: /2006/11/04/are-small-sentences-of-peano-arithmetic-decidable/
categories:
  - Computation
  - General
  - Logic
---
Recently there has been a discussion ([here](http://cs.nyu.edu/pipermail/fom/2006-October/011044.html), [here](http://cs.nyu.edu/pipermail/fom/2006-October/011050.html), [here](http://cs.nyu.edu/pipermail/fom/2006-November/011073.html), and [here](http://cs.nyu.edu/pipermail/fom/2006-November/011074.html)) on the [Foundations of Mathematics mailing list](http://cs.nyu.edu/mailman/listinfo/fom) about completeness of Peano arithmetic (PA) with respect to “small” sentences. [Harvey Friedman](http://www.math.ohio-state.edu/~friedman/) made several conjectures of the following kind: “All true _small_ sentences of PA are provable.” He proposed measures of smallness, such as counting the number of distinct variables or restricting the depth of terms. Here are some statistics concerning such statements.

<!--more-->

Consider the first-order language of PA with zero $0$, successor $S$, addition $+$ and multiplication $\cdot$. The axioms are:

> $\lnot (S x = 0)$  
> $S x = S y \Rightarrow x = y$  
> $x+0 = x$  
> $x+S y = S(x+y)$  
> $x \cdot 0 = 0$  
> $x \cdot Sy = (x \cdot y) + x$  
> $R(0) \Rightarrow (\forall x, R(x) \Rightarrow R(S x)) \Rightarrow R(x)$

By Gödel's Theorem we know there exist undecidable sentences in PA. But just how small are the smallest undecidable sentences? The sentences we get from proofs of Gödel's Theorem are huge, so there ought to be some smaller ones. We can ask the same question from a different perspective: does PA decide all small sentences? If there is an undecidable sentence comparable in size to the axioms of PA, then PA is missing something important.

A while ago Harvey Friedman, [John Langford](http://hunch.net/~jl/) and I already investigates decidability of small existentially quantified sentences. It turned out that among those, Diophantine equations were the hardest to decide in general. By exhaustive search we found two which gave a professional number theorist something to munch on for a couple of weeks. They were:

> $\exists a \; b \; c, a^2 - 2 = (a+b) b c$  
> $\exists a \; b \; c, a^2 + a - 1 = (a+b) b c$

Incidentially, the property “$a$ is a prime” can be expressed succinctly as $\forall b\; c, \lnot (a = (S (S b)) \cdot (S (S c)))$. If I am not mistaken, it is not known whether there exist infinitely many primes of the form $a^2 - 2$ (these are known as _near-square primes_). This gives us a fairly short sentence whose status is unknown:

> $\forall a \exists b \forall c \; d, \lnot ((a+b)\cdot(a+b) = S (S ((S (S c)) \cdot (S (S d))))$.

Read the above as: “For every $a$ there is $b$ such that $(a+b)^2 - 2$ is a prime.” If you know an even “smaller” open problem, please let me know. In particular, can we reduce the number of nested quantifiers to something simpler than $\forall \exists \forall$? I suspect there might be fairly short Diophantine equations whose status is unkown.

In the attached [Mathematica](http://www.wolfram.com) notebook, I used Mathematica [`FindInstance`](http://documents.wolfram.com/mathematica/functions/FindInstance) function to count how many Diophantine equations have solutions and how many do not. As you will see, Mathematica is pretty good at this sort of thing. Unfrtunately, we do not get very far by brute force enumeration of all equations. For better results we would have to use more advanced enumeration techniques which avoid generation of equations which are known in advance to be decidable.

**Attachment:** [diophantine.nb](/wp-content/uploads/2006/11/diophantine.nb) (also available as PDF [diophantine.pdf](http://math.andrej.com/wp-content/uploads/2006/11/diophantine.pdf)).
