---
id: 35
title: Interesting higher-order functionals
date: 2006-03-21T18:12:47+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/2006/03/21/interesting-higher-order-functionals/
permalink: /2006/03/21/interesting-higher-order-functionals/
categories:
  - General
---
Spaces of higher-order functions are fascinating mathematical objects that we do not know enough about. What are they and what is known about them?

<!--more-->

#### What are functionals

Functionals are higer-order functions, i.e., functions that take functions as arguments or return them as results. Common examples from functional programming are operations on lists such as _map_ and _fold_. In mathematics we find functionals in analysis, e.g.,

  * <span style="font-style: italic">limit of a converging sequence</span> is a functional which takes a converging sequence of real numbers and maps it to its limit,
  * <span style="font-style: italic">derivative</span> is a linear functional \`D:C^1(RR)->C(RR)\` which maps a differentiable function to its derivative,
  * <span style="font-style: italic">definite integration</span> is a linear functional \`I:C([0,1])->RR\` which maps a continuous function \`f:[0,1]->RR\` to its integral \`I(f) = int_0^1 f(x) dx\`.

The _order_ of a functional describes at what level it lives:

  * order 0: numbers and other finite structures, such as lists of numbers
  * order 1: functions from numbers to numbers
  * order 2: functions which take order 1 functions and return numbers
  * order 3: functions which take order 2 functions and return numbers

In general, the order of a functional is the maximum level of nesting of arrows in its type, where we only count nesting on the right of an arrow. So we have:

  * `int * int -> (int -> int)` is order 1
  * `(int -> int) -> int list -> int list` is order 2
  * \`(RR -> RR) xx RR xx RR -> RR\` is order 2
  * `((int -> int) -> int) -> int` is order 3

In general, _functionals over type \`t\`_ are those whose types can be generated from \`t\` by forming functions and functionals of arbitrary order. _Real functionals_ are functionals over the real numbers. There are actually several kinds of functionals:

  * A functional is _computable_ relative to a functional programming language, if there exists a program computing it. Note that it is not obvious at all whether all programming languages yield the same functionals. For example, do ML and Haskell define the same functionals over the integers? Does it matter whether the programming language is equipped with exceptions, or some other feature? The answers to these questions are quite interesting, but are not the topic of this post.
  * We may limit ourselves to those functionals that are _continuous_ in a suitable sense. For example, we might consider _sequential continuity_: a functional \`F\` is sequentially continuous if \`F(lim f\_n) = lim F(f\_n)\` for sequence \`f\_n\` converging to \`f\`. Here a sequence \`f\_n\` is said to converge to \`f\` if \`lim f\_n(x\_n) = f(x)\` whenever \`x_n\` converges to \`x\`.
  * A functional is _partial_ if its value may be undefined.
  * A functional is _total_ if its value is defined at all arguments.

If you would like to read more about functionals, I recommend  [John Longley's](http://www.dcs.ed.ac.uk/home/jrl/) comprehensive survey _“Notions of computability at higher types”_ ([part 1](http://www.dcs.ed.ac.uk/home/jrl/notions1.ps), [part 2](http://www.dcs.ed.ac.uk/home/jrl/notions2.ps), [part 3](http://www.dcs.ed.ac.uk/home/jrl/notions3.ps)).

#### Interesting functionals

Now here is a curious thing: it is hard to think of interesting functionals of order 3, and impossible to find interesting examples at level 4. Let me make this claim more precise.

Let us say that a functional is _interesting_ if it is not expressible from lower-order functionals and [\`lambda\`-calculus](http://en.wikipedia.org/wiki/Lambda_calculus).

**Order 1.** At order 1 anything that is not the identity or the constant function is interesting.

**Order 2. __**Interesting examples of order 2 functionals are not hard to get by:

  * list manipulation functions _map_, _fold_, etc,
  * fixed-point operator \`(t -> t) -> t\` which assigns a fixed point to a function \`t -> t\`,
  * derivative, integration, limit.

A functional of order 2 which does not count as interesting is evaluation of a functon at an argument because it can be defined as \`lambda f. lambda x. f x\`.

**Order 3.** Now we have to think a little. If we take functional programming to be \`lambda\`-calculus with recursion, then the recursion operators at every type count as interesting, although I would prefer not to count them as they essentially only use order 2 features to compute fixed points. A better example of a genuinely interesting order 3 functional in functional programming is [Martín Escardó](http://www.cs.bham.ac.uk/~mhe/)'s program _max_ for computing the maximum of a binary function on Cantor space, which has type \`((NN -> 2) -> 2) -> 2\` where \`2 = {0,1}\` are the boolean values, see Section 13.2. of his “[Synthetic topology of data types and classical spaces](http://www.cs.bham.ac.uk/~mhe/papers/entcs87.pdf)“. We can think of type \`NN -> 2\` as the type of infinite binary sequences. Input to _max_ is a _boolean predicate_ \`p\` on binary sequences. The return value is \`1\` if there exists a binary sequence \`a\` such that \`p(a)=1\` and is \`0\` if \`p(a)=0\` for all sequences \`a\`. Before you look at Martin's program, try defining it Haskell yourself.

An example of functional of order 3 in mathematics is a solution operator which takes a linear differential operator \`Phi\` and solves the differential equation \`Phi(f) = 0\`. It could be argued that this is cheating, since \`Phi\` is usually expressed as \`Phi = p(D)\` where \`D\` is the derivative operator and \`p\` is a polynomial. Thus, the input to \`Phi\` is actually the polynomial \`p\`, which is of order 1.

A better candidate for order 3 in mathematics is [Feynman's path integral](http://en.wikipedia.org/wiki/Path_integral_formulation) which takes as input a functional \`F\` which maps paths (functions) to numbers and computes the “integral” \`int F(f) df\`, with \`f\` ranging over all allowable paths. The pedantic readers will be quick to point out that the naive Feynman path integral does not exist, so we would actually want to consider something like [Wiener integral](http://en.wikipedia.org/wiki/Wiener_integral) instead.

**Order 4.** Here I am completely lost. **If you know of genuinly interesting functionals of order 4, please let me know.** I would prefer examples which are total and continuous, and if possible such that they have no counterpart at lower orders. Mind you, it won't do to just assemble together functionals of lower orders. For an interesting order 4 functional, you would need to say something insightful about order 3. You may look at functional programming, or maybe at functional analysis to get some good candidates. But there do not seem to be any.

I should mention that there is an artificial and unilluminating way of bumping up the order by one. If we view real numbers as Cauchy sequences of rational numbers, each real number appears as an order 1 function on rationals. Thus, automatically any functional of order \`n\` over the reals is a functional of order \`n+1\` over the rational numbers.

I mentioned that not much is known about functionals at higher types. To illustrate this, let us consider what we know about continuous functionals over the natural numbers \`NN\`:

  * Order 0 are simply the natural numbers \`N_0 = NN\`, equipped with the discrete topology.
  * Order 1 are all functions \`N_1 = NN -> NN\`. They form a complete separable metric space, called the _Baire space_, which is 0-dimensional. In fact, every complete separable metric space is a continuous image of Baire space. You would think we know everything about this space. Alas, I am told, the question “how many compact subsets does \`N_1\` have?” is independent of Zermelo-Fraenkel set theory (just like Continuum Hypothesis)!
  * Oder 2 are functionals \`N_2 = (NN -> NN) -> NN\`. With a bit of effort we can equip them with a topology. A good topology to use is the _sequential topology_: a subset \`U sube N\_2\` is sequentially open, if the terms of a convergents sequence \`(f\_n)\_n\` in \`N\_1\` whose limit is in \`U\` are eventually in \`U\`. In sequential topology \`N\_2\` is not first-countable (points do not have countable enighborhood bases). It is totally disconnected (every two distinct points can be separated by a clopen), but it is not known whether \`N\_2\` is zero-dimensional (has a basis of clopens).

[Dag Normann](http://www.math.uio.no/~dnormann/) has spent a considerable amount of time thinking about higher-order total continuous functionals over the natural and the real numbers. He has shown that spaces of functionals over natural numbers may be embedded in spaces of functionals over reals. To appreciate this, try embedding \`(NN -> NN) -> NN\` inside \`(RR -> RR) -> RR\` (where we only take continuous functionals and equip spaces with sequential topologies).

I might have left you with the impression that functionals of higher order which are definable by \`lambda\`-calculus are not interesting at all. This is far from truth. Paul Taylor developed a formulation of topology, called [Abstract Stone Duality](http://www.cs.man.ac.uk/~pt/ASD/), in which he uses some mind-boggling \`lambda\`-calculus of order 4 and higher to express topological notions. I suspect Haskell programmers would have an easier time understanding it than classical topologists. Mathematicians are not used to such stuff.

If we count the order of an axiom as its order under propositions-as-types translation, we discover that most axioms in mathematics go up only to order 2? For example, completness of real numbers (“every Cauchy sequence has a limit”) is an order 2 axiom. An axiom of order 3 is Pierce's law \`((P=>Q)=>P)=>P\`. What about an axiom of order 4?

My point is this: understanding every next level of functionals requires new concepts and fresh ideas. We have not come very far, as we seem to be stuck mostly at order 2.
