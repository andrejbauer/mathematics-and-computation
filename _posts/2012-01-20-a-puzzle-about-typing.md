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

<pre class="brush: plain; gutter: false; title: ; notranslate" title=""># fun a b c -&gt; (a b) (fun d -&gt; d c) ;;
- : ('a -&gt; (('b -&gt; 'c) -&gt; 'c) -&gt; 'd) -&gt; 'a -&gt; 'b -&gt; 'd = &lt;fun&gt;

# fun a b c d e e' f g h i j k l m n o o' o'' o''' p q r r' s t u u' v w x y z -&gt;
    q u i c k b r o w n f o' x j u' m p s o'' v e r' t h e' l a z y d o''' g;;
  - : 'a -&gt; 'b -&gt; 'c -&gt; 'd -&gt; 'e -&gt; 'f -&gt; 'g -&gt; 'h -&gt; 'i -&gt; 'j -&gt;
    'k -&gt; 'l -&gt; 'm -&gt; 'n -&gt; 'o -&gt; 'p -&gt; 'q -&gt; 'r -&gt; 's -&gt; 't -&gt;
    ('u -&gt; 'j -&gt; 'c -&gt; 'l -&gt; 'b -&gt; 'v -&gt; 'p -&gt; 'w -&gt; 'o -&gt; 'g -&gt;
     'q -&gt; 'x -&gt; 'k -&gt; 'y -&gt; 'n -&gt; 't -&gt; 'z -&gt; 'r -&gt; 'a1 -&gt; 'e -&gt;
     'b1 -&gt; 'c1 -&gt; 'i -&gt; 'f -&gt; 'm -&gt; 'a -&gt; 'd1 -&gt; 'e1 -&gt; 'd -&gt; 's
     -&gt; 'h -&gt; 'f1) -&gt; 'v -&gt; 'b1 -&gt; 'z -&gt; 'c1 -&gt; 'u -&gt; 'y -&gt; 'a1
     -&gt; 'w -&gt; 'x -&gt; 'e1 -&gt; 'd1 -&gt; 'f1 = &lt;fun&gt;
</pre>

What is the easiest way to see that this really is the case?

A related question is this (I am sure people have thought about it): how big can a type of a typeable $\lambda$-term be? For example, the Ackermann function can be typed as follows, although the type prevents it from doing the right thing in a typed setting:

<pre class="brush: plain; gutter: false; title: ; notranslate" title=""># let one = fun f x -&gt; f x ;;
val one : ('a -&gt; 'b) -&gt; 'a -&gt; 'b =
# let suc = fun n f x -&gt; n f (f x) ;;
val suc : (('a -&gt; 'b) -&gt; 'b -&gt; 'c) -&gt; ('a -&gt; 'b) -&gt; 'a -&gt; 'c =
# let ack = fun m -&gt; m (fun f n -&gt; n f (f one)) suc ;;
val ack :
  ((((('a -&gt; 'b) -&gt; 'a -&gt; 'b) -&gt; 'c) -&gt;
   (((('a -&gt; 'b) -&gt; 'a -&gt; 'b) -&gt; 'c) -&gt; 'c -&gt; 'd) -&gt; 'd) -&gt;
   ((('e -&gt; 'f) -&gt; 'f -&gt; 'g) -&gt; ('e -&gt; 'f) -&gt; 'e -&gt; 'g) -&gt; 'h) -&gt; 'h = &lt;fun&gt;
</pre>

That&#8217;s one mean type there! Can it be &#8220;explained&#8221;? Hmm, why _does_ `ack` compute the Ackermann function in the untyped $\lambda$-calculus?
