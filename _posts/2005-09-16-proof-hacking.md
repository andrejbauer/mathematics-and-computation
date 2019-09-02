---
id: 30
title: Proof hacking
date: 2005-09-16T00:33:00+02:00
author: Andrej Bauer
excerpt: A neat example of propositions-as-types using recursion.
layout: post
guid: http://math.andrej.com/?p=30
permalink: /2005/09/16/proof-hacking/
categories:
  - Computation
  - Logic
  - Tutorial
---
I recently lectured at an EST training workshop in Fischbachau, Germany. There were also a number of student talks, one of which was given by [Luca Chiarabini](http://www.mathematik.uni-muenchen.de/~chiarabi/) from Munich. He talked about extraction of programs from proofs, using (a variant of) [Curry-Howard isomorphism](http://en.wikipedia.org/wiki/Curry-Howard_isomorphism), also known as _propositions-as-types_. He had some very interesting ideas which were obviously related to old programming tricks, but he approached them from the logical point of view, rather than the programmer&#8217;s point of view. It got me thinking about how to write certain recursive programs as proofs. Since it is a nice application of program extraction, I want to share it with you here. 

<!--more-->

First, if you have never heard of propositions-as-types or Curry-Howard, you should [get acquantied](http://en.wikipedia.org/wiki/Curry-Howard_isomorphism) and come back here. Or you can just read on and pretend you understand (a strategy which works surprisngly well, after a while you can convince even _yourself_ that you understand). 

You have heard that in the propositions-as-types correspondence conjunction is cartesian product, and implication is function types. Have you every asked what induction on natural numbers correspond to? First recall that the proof rule for induction looks like this:

> \`(x\_0:P(0) qquad f: forall n in NN. (P(n) => P(n+1)))/(ind\ x\_0\ f : forall n in NN. P(n))\` 

You should read this &#8220;fraction&#8221; as follows: if \`x\_0\` is a proof of \`P(0)\` and \`f\` is a proof of \`forall n in NN.(P(n) => P(n+1))\`, then \`ind\ x\_0\ f\` is a proof of \`forall n in NN. P(n)\`. Then the question is, what does \`ind\` compute? According to propositions-as-types, \`ind\ x\_0\ f n\` is supposed to give a proof of \`P(n)\`. If you stare at it for long enough you will realize that \`ind\` is just definition by recursion, i.e., \`ind\ x\_0\ f\ n\` computes \`f (f (f &#8230; f(x_0) &#8230;))\` with \`f\` nested \`n\` times. We could program \`ind\` in ML ([ocaml](http://www.ocaml.org), actually) like this:

> <pre>let rec ind x0 f n =
  if n = 0 then x0 else f n (ind x0 f (n-1))
</pre>

For the purposes of this discussion I want to have precise control over how recursive calls happen, so I am going to [thunk](http://en.wikipedia.org/wiki/Thunk) them, and also insert a `print` statement so that we can see what is going on:

> <pre>let rec ind x0 f n =
  print_endline ("Computing n = " ^ (string_of_int n)) ;
  if n = 0 then x0 else f n (fun () -&gt; ind x0 f (n-1))
</pre>

Now we can use `ind` to define a recursive function whose value at \`n+1\` depends on the value at \`n\`. All we need to do is to give the base case \`x_0\` and a function which gets us from the value at \`n-1\` to the value at \`n\` (this function receives \`n\` and a thunk\`p\`. Whenever it evaluates \`p()\`, it gets the value at \`n-1\`). For example, to define the function `pow`, which computes powers of 2 by recursive definition \`pow(0) = 1\` and \`pow(n+1) = pow(n) + pow(n)\`, we would write:

> <pre>let pow = ind 1 (fun n p -&gt; p() + p())
</pre>

This way of programming is very stupid, of course. Nobody would ever compute powers of 2 this way, because we make two recursive calls at each step and end up with an exponential algorithm:

> <pre>Objective Caml version 3.08.3

val ind : 'a -&gt; (int -&gt; (unit -&gt; 'a) -&gt; 'a) -&gt; int -&gt; 'a = &lt;fun&gt;
val pow : int -&gt; int = &lt;fun&gt;
# pow 3;; 
Computing n = 3
Computing n = 2
Computing n = 1
Computing n = 0
Computing n = 0
Computing n = 1
Computing n = 0
Computing n = 0
Computing n = 2
Computing n = 1
Computing n = 0
Computing n = 0
Computing n = 1
Computing n = 0
Computing n = 0
- : int = 8
</pre>

The point of program extraction is to turn such stupid programs into smart ones, which is what Luca talked about. Suppose you are not allowed to change the definition of the `pow` function (because it is defined just so as a mathematical function and many useful theorems are proved from it, and if you fiddled with the definition other things would break). Can we still make a faster `pow` by changing `ind` instead? Sure we can, just pre-evaluate every recursive call:

> <pre>let rec ind' x0 f n =
  print_endline ("Computing n = " ^ (string_of_int n)) ;
  if n = 0 then x0 else
    let y = ind x0 f (n-1) in
      f n (fun () -&gt; y)
</pre>

Now we get a fast `pow`:

> <pre>val ind' : 'a -&gt; (int -&gt; (unit -&gt; 'a) -&gt; 'a) -&gt; int -&gt; 'a = &lt;fun&gt;
# let pow' = ind' 1 (fun n p -&gt; p() + p()) ;;
val pow' : int -&gt; int = &lt;fun&gt;
# pow' 3 ;;
Computing n = 3
Computing n = 2
Computing n = 1
Computing n = 0
- : int = 8
</pre>

The important bit is that we did not change `pow`, only `ind`. Let us now turn the propositions-as-types around and ask, _which proof does `ind'` correspond to_? We have a problem here because we used a `let` construct in `ind'`, and it is not clear what it corresponds to in the propositions-as-types (at least not when we want to distinguish call-by-value and call-by-name). So our first task is to rewrite `ind'` in pure \`lambda\`-calculus. In addition, `ind'` should not make any recursive calls, because we do not know what they correspond to, either. What we _can_ use is the old `ind`, because we know that it corresponds to induction. With a bit of head scratching, I produced the following:

> <pre>let ind' x0 f n =
  ind (fun x y -> y)
      (fun () p x y -> p() (x+1) (f x (fun () -> y)))
      n 0 x0
</pre>

First let us check it still works:

> <pre># let ind' x0 f n =
  ind (fun x y -&gt; y)
      (fun () p x y -&gt; p() (x+1) (f x (fun () -&gt; y)))
      n 0 x0;;
val ind' : 'a -&gt; (int -&gt; (unit -&gt; 'a) -&gt; 'a) -&gt; int -&gt; 'a = &lt;fun&gt;
# let pow' = ind' 1 (fun n p -&gt; p() + p()) ;;
val pow' : int -&gt; int = &lt;fun&gt;
# pow' 3 ;;
Computing n = 3
Computing n = 2
Computing n = 1
Computing n = 0
- : int = 8
</pre>

Good. It works on at least one example. I suppose the new `ind'` requires some explanation. The easiest way to explain what it is doing is to write it without the use of `ind`. This turns into the following recursive function:

> <pre>(** [ind''] is [ind'] without the use of [ind] *)
let ind'' x0 f n =
  let rec helper k x y =
    if k = 0 then y
    else
      helper (k-1) (x+1) (f x (fun () -&gt; y))
  in
    helper n 0 x0
</pre>

Observe that the job is really done by the `helper` function. Notice also that in each step `helper` decreases `k` and increases `x`. So in effect `k` and `x` are the same counter, but they count in different directions. The argument `y` is the previous value of `f`. Thus `helper` gets arguments \`k\`, \`x\`, \`y\` and then calls itself recursively with new arguments \`k-1\`, \`x+1\`,\`f x (lambda ().y)\`. Because `helper` is [tail recursive](http://en.wikipedia.org/wiki/Tail_recursion), we can eliminate the recursion and rewrite it as a simple loop. The arguments become mutable variables when we do this:

> <pre>(** [ind'] as a loop *)
let ind''' x0 f n =
  let k = ref n in
  let x = ref 0 in
  let y = ref x0 in
    while !k &lt;> 0 do
      k := !k - 1 ;
      x := !x + 1 ;
      y := f !x (fun () -&gt; !y)
    done ;
    !y
</pre>

You may or may not find this version easier to understand. Now let us return back to `ind'`. According to the Curry-Howard isomorphism, it corresponds to a proof.  
What does this proof prove? Since `ind'` is just a variant of `ind`, they both prove the same thing, i.e., \`forall n in NN. P(n)\`. The body of `ind'` is of the form `lemma n 0 x0` where `lemma` is the piece of code

> <pre>ind (fun x y -&gt; y) (fun () p x y -&gt; p() (x+1) (f x (fun () -&gt; y)))
</pre>

Remebering that application corresponds either to modus ponens or instantiation of a universal statement, we would expect `lemma` to be the proof of something of the form

> \`forall n in NN. forall m in NN. (P(m) => Q(n,m))\` 

so that when we apply it to \`n\`, \`0\` and \`x\_0\` (remeber that \`x\_0\` is a proof of \`P(0)\`) we get  
a proof of \`Q(n,0)\`. Since \`Q(n,0)\` is supposed to be \`P(n)\`, we take a guess that \`Q(n,m)=P(n+m)\`. This means that `lemma` should be a proof of

> \`forall n in NN. forall m in NN. (P(m) => P(n+m))\`. 

Since `lemma` is a proof by induction, we should check to see if its parts prove the base case and the induction step. The base case \`n = 0\` is \`forall m in NN. (P(m) => P(0+m))\`, which is indeed proved by `fun x y -> y`. The induction step is

> \`forall m in NN. (P(m) => P(n+m))) => forall m in NN. (P(m) => P(n+m+1))\`. 

This also is proved by `fun () p x y -> p() (x+1) (f x (fun () -> y))`, which I will try to explain in few word. Suppose `p` is a proof of \`forall m in NN. (P(m) => P(n+m))\` and `y` is a proof of \`P(m)\`. Then `f m y` is a proof of \`P(m+1)\` because `f` is a proof of \`forall n in NN. (P(n) => P(n+1))\`. So `p (m+1) (f m y)` proves \`P(n+(m+1))\`, as required.

The lesson learnt here is that _smart programs may correspond to seemingly silly proofs_. In our case `ind'` corresponds to proving \`forall m in NN. P(m)\` from \`P(0)\` and \`forall k in NN.(P(k) => P(k+1))\` by first proving the lemma

> \`forall n in NN. forall m in NN. (P(n) => P(n+m))\` 

and then applying it to the case \`n = 0\`. I find it higly non-obvious that proving such a lemma amounts to turning simple recursion to tail-recursion. What we did is in fact a special case of memoization or [dynamic programming](http://en.wikipedia.org/wiki/Dynamic_programming). Two obvious questions to ask are:

  * How do we generalize this idea to more general recursive functions?
  * How can we recognize proofs that encode tail-recursive functions?

I am sure Luca is going to tell us some day what the answers are. 

**Addendum:**  
I claimed it is not clear what `let x = e1 in e2` means as a proof. This is not exactly so, since it is equivalent to `(fun x -> e1) e2`. So the `let`-construct is just the modus ponens rule. Another point worth mentioning is that if `e` is the proof of \`P\` then the thunk `fun () -> e` is the proof of \`TT => P\`.
