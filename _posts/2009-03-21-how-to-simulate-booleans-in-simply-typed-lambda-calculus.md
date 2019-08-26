---
id: 168
title: How to simulate booleans in simply typed lambda calculus?
date: 2009-03-21T11:22:36+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=168
permalink: /2009/03/21/how-to-simulate-booleans-in-simply-typed-lambda-calculus/
categories:
  - Computation
---
I have been writing lecture notes on computable mathematics. One of the questions that came up was whether it is possible to simulate the booleans in the [simply-typed $\lambda$-calculus](http://en.wikipedia.org/wiki/Simply_typed_lambda_calculus). This is a nice puzzle in functional programming. If you solve it, definitely let me know, although I suspect logicians did it a long time ago.<!--more-->

The simply-typed $\lambda$-calculus is a purely functional language in which we have a single base type, functions, and pairs. In this language every term normalizes, so we cannot write a non-terminating program, and it does not matter whether we evaluate eagerly or lazily. To make things more concrete, let me rephrase this as a fragment of Haskell (Ocaml or ML would do just as well). We may use _only the following constructs_:

  1. An abstract &#8220;base&#8221; type, which is traditionally denoted by _O_ (the letter). In Ocaml this would be a type whose implementation is hidden by a signature. I am not quite sure what it is in Haskell, but it could be a type parameter about which nothing is known. For practical purposes we may take _O_ to be _Int_ and make sure we do not use anything specific about _Int_.
  2. Functions: we may form functions by $\lambda$-abstraction and apply them. Very importantly, _all variables must be explicitly typed (polymorphism is forbidden)._ For example, it is ok to write `\(x :: O) -> x` but not `\x -> x` because that would be polymorphic. (We must include the pragma `{-# LANGUAGE PatternSignatures #-}` in Haskell code to allow explicitly typed variables.)
  3. Pairs: we may form pairs and use the projections `fst` and `snd`. This is really just a convenience, because we can always eliminate pairs by currying.

The question is this: is there a type _Boolean_ (constructed from the base type _O_ using function types and product types) with values

> <pre>true  :: Boolean
false  :: Boolean</pre>

and for each type `t` a constant

> <pre>cond_t :: Boolean -&gt; t -&gt; t -&gt; t</pre>

such that, for all `x` and `y` of type `t`:

> <pre>cond_t true  x y = x
cond_t false x y = y</pre>

Notice that since polymorphism is forbidden, we have a family of constants `cond_t`, one for each type `t`, that simulate the conditional statement.

#### Booleans via polymorphism

If we allow polymorphic functions, the booleans may be defined thus:

> <pre>type Boolean t = t -&gt; t -&gt; t
true, false :: Boolean t
true  x y = x
false x y = y
cond :: Boolean t -&gt; t -&gt; t -&gt; t
cond  b x y = b x y</pre>

Of course, since we have polymorphism a single `cond` does the job.

I suspect the answer is negative and the booleans cannot be simulated.