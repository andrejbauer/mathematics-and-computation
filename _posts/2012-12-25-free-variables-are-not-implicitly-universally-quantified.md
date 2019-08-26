---
id: 1387
title: 'Free variables are not &#8220;implicitly universally quantified&#8221;!'
date: 2012-12-25T03:27:53+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=1387
permalink: /2012/12/25/free-variables-are-not-implicitly-universally-quantified/
categories:
  - Logic
  - Tutorial
---
Mathematicians are often confused about the meaning of variables. I hear them say &#8220;a free variable is implicitly universally quantified&#8221;, by which they mean that it is ok to equate a formula $\phi$ with a free variable $x$ with its universal closure $\forall x \,.\, \phi$. I am addressing this post to those who share this opinion.

<!--more-->

I will give several reasons, which are all essentially the same, why &#8220;there is no difference between $\phi$ and $\forall x \,.\, \phi$&#8221; is a really bad opinion to have.

### Reason 1: you wouldn&#8217;t equate a function with its definite integral

You would not claim that a real-valued function $f : \mathbb{R} \to \mathbb{R}$ is &#8220;the same thing&#8221; as its definite integral $\int_{\mathbb{R}} f(x) \, d x$, would you? One is a real function, the other is a real number. Likewise, $\phi$ is a truth <emph>function</emph> and $\forall x \,.\, \phi(x)$ is a truth <emph>value</emph>.

### Reason 2: functions are not their own values

To be quite precise, the expression $\phi$ by itself is not a function, just like the expression $x + \sin x$ is not a function. To make it into a function we must first <emph>abstract</emph> the variable $x$, which is usually written as $x \mapsto x + \sin x$, or $\lambda x \,.\, x + \sin x$, or `fun x -> x +. sin x`. In logic we indicate the fact that $\phi$ is a function by putting it in a <emph>context</emph>, so we write something like $x : \mathbb{R} \vdash \phi$.

Why is all this nit-picking necessary? Try answering these questions with &#8220;yes&#8221; and &#8220;no&#8221; consistently:

  1. Is $x + \sin x$ a function in variable $x$?
  2. Is $x + \sin x$ a function in variables $x$ and $y$?
  3. Is $y &#8211; y + x + \sin x$ a function in variables $x$ and $y$?
  4. Is $x + \sin x = y &#8211; y + x + \sin x$?

A similar sort of mistake happens in algebra where people think that polynomials are functions. They are not. They are elements of a certain freely generated ring.

### Reason 3: They are not logically equivalent

It is absurd to claim that $\phi$ and $\forall x \in \mathbb{R} \,.\, \phi$ are logically equivalent statements. Suppose $\forall x \in \mathbb{R} \,.\, x > 2$ were equivalent to $x > 2$. Then I could replace one by the other in any formula I wish. So I choose the formula $\exists x \in \mathbb{R} \,.\, x > 2$. It must be equivalent to $\exists x \in \mathbb{R} \,.\, \forall x \in \mathbb{R} \,.\, x > 2$, but since $\forall x \in \mathbb{R} \,.\, x > 2$ is false, we get $\exists x \in \mathbb{R} \,.\, \bot$, which is false. We proved that there is no number larger than 2.

### Reason 4: They are not inter-derivable

If you can tell the difference between an implication and logical entailment, perhaps you might try to counter reason 3 by pointing out that $\phi$ and $\forall x \,.\, \phi$ are either both derivable, or both not derivable. That is to say, we can prove one if, and only if, we can prove the other. But again, this is not the case. We can prove $\forall x \in \emptyset \,.\, \bot$ but we cannot prove $\bot$.

### Reason 5: Bound variables can be renamed but free variables cannot

The formula $x > 2$ is obviously not the same thing as the formula $y > 2$. But the formula $\forall x \in \mathbb{R} . x > 2$ is actually the same as $\forall y \in \mathbb{R} . y > 2$. If you find this confusing it is because you were never taught properly how to handle [free and bound variables](http://en.wikipedia.org/wiki/Free_variables_and_bound_variables).

### Reason 6: You cannot prove $\forall x \,.\, \phi$ without allowing $x$ to become free

Perhaps we can just forbid free variables altogether and <emph>stipulate</emph> that all variables must always be quantified. But how are you then going to prove $\forall x \in \mathbb{R} \,.\, \phi$? The usual way

> &#8220;Consider any $x \in \mathbb{R}$. Then bla bla bla, therefore $\phi$.&#8221; 

is now forbidden because the first sentence introduces $x$ as a free variable.

We can abolish variables altogether if we wish, by resorting to combinators, but it makes no sense to keep variables and make them all bound all the time.

### Epilogue: so in what sense are they the same?

There is a theorem in model theory:

> Let $\phi$ be a formula in context $x\_1, \ldots, x\_n$ and $M$ a structure in which we can interpret $\phi$. The following are equivalent:
> 
>   1. the universal closure $\forall x\_1, \ldots, x\_n \,.\, \phi$ is valid in $M$,
>   2. for every valuation $\nu : \lbrace x\_1, \ldots, x\_n \rbrace \to M$, $\phi[\nu]$ is valid in $M$.

This is sometimes abbreviated (quite inaccurately) as &#8220;a formula and its universal closure are semantically equivalent&#8221;. This theorem is causing a lot of harm because mathematicians interpret it as &#8220;free variables are implicitly universally bound&#8221;. But the theorem itself clearly distinguishes a formula from its universal closure. It has a limited range of applications in model theory. It is not a general reasoning principle that would allow you to dispose of thinking about free variables.

You are in good company. Philosophers have thought about free variables for millennia, although they phrase the problem in the language of [universals](http://en.wikipedia.org/wiki/Universal_(metaphysics)) and [particulars](http://en.wikipedia.org/wiki/Particular). They wonder whether &#8220;dog&#8221; is the same thing as the set of all dogs, or perhaps there is an ideal dog which is &#8220;pure dogness&#8221;, but then do we need two ideal dogs to make ideal pups, etc. The answer is simple: a free variable is a projection from a cartesian product.