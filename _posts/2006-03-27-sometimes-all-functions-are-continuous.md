---
id: 36
title: Sometimes all functions are continuous
date: 2006-03-27T16:30:22+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/2006/03/27/sometimes-all-functions-are-continuous/
permalink: /2006/03/27/sometimes-all-functions-are-continuous/
categories:
  - Computation
  - Constructive math
  - Tutorial
---
You may have heard at times that there are mathematicians who think that _all_ functions are continuous. One way of explaining this is to show that all _computable_ functions are continuous. The point not appreciated by many (even experts) is that the truth of this claim depends on what programming language we use.  
<!--more-->

#### Surely they are not all continuous!?

You must be thinking to yourself: how can anyone in their right mind claim that all functions are continuous &#8211; here&#8217;s one that isn&#8217;t:  
$$\mathrm{sgn}(x)=\begin{cases}  
-1 & x < 0 \\  
0 & x = 0 \\  
1 & x > 0  
\end{cases}$$  
At $x=0$ the sign function jumps from $-1$ to $0$ to $1$, which is a nice discontinuity. As crazy as it seems, it makes sense to refuse to admit that $\textrm{sgn}$ is a legitimate function!

The official definition nowadays is that a function $f : A \to B$ is the same thing as a _functional relation_ on $A \times B$. Recall that a relation $R$ on $A \times B$ is just a subset of $A \times B$. It is functional when it is

  * _single-valued:_ if $(x,y) \in R$ and $(x,z) \in R$ then $y = z$.
  * _total:_ for every $x \in A$ there is $y \in B$ such that $(x,y) \in R$.

If you are a programmer or a computer-sciency mathematician, you will probably recite the above definition when asked by a judge what a function is. Alas, your own brain secretly thinks that functions are the same thing as procedures that you can implement on your computer. Perhaps you will not admit it, but a careful psychoanalysis of your mind would reveal, among other things, that you never ever concern yourself with non-computable functions. (Note: if you are a physicst, your mind is of a different sort. I shall address your psychology on another day.)

#### There are no discontinuous ones

So for a moment let us shake off the prejudices of classical training and accept the following definition, which is accepted in certain brands of constructive mathematics.

> **Definition:** A _function_ $f : A \to B$ is a computational procedure which takes as an input $x \in A$ and yields as output a uniquely determined $y \in B$.

We have left out many details here, but the basic intuition is clear: &#8220;It ain&#8217;t a function if it can&#8217;t be computed&#8221;. Now we return to the sign function defined above. Is it a function? In order to compute $\mathrm{sgn}(x)$, we must for any given real number $x$ discover whether it is negative, zero, or positive. So suppose we inspect the digits of $x$ for a while and discover, say, that the first billion of them are all zero. Then $\mathrm{sgn}(x)$ is either $0$ or $1$, but we cannot tell which. In fact, no finite amount of computation will guarantee that we will be able to tell whether $x=0$ or $x > 0$. Since infinite amount of computation is impossible in finite time (please do not drag in quantum computing, it does not help) the sign function cannot be computed. It is not a function!

An argument similar to the one above shows that we cannot hope to compute a function $f : \mathbb{R} \to \mathbb{R}$ at a point of discontinuity. With a more formal treatment we could prove:

> **Theorem:** There are no discontinuous functions.

As long as we stick to functions that can actually be computed, we will never witness a discontinuity. Classicaly, there is no difference between the above theorem and

> **Theorem** (classically equivalent form): All functions are continuous.

When constructive mathematicians says that &#8220;all functions are continuous&#8221; they have something even better in mind. They are telling you that all functions are _computably_ continuous. This is where interesting stuff begins to happen.

#### They might be all continuous

To simplify the argument, let me switch from real-valued functions $\mathbb{R} \to \mathbb{R}$ to something that is more readily handled in a programming language. Instead of the reals, let us consider _Baire space_ $B$, which is the space of all infinite number sequences,  
$$B = \mathbb{N} \to \mathbb{N}.$$  
Programmers will recognize in $B$ the datatype of infinite streams of non-negative integers, or the _total_ elements of type `nat -> nat`. A function $f : B \to \lbrace 0,1 \rbrace$ is said to be classically continuous if the value $f(x)$ depends only on finitely many terms of the input sequence $x$. A function $f$ is _computably continuous_, if we can actually compute an upper bound on how many terms of $x$ are needed to determine $f(x)$. (This characterization of continuity of $f : B \to \lbrace 0,1 \rbrace$ comes from taking the product topology on $B$ and discrete topology on $\lbrace 0,1 \rbrace$.) Since we are concerned with computable continuity we shall drop the qualifier &#8220;computable&#8221; and call it just continuity.

> **Theorem:** All functions $B \to \lbrace 0,1 \rbrace$ are continuous.

Without going into too many details, let me just state that the proof of the above theorem comes down to the following programming exercise.

> **Exercise:** Write a program $m : (B \to \lbrace 0,1 \rbrace) \to B \to \mathbb{N}$ such that, for any $f : B \to \lbrace 0,1 \rbrace$ and $x \in B$ the value of $f(x)$ depends at most on the first $m(f)(x)$ terms of $x$. More precisely, if $M = m(f)(x)$, then for every $y \in B$, if $x\_0 = y\_0$, &#8230;, $x\_M = y\_M$ then $f(x) = f(y)$.

The program $m$ is called a _modulus of continuity functional_ because it gives us information about how $f$ is continuous: any input $y \in B$ which agrees with $x$ in the first $m(f)(x)$ terms gives the same output $f(y)$ as does $f(x)$. Incidentally, such an $m$ is an [order 3 functional](/2006/03/21/interesting-higher-order-functionals/).

A strategy for computing $m(f)(x)$ is clear enough: given $f$ and $x$, inspect the computation of $f(x)$ to discover how much of input $x$ is actually needed to arrive at the answer. Since the computation of $f(x)$ takes only finitely many steps, an infinite prefix of the sequence $x$ will suffice.

Let us write $m$ in a real programming language. How can we do that? The trick is rather obvious, once you think of it. Instead of computing $f(x)$, we compute $f(y)$ where $y$ is special: it gives the same answers as $x$ but it also records the highest index $n$ which was fed to it. In ocaml we get something like this:

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">let m f x =
  let k = ref 0 in
  let y n = (k := max !k n; x n) in
    f y ; !k
</pre>

Function $y$ behaves like $x$, except that it stores in the reference $k$ the highest value of $n$ for which $y n$ has been computed so far. To compute $m(f)(x)$ we evaluate $f y$. After it returns, we look at $k$ to see how many terms $f$ used.

Another possibility is to use exceptions instead of mutable store. This time, we feed $f$ a $y$ which behaves like $x$, except that if $f$ attempts to compute $y n$ for $n \geq k$, we throw an exception. Here $k$ is a variable parameter. First we try to compute $f y$ with $k = 0$. If we get an exception, we catch it and try $k = 1$. As long as we keep getting exceptions, we increase the value of $k$. At some point no exception happens and we know that $f$ looked only at those values $y n$ for which $n \leq k$. The code in ocaml is this:

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">exception Abort
let m f x =
  let rec search k =
    try
      let y n = (if n &lt; k then x n else raise Abort) in
        f y ; k
    with Abort \to search (k+1)
  in
    search 0
</pre>

We now have two solutions, one using mutable store, another using exceptions. Could we use some other feature instead? Yes, we could program $m$ using [continuations](http://en.wikipedia.org/wiki/Continuations), which I leave as an exercise.

An interesting question comes to mind: which programming features, apart from the ones we mentioned above, allow us to program $m$? In terms of Haskell, the same question is which monads allow us to program $m$. Can we do it without any extra features and use just &#8220;pure&#8221; functional programming?

If by pure functional programming we understand a functional programming language with natural numbers, booleans and recusive definitions, also known as [PCF](http://en.wikipedia.org/wiki/Programming_language_for_Computable_Functions), the answer is _no_. The [proof](http://www.cs.bham.ac.uk/~mhe/papers/cca2001.pdf) of this uses denotational semantics and domain theory, and I will not go into it now. You may entertain yourself by trying and failing to define $m$ in pure Haskell or ML, i.e., no side effects, no exceptions, no mutable store, no parallelism, no monads.

As far as I know, nobody has studied systematically which programming features allow us to program $m$. So I pose it as a question:

> _What can be said about those programming features X for which PCF+X causes all functions to be computably continuous?_

We know mutable store, exceptions and continuations give us continuity of all functions. Some other candidates to think about are: parallelism, non-determinism, communication channels, timeouts (interrupting computations that take too long) and unqouting (disassembling the code at run-time).

#### Type II Computability

Very likely &#8220;Type 2 Computability&#8221; experts are lurking around. This comment is for them. In Type 2 Computability we do not work with a programming language but directly with (Type 2) Turing machines. There is a well-known proof that in this setting the modulus of continuity $m$ is computable. The proof uses the fact that functions $B \to \lbrace 0,1 \rbrace$ are represented in such a way that the value of $m(f)(x)$ can be read off the tape directly.

Type II Turing machines are not special. They _are_ just another programming language in disguise. In comparison with pure functional programming, a Type II Turing machine can do the following special thing: it can do a thing for a while, and if it takes too long, it just stops doing it and does something else instead. The programming feature that this corresponds to is _timeout_, which works as follows: $\mathtt{timeout}\, k\, x\, y$ evaluates $x$ for at most $k$ steps. If $x$ evaluates successfully within $k$ steps, its value is returned. If the evaluation of $x$ is interrupted, $y$ is evaluated instead. I have heard John Longley claim that Type II Turing machines are equivalent to PCF+timeout+catch (where &#8220;catch&#8221; is a form of local exceptions), but I think the question was never settled. It would be interesting to know, because then we could replace arguments using Turing machines with source code written in ML+timeout+catch.

#### Is there a lesson?

The lesson is for those &#8220;experts&#8221; who &#8220;know&#8221; that all reasonable models of computation are equivalent to Turing machines. This is true if one looks just at functions from $\mathbb{N}$ to $\mathbb{N}$. However, at higher types, such as the type of our function $m$, questions of representation become important, and it does matter which model of computation is used.