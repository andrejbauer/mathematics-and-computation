---
id: 1320
title: How to implement dependent type theory II
date: 2012-11-11T17:48:41+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=1320
permalink: /2012/11/11/how-to-implement-dependent-type-theory-ii/
categories:
  - Type theory
  - Programming
  - Software
  - Tutorial
---
I am on a roll. In the second post on how to implement dependent type theory we are going to:

  1. Spiff up the syntax by allowing more flexible syntax for bindings in functions and products.
  2. Keep track of source code locations so that we can report _where_ the error has occurred.
  3. Perform [normalization by evaluation](http://en.wikipedia.org/wiki/Normalisation_by_evaluation).

<!--more-->

The relevant Github repository is [andrejbauer/tt/](https://github.com/andrejbauer/tt/tree/blog-part-II) (branch blog-part-II). By the way, there are probably bugs in the implementation, I am not spending a huge amount of time on testing (mental note: put &#8220;implement testing&#8221; on the to do list). If you discover one, please tell me, or preferrably make a pull request with a fix. This also applies to old branches.

### Source code positions

Source code positions seem like an annoyance because they pollute our nice datatypes. Nevertheless, an even bigger annoyance is an error message without an indication of its position.

The OCaml lexer keeps track of positions, and menhir has support for them, so we just need to incorporate them into our program. Every expression should be tagged with the source code position it came from. Sometimes we generate expressions with no associated position, so we define:

<pre class="brush: plain; title: ; notranslate" title="">type position =
  | Position of Lexing.position * Lexing.position
  | Nowhere
</pre>

The type `Lexing.position` is the one from OCaml lexer. Each expression is associated with two such positions, its beginning and end. To tag expressions with positions we define two types: `expr` is an expression with a position and `expr'` without (I stole the idea from [Matija Pretnar](http://matija.pretnar.info/)&#8216;s [eff](/eff/) code):

<pre class="brush: plain; title: ; notranslate" title="">(** Abstract syntax of expressions. *)
type expr = expr' * position
and expr' =
  | Var of variable
  | Universe of int
  | Pi of abstraction
  | Lambda of abstraction
  | App of expr * expr

(** An abstraction [(x,t,e)] indicates that [x] of type [t] is bound in [e]. *)
and abstraction = variable * expr * expr
</pre>

Note that `expr'` refers back to `expr` so that subexpressions come equipped with their positions. We generally follow the rule that an apostrophe is attached to a type or a function which is position-less. Except that apostrohpies are not valid in the names of grammatical rules in the parser, so in [parser.mly](https://github.com/andrejbauer/tt/blob/blog-part-II/parser.mly) we write `plain_expr` instead of `expr'`.

We also extend the pretty printer and error reporting with positions, feel free to consult the source code.

### Better syntax for bindings

This is a fairly trivial change. It is annoying to have to write things like

<pre class="brush: plain; title: ; notranslate" title="">fun x : A =&gt; fun y : A =&gt; fun z : B =&gt; fun w : B =&gt; ...
</pre>

We improve the parser so that it accepts syntax like

<pre class="brush: plain; title: ; notranslate" title="">fun (x y : A) (z w : B) =&gt; ...
</pre>

Let us read out the relevant portion of [parser.mly](https://github.com/andrejbauer/tt/blob/blog-part-II/parser.mly), namely the rules `abstraction`, `bind1` and `binds`:

<pre class="brush: plain; title: ; notranslate" title="">abstraction:
  | b = bind1
    { [b] }
  | bs = binds
    { bs }

bind1: mark_position(plain_bind1) { $1 }
plain_bind1:
  | xs = nonempty_list(NAME) COLON t = expr
    { (List.map (fun x -&gt; String x) xs, t) }

binds:
  | LPAREN b = bind1 RPAREN
    { [b] }
  | LPAREN b = bind1 RPAREN lst = binds
    { b :: lst }
</pre>

A `bind1` is something of the form `x y ... z : t`. A `binds` is a non-empty list of parenthesized `bind1`&#8216;s. An abstraction is either a `bind1` or a `binds`. Thus we can write `fun x y z : t => ...` and `fun (x y z : t) => ...` and `fun (x y : t) (z : t) => ...` but not `fun x y : y (z : t) => ...`.

### Normalization by evaluation

In the first version we performed normalization by substitution, just like theory books say we should. But this is horribly inefficient. We could improve efficiency by keeping a current substitution (a &#8220;runtime&#8221; environment) which maps variables to the expressions. When we encounter a variable we look up its value in the current substitution. This way at least we do not keep traversing expressions during substitutions.

An even cooler way to normalize is known as normalization by evaluation. We first &#8220;evaluate&#8221; expressions to actual OCaml values in such a way that definitionally equal expressions evaluate to (observationally) equivalent values, and then we reconstruct the expression from the value (the fancy speak is that we [reify](http://dictionary.reference.com/browse/reify) the value). Apart from giving us a normal form there are all sorts of other benefits (Dan Grayson keeps asking me which, perhaps the more knowledgable readers can point them out).

We need a datatype `value` into which we evaluate expressions. We need to evaluate expressions with free variables, which means that we are going to get stuck on applications of the form `x v1 v2 .. vn` where `x` is a free variable (these are called head-normal). We collect those in a separate datatype `neutral`:

<pre class="brush: plain; title: ; notranslate" title="">type value =
  | Neutral of neutral
  | Universe of int
  | Pi of abstraction
  | Lambda of abstraction

and abstraction = variable * value * (value -&gt; value)

and neutral =
  | Var of variable
  | App of neutral * value
</pre>

Abstractions will be evaluated to OCaml functions (so OCaml will take care of substitutions). Thus an abstraction like `fun x : t => e` should be evaluated to a pair `(u, v)` where `u` is the value of `t` and `v` is the function $x \mapsto e$. But if you look at the definition of `abstraction` above you see that we also keep around the variable name. This we do for pretty-printing purposes. When we reify an evaluated abstraction back to its expression form, we use the variable name as a hint.

You should take the time to read [`value.ml`](https://github.com/andrejbauer/tt/blob/blog-part-II/value.ml) which contains evaluation and reification, and comparison of values. Also note that `Infer.normalize` really is just the composition of evaluation and reification.

We are now at 759 lines of code. We added 90 codes for evaluation by normalization and 51 for the for keeping track of source code positions.

### Trying something out

Ok, let us try something fun. How about [Church numerals](http://en.wikipedia.org/wiki/Church_encoding)?

<pre class="brush: plain; title: ; notranslate" title="">Parameter N : Type 0.
Parameter z : N.
Parameter s : N -&gt; N.

Definition numeral := forall A : Type 0, (A -&gt; A) -&gt; (A -&gt; A).

Definition zero := fun (A : Type 0) (f : A -&gt; A) (x : A) =&gt; x.
Definition one := fun (A : Type 0) (f : A -&gt; A) =&gt; f.
Definition two := fun (A : Type 0) (f : A -&gt; A) (x : A) =&gt; f (f x).
Definition three := fun (A : Type 0) (f : A -&gt; A) (x : A) =&gt; f (f (f x)).

Definition plus :=
  fun (m n : numeral) (A : Type 0) (f : A -&gt; A) (x : A) =&gt; m A f (n A f x).

Definition times :=
  fun (m n : numeral) (A : Type 0) (f : A -&gt; A) (x : A) =&gt; m A (n A f) x.

Definition power :=
  fun (m n : numeral) (A : Type 0) =&gt; m (A -&gt; A) (n A).
  
Definition four := plus two two.
Definition five := plus two three.
</pre>

If you put the above code in `church.tt` you can load it into `tt` by

<pre class="brush: plain; title: ; notranslate" title="">./tt.native -l church.tt
</pre>

Dare we compute $2^{16}$? Sure:

<pre class="brush: plain; title: ; notranslate" title=""># Eval power two (power two four) N s z.
    = s (s (s (s (s (s (s (s (s (s (s (s (s (s (s (s (s (s (s (s (s (s (s (s (s (s (s (s
      (s (s (s (s (s (s (s (s (s (s (... (...)))))))))))))))))))))))))))))))))))))))
    : N
</pre>

It takes a moment, but that is mostly because of pretty-printing (if you evaluate the same expression in non-interactive mode by placing it in a file, you will notice no delay). How about $2^{20}$?

<pre class="brush: plain; title: ; notranslate" title=""># Eval power two (times four five).
Fatal error: exception Stack_overflow
</pre>

Oh well. We will have to do something smarter (I am open to suggestions), or increase the stack size. Next time we are going some more types, and then I would like to focus on how to implement an interactive mode.
