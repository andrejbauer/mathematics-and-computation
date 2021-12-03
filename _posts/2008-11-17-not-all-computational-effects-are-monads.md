---
id: 109
title: Not all computational effects are monads
date: 2008-11-17T14:53:32+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=109
permalink: /2008/11/17/not-all-computational-effects-are-monads/
categories:
  - Computation
---
Lately I've been thinking about computational effects _in general_, i.e., what is the structure of the “space of all computational effects”. We know very little about this topic. I am not even sure we know what “the space of all computational effects” is. Because Haskell is very popular and in Haskell computational effects are expressed as monads, many people might think that I am talking about the space of all monads. But I am not, and in this post I show two computational effects which are not of the usual Haskell monad kind. They should present a nice programming challenge to Haskell fans.<!--more-->

Computational effects are things like non-termination, exceptions, state, input/output, continuations, non-determinism, and others. In Haskell these are represented as monads, and in fact there is a whole [industry of Haskell monads](http://sigfpe.blogspot.com/). But how about the following two examples?

### Catch

First we fix a particular operational semantics for (pure) Haskell so that the order of execution is determined (of course, from within pure Haskell we cannot detect the order). We now adjoin to Haskell a new constant

> `catch :: ((a -> b) -> c) -> Maybe a` 

which allows us to detect the fact that a function is evaluated at an argument. More precisely, given any

> `f :: (a -> b) -> c`

`catch f` inspects evaluation of `f g` where the argument `g :: a -> b` is specially crafted so that:

  * if `f` attempts to evaluate `g` at an argument `x` then `catch f` evaluates to `Just x`,
  * otherwise, if `f` evaluates to a result without ever evaluating `g` at any argument then `catch f` evaluates to `Nothing`, and
  * if `f` diverges without evaluating `g` then `catch f` diverges, also.

For example:

  * `catch (\g -> 42)` evaluates to `Nothing`
  * `catch (\g -> \x -> g (g x))` evaluates to `Nothing`
  * `catch (\g -> g 1 + g 2)` evaluates to `Just 1`, assuming that + is evaluated from left to right.

With access to the underlying Haskell compiler or interpreter we could implement `catch`. We can also _simulate_ `catch` within Haskell using exceptions. The idea is quite simple: `catch f` passes to `f` a function which raises an exception when it is evaluated, then `catch` intercepts the exception. Like this:

> <pre>module Katch where

-- In order to avoid conflicts with Haskell's Prelude.catch we
-- call our function "katch"

-- To keep things self-contained, we define our own mini exception monad

data Exception e a = Success a | Failure e deriving Show

instance Monad (Exception e) where
    return = Success
    (Failure x) >>= _   = Failure x
    (Success x) >>= f   = f x

throw :: e -> Exception e a
throw = Failure

intercept :: Exception e a -> (e -> a) -> a
intercept (Success x) _ = x
intercept (Failure x) h = h x

-- Now we may simulate catch by throwing an exception and intercepting it.
-- Of course, the type of katsch reflects the fact that exceptions are used
-- under the hood.

katsch :: ((a -> Exception a b) -> Exception a c) -> Maybe a
katsch f = intercept
           (do y <- f (\x -> throw x)
               return Nothing)
           (\x -> Just x)

-- Examples (must now be written in monadic style)
a = katsch (\g -> return 42)                      -- Nothing
b = katsch (\g -> return (\x -> do y <- g x       -- Nothing
                                   z <- g y
                                   return z))
c = katsch (\g -> do x <- g 1;                    -- Just 1
                     y <- g 2;
                     return (x + y))</pre>

This works but is unsatisfactory. I don't want to simulate `catch` with exceptions. Is there a way to do `catch` directly? I do not know, since it is not even clear to me that we have a monad.

### Timeout

The second example is easier to understand than the first one. Assume we have an operational semantics of Haskell in which it is possible to count steps of execution. Exactly what is “one step” does not matter. The important thing is that a diverging computation has infinitely many steps, whereas a terminating one has finitely many steps. Define a special operation

> `timeout :: Integer -> a -> Maybe a`

such that `timeout k e` evaluates to `Just v` if `e` evaluates to `v` in at most `k` steps of execution, and to `Nothing` if evaluation of `e` takes more than `k` steps. This could be implemented in an interpreter or compiler by keeping a counter of execution steps (we would actually need a stack of counters, one for each invocation of timeout).

Here is an attempt to implement timeout as a Haskel monad (think of the clock “ticking” when you read the code):

> <pre>module Timeout where

-- We represent values together with number of steps needed to compute them
data Timeout a = Ticks (Integer, a)

tick x = Ticks (1, x)

instance Monad (Timeout) where
    return               = tick
    Ticks (j, x) >>= f   = let Ticks (k, y) = f x in Ticks (1+j+k, y)

timeout :: Integer -> Timeout a -> Maybe a
timeout n a = let Ticks (k, v) = a in
              if k <= n then Just v else Nothing

-- Examples
a = timeout 4 (do x <- tick 7      -- Nothing
                  y <- tick 5
                  return (x + y))

b = timeout 5 (do x <- tick 7      -- Just 12
                  y <- tick 5
                  return (x + y))

-- This example should evaluate to Nothing
c = timeout 5 (omega 0) where omega n = do m <- tick (n+1)
                                           omega m</pre>

It is understandable, albeit annoying, that we have to “tick” basic computation steps explicitly. But the real trouble is that the last example diverges when it should evaluate to `Nothing`. This is happening because the monad just counts steps of execution without ever aborting evaluation. What we really need is a monad which stops the execution when the allowed number of steps has been reached. I think this can be done, and I hope someone will tell me how, myabe with a [comonad](http://www.cs.helsinki.fi/u/ekarttun/comonad/) or [some such](http://www.haskell.org/arrows/).
