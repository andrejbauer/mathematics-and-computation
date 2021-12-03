---
id: 1109
title: A puzzle about typing
date: 2012-01-20T15:42:44+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=1109
permalink: /2012/01/20/a-puzzle-about-typing/
categories:
  - Computation
  - Programming
---
While making a comment on [Stackoverflow](http://cstheory.stackexchange.com/questions/9690/functions-that-typed-lambda-calculus-cannot-compute) I noticed something: suppose we have a term in the $\lambda$-calculus in which no abstracted variable is used more than once. For example, $\lambda a b c . (a b) (\lambda d. d c)$ is such a term, but $\lambda f . f (\lambda x . x x)$ is not because $x$ is used twice. If I am not mistaken, all such terms can be typed. For example:

<pre class="brush: plain; gutter: false; title: ; notranslate" title=""># fun a b c -> (a b) (fun d -> d c) ;;
- : ('a -> (('b -> 'c) -> 'c) -> 'd) -> 'a -> 'b -> 'd = <fun>

# fun a b c d e e' f g h i j k l m n o o' o'' o''' p q r r' s t u u' v w x y z ->
    q u i c k b r o w n f o' x j u' m p s o'' v e r' t h e' l a z y d o''' g;;
  - : 'a -> 'b -> 'c -> 'd -> 'e -> 'f -> 'g -> 'h -> 'i -> 'j ->
    'k -> 'l -> 'm -> 'n -> 'o -> 'p -> 'q -> 'r -> 's -> 't ->
    ('u -> 'j -> 'c -> 'l -> 'b -> 'v -> 'p -> 'w -> 'o -> 'g ->
     'q -> 'x -> 'k -> 'y -> 'n -> 't -> 'z -> 'r -> 'a1 -> 'e ->
     'b1 -> 'c1 -> 'i -> 'f -> 'm -> 'a -> 'd1 -> 'e1 -> 'd -> 's
     -> 'h -> 'f1) -> 'v -> 'b1 -> 'z -> 'c1 -> 'u -> 'y -> 'a1
     -> 'w -> 'x -> 'e1 -> 'd1 -> 'f1 = <fun>
</pre>

What is the easiest way to see that this really is the case?

A related question is this (I am sure people have thought about it): how big can a type of a typeable $\lambda$-term be? For example, the Ackermann function can be typed as follows, although the type prevents it from doing the right thing in a typed setting:

<pre class="brush: plain; gutter: false; title: ; notranslate" title=""># let one = fun f x -> f x ;;
val one : ('a -> 'b) -> 'a -> 'b =
# let suc = fun n f x -> n f (f x) ;;
val suc : (('a -> 'b) -> 'b -> 'c) -> ('a -> 'b) -> 'a -> 'c =
# let ack = fun m -> m (fun f n -> n f (f one)) suc ;;
val ack :
  ((((('a -> 'b) -> 'a -> 'b) -> 'c) ->
   (((('a -> 'b) -> 'a -> 'b) -> 'c) -> 'c -> 'd) -> 'd) ->
   ((('e -> 'f) -> 'f -> 'g) -> ('e -> 'f) -> 'e -> 'g) -> 'h) -> 'h = <fun>
</pre>

That's one mean type there! Can it be “explained”? Hmm, why _does_ `ack` compute the Ackermann function in the untyped $\lambda$-calculus?
