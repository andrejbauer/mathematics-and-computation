---
title: Runners in action
author: Andrej Bauer
layout: post
categories:
  - Programming languages
  - Software
  - Publications
---

It has been almost a decade since [Matija Pretnar](http://matija.pretnar.info)
and I posted the [first blog posts](http://math.andrej.com/category/eff/) about
programming with algebraic effects and handlers and the programming language
[Eff](http://www.eff-lang.org). Since then handlers have become a well-known
control mechanism in programming languages.

Handlers and monads excel at *simulating* effects, either in terms of other
effects or as pure computations. For example, the familiar [state
monad](https://wiki.haskell.org/State_Monad) implements mutable state with
(pure) state-passing functions, and there are many more examples. But I have
always felt that handlers and monads are not very good at explaining how a
program interacts with its external environment and how it gets to perform
*real-world* effects.

[Danel Ahman](https://danel.ahman.ee) and I have worked for a while on attacking
the question on how to better model external resources and what programming
constructs are appropriate for working with them. The time is right for us to
show what we have done so far. The theoretical side of things is explained in
our paper [**Runners in action**](http://arxiv.org/abs/1910.11629), Danel
implemented a Haskell library
[**Haskell-Coop**](https://github.com/danelahman/haskell-coop) to go with the
paper, and I implemented a programming language
[**Coop**](https://github.com/andrejbauer/coop).

<!--more-->

General-purpose programming languages, even the so-called pure ones, have to have
*some* account of interaction with the external environment. A popular choice is
to provide a foreign-function interface that connects the language with an
external library, and through it with an operating system and the universe. A
more nuanced approach would differentiate between a function that just happens
to be written in a different language, and one that actually performs an effect.
The latter kind is known as an *algebraic operation* in the
algebraic-effects-and-handlers way of doing things.

A *bad* approach to modeling the external world is to pretend that it is
internal to the language. One would think that this is obvious but it is not.
For instance, Haskell represents the interface to the external world through the
[`IO`
monad](https://www.haskell.org/onlinereport/haskell2010/haskellch41.html#x49-32100041.1).
But what is this monad *really*? How does it get to interact with the external
world? The Haskell Wiki page which answers this question has [the following
disclaimer](https://wiki.haskell.org/IO_inside#Welcome_to_the_RealWorld.2C_baby):

> *"Warning: The following story about `IO` is incorrect in that it cannot
> actually explain some important aspects of `IO` (including interaction and
> concurrency). However, some people find it useful to begin developing an
> understanding."*

The Wiki goes on to say how `IO` is a bit like a state monad with an imaginary
`RealWorld` state, except that of course `RealWorld` is not really a Haskell
type, or at least not one that actually holds the state of the real world.

The situation with Eff is not much better: it treats some operations at the
top-level in a special way. For example, if `print` percolates to the top level,
it turns into a *real* `print` that actually causes an effect. So it looks like
there is some sort of "top level handler" that models the real world, but that
cannot be the case: a handler may discard the continuation or run it twice, but
Eff hardly has the ability to discard the external world, or to make it
bifurcate into two separate realities.

If `IO` monad is not an honest monad and a top-level handler is not really a
handler, then what we have is a case of ingenious hackery in need of proper
programming-language design.

How precisely does an operation call in the program cause an effect in the
external world? As we have just seen, some sort of runtime environment or top
level needs to relate it to the external world. From the viewpoint of the
program, the external world appears as state which is not directly accessible,
or even representable in the language. The effect of calling an operation
$\mathtt{op}(a,\kappa)$ is to change the state of the world, and to get back a
result. We can model the situation with a map $\overline{\mathtt{op}} : A \times
W \to B \times W$, where $W$ is the set of all states of the world, $A$ is the
set of parameters, and $B$ the set of results of the operation. The operation
call $\mathtt{op}(a, \kappa)$ is "executed" in the current world $w \in W$ by
computing $\overline{\mathtt{op}}(a,w) = (b, w')$ to get the next world $w'$ and
a result $b$. The program then proceeds with the continuation $\kappa\,b$ in the
world $w'$. Notice how the world $w$ is an external entity that is manipulated
by the external map $\overline{\mathtt{op}}$ realistically in a *linear*
fashion, i.e., the world is neither discarded nor copied, just transformed.

What I have just described is *not* a monad or a handler, but a *comodel*, also
known as a *runner*, and the map $\overline{\mathtt{op}}$ is not an operation,
but a *co-operation*. This was all observed a while ago by [Gordon
Plotkin](http://homepages.inf.ed.ac.uk/gdp/) and [John
Power](https://scholar.google.co.uk/citations?user=aOCekqQAAAAJ), [Tarmo
Uustalu](https://www.ioc.ee/~tarmo/), and generalized by [Rasmus
Møgelberg](http://www.itu.dk/people/mogel/) and [Sam
Staton](https://www.cs.ox.ac.uk/people/samuel.staton/main.html), see our paper
for references. Perhaps we should replace "top-level" handlers and "special"
monads with runners?

Danel and I worked out how *effectful* runners (a generalization of runners that
supports other effects in addition to state) provide a mathematical model of
resource management. They also give rise to a programming concept that models
top-level external resources, as well as allows programmers to modularly define
their own “virtual machines” and run code inside them. Such virtual machines can
be nested and combined in interesting ways. We capture the core ideas of
programming with runners in an equational calculus $\lambda_{\mathsf{coop}}$,
that guarantees the linear use of resources and execution of finalization code.

An interesting practical aspect of $\lambda_{\mathsf{coop}}$, that was begotten by
theory, is modeling of extra-ordinary circumstances. The external environment
should have the ability to signal back to the program an extra-ordinary
circumstance that prevents if from returning a result. This is normally
accomplished by an exception mechanism, but since the external world is
stateful, there are *two* ways of combining it with exceptions, namely the sum
and the tensor of algebraic theories. Which one is the right one? Both! After a
bit of head scratching we realized that the two options are (analogous to) what
is variously called ["checked" and "non-checked"
exceptions](https://docs.oracle.com/javase/tutorial/essential/exceptions/runtime.html),
[errors](http://man7.org/linux/man-pages/man3/errno.3.html) and
[signals](http://man7.org/linux/man-pages/man7/signal.7.html), or [synchronous
and asynchronous
exceptions](https://www.repository.cam.ac.uk/bitstream/handle/1810/283239/paper.pdf?sequence=3&isAllowed=y).
And so we included in $\lambda_{\mathsf{coop}}$ both mechanisms: ordinary
*exceptions*, which are special events that disrupt the flow of user code but
can be caught and attended to, and *signals* which are unrecoverable failures
that irrevocably *kill* user code, but can still be finalized. We proved a finalization
theorem which gives strong guarantees about resources always being properly
finalized.

If you are familiar with handlers, as a first approximation you can think of
runners as handlers that use the continuation at most once in a tail-call
position. Many handlers are already of this form but not all. Non-determinism,
probability, and handlers that hijack the continuation (`delimcc`, threads, and
selection functionals) fall outside of the scope of runners. Perhaps in the
future we can resurrect some of these (in particular it seems like threads, or
even some form of concurrency would be worth investigating). There are many
other directions of possible future investigations: efficient compilation, notions
of correctness, extensions to the simple effect subtyping discipline that we
implemented, etc.

To find out more, we kindly invite you to have a look at the
[paper]((http://arxiv.org/abs/1910.11629)), and to try out the implementations.
The prototype programming language [Coop](https://github.com/andrejbauer/coop)
implements and extends $\lambda_{\mathsf{coop}}$. You can start by skimming the
[Coop manual](https://github.com/andrejbauer/coop/blob/master/Manual.md) and the
[examples](https://github.com/andrejbauer/coop/tree/master/examples). If you
prefer to experiment on your own, you might prefer the
[Haskell-Coop](https://github.com/danelahman/haskell-coop) library, as it allows
you to combine runners with everything else that Haskell has to offer.
