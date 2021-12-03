---
id: 1284
title: How to implement dependent type theory I
date: 2012-11-08T07:23:50+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=1284
permalink: /2012/11/08/how-to-implement-dependent-type-theory-i/
categories:
  - Type theory
  - Programming
  - Software
  - Tutorial
---
I am spending a semester at the [Institute for Advanced Study](http://www.ias.edu/) where we have a special year on [Univalent foundations](http://www.math.ias.edu/sp/univalent). We are doing all sorts of things, among others experimenting with type theories. We [have](http://en.wikipedia.org/wiki/Per_Martin-Löf) [got](http://www.cse.chalmers.se/~coquand/) [some](http://pauillac.inria.fr/~herbelin/index-eng.html) [real](http://mattam.org) [experts](http://www.lix.polytechnique.fr/~barras/) [here](http://www.lix.polytechnique.fr/~assia/rech-eng.html) who know type theory and Coq inside out, and much more, and they're doing crazy things to Coq (I will report on them when they are done). In the meanwhile I have been thinking how one might implement dependent type theories with undecidable type checking. This is a tricky subject and I am certainly not the first one to think about it. Anyhow, if I want to experiment with type theories, I need a small prototype first. Today I will present a very minimal one, and build on it in future posts.

Make a guess, how many lines of code does it take to implement a dependent type theory with universes, dependent products, a parser, lexer, pretty-printer, and a toplevel which uses line-editing when available?

<!--more-->If you ever looked at my 

[Programming languages zoo](http://andrej.com/plzoo/) you know it does not take that many lines of code to implement a toy language. On the other hand, dependent type theory is different from a typical compiler because we cannot meaningfully separate the type checking, compilation, and execution phases.

[Dan Licata](http://www.cs.cmu.edu/~drl/) pointed me to [A Tutorial Implementation of a Dependently Typed Lambda Calculus](http://www.andres-loeh.de/LambdaPi/) by [Andreas Löh](http://www.andres-loeh.de), [Connor McBride](http://strictlypositive.org), and [Wouter Swierstra](http://www.staff.science.uu.nl/~swier004/) which is similar to this one. It was a great inspiration to me, and you should have a look at it too, because they do things slightly differently: they use de Bruijn indices, they simplify things by assuming (paradoxically!) that $\mathtt{Type} \in \mathtt{Type}$, and they implement the calculus in [Haskell](http://www.haskell.org/), while we are going to do it in [OCaml](http://www.ocaml.org/).

### A minimal type theory

I am going to assume you are already familiar with Martin-Löf [dependent type theory](http://en.wikipedia.org/wiki/Intuitionistic_type_theory). We are going to implement:

  * a hierarchy of [universes](http://en.wikipedia.org/wiki/Intuitionistic_type_theory#Universes) $\mathtt{Type}\_0$, $\mathtt{Type}\_1$, $\mathtt{Type}_2$, ...
  * [dependent products](http://en.wikipedia.org/wiki/Intuitionistic_type_theory#.CE.A0-types) $\prod_{x : A} B$
  * functions $\lambda x : A . e$, and
  * application $e\_1 \; e\_2$.

We are not going to write down the exact inference rules, although that would be a good idea in a serious experiment. Instead, we are going to read them off later by looking at the source code.

### Syntax

We can directly translate the above to [abstract syntax](http://en.wikipedia.org/wiki/Abstract_syntax) of expressions (in the code below think of the type `variable` as string, we will explain it later):

<pre class="brush: plain; title: ; notranslate" title="">(** Abstract syntax of expressions. *)
type expr =
  | Var of variable
  | Universe of int
  | Pi of abstraction
  | Lambda of abstraction
  | App of expr * expr

(** An abstraction [(x,t,e)] indicates that [x] of type [t] is bound in [e]. *)
and abstraction = variable * expr * expr
</pre>

We choose a concrete syntax that is similar to that of [Coq](http://coq.inria.fr/):

  * universes are written `Type 0`, `Type 1`, `Type 2`, ...
  * the dependent product is written `forall x : A, B`,
  * a function is written `fun x : A => B`,
  * application is juxtaposition `e1 e2`.

If `x` does not appear freely in `B`, then we write `A -> B` instead of `forall x : A, B`.

In this tutorial we are not going to learn how to write a lexer and a parser, but see a comment about it below.

### Substitution

One way or another we have to deal with substitution. We could try to avoid it by compiling into OCaml functions, or we could use de Bruijn indices. The expert opinion is that [de Bruijn indices](http://en.wikipedia.org/wiki/De_Bruijn_index) are the way to go, but I want to keep things as simple as possible for now, so let us just implement [substitution](http://en.wikipedia.org/wiki/Lambda_calculus#Substitution).

Substitution must avoid variable capture. This means that we have to be able to generate new variable names. We can do it by simply generating an infinite sequence of them $x\_1, x\_2, x\_3, \ldots$ But what it the user already used $x\_3$, then we should not reuse it? To solve the problem we define a datatype of variable names like this:

<pre class="brush: plain; title: ; notranslate" title="">type variable =
 | String of string
 | Gensym of string * int
 | Dummy
</pre>

When the user types `x3` we represent this as `String "x3"`, whereas we generate variables of the form `Gensym("x",3)`. We make sure that the integer is unique, so the variable is fresh. The string is a hint to the pretty-printer, which should try to print the generated variable as the string, if possible. For example, suppose we have a $\lambda$-abstraction

<pre class="brush: plain; title: ; notranslate" title="">Lambda (String "x", ..., ...)
</pre>

and because of substitutions we refreshed the variable to something like

<pre class="brush: plain; title: ; notranslate" title="">Lambda (Gensym("x", 4124), ..., ...)
</pre>

It would be silly to print this as `fun x4124 : ... => ...` if we could first rename the bound variable back to `x`, or to `x1` if `x` is taken already. This is exactly what the pretty printer will do.

The `Dummy` variable is one that is never used. It only appears for the purposes of pretty printing.

Here is the substitution code:

<pre class="brush: plain; title: ; notranslate" title="">(** [refresh x] generates a fresh variable name whose preferred form is [x]. *)
let refresh =
  let k = ref 0 in
    function
      | String x | Gensym (x, _) -> (incr k ; Gensym (x, !k))
      | Dummy -> (incr k ; Gensym ("_", !k))

(** [subst [(x1,e1); ...; (xn;en)] e] performs the given substitution of
    expressions [e1], ..., [en] for variables [x1], ..., [xn] in expression [e]. *)
let rec subst s = function
  | Var x -> (try List.assoc x s with Not_found -> Var x)
  | Universe k -> Universe k
  | Pi a -> Pi (subst_abstraction s a)
  | Lambda a -> Lambda (subst_abstraction s a)
  | App (e1, e2) -> App (subst s e1, subst s e2)

and subst_abstraction s (x, t, e) =
  let x' = refresh x in
    (x', subst s t, subst ((x, Var x') :: s) e)
</pre>

### Type inference

Our calculus is such that an expression has at most one type, and when it does the type can be inferred from the expression. Therefore, we are going to implement type inference. During inference we need to carry around a context which maps variables to their types. And since we will allow global definitions on the toplevel, the context should also store (optional) definitions. So we define contexts to be [association lists](http://en.wikipedia.org/wiki/Association_list).

<pre class="brush: plain; title: ; notranslate" title="">type context = (Syntax.variable * (Syntax.expr * Syntax.expr option)) list
</pre>

We need functions that lookup up types and values of variables, and one for extending a context with a new variable:

<pre class="brush: plain; title: ; notranslate" title="">(** [lookup_ty x ctx] returns the type of [x] in context [ctx]. *)
let lookup_ty x ctx = fst (List.assoc x ctx)

(** [lookup_ty x ctx] returns the value of [x] in context [ctx], or [None]
    if [x] has no assigned value. *)
let lookup_value x ctx = snd (List.assoc x ctx)

(** [extend x t ctx] returns [ctx] extended with variable [x] of type [t],
    whereas [extend x t ~value:e ctx] returns [ctx] extended with variable [x]
    of type [t] and assigned value [e]. *)
let extend x t ?value ctx = (x, (t, value)) :: ctx
</pre>

Notice that extending with a variable which already appears in the context shadows the old variable, as it should.

We said we would read off the typing rules from the source code:

<pre class="brush: plain; title: ; notranslate" title="">(** [infer_type ctx e] infers the type of expression [e] in context [ctx].  *)
let rec infer_type ctx = function
  | Var x ->
    (try lookup_ty x ctx
     with Not_found -> Error.typing "unkown identifier %t" (Print.variable x))
  | Universe k -> Universe (k + 1)
  | Pi (x, t1, t2) ->
    let k1 = infer_universe ctx t1 in
    let k2 = infer_universe (extend x t1 ctx) t2 in
      Universe (max k1 k2)
  | Lambda (x, t, e) ->
    let _ = infer_universe ctx t in
    let te = infer_type (extend x t ctx) e in
      Pi (x, t, te)
  | App (e1, e2) ->
    let (x, s, t) = infer_pi ctx e1 in
    let te = infer_type ctx e2 in
      check_equal ctx s te ;
      subst [(x, e2)] t
</pre>

Ok, here we go:

  1. The type of a variable is looked up in the context.
  2. The type of $\mathtt{Type}\_k$ is $\mathtt{Type}\_{k+1}$.
  3. The type of $\prod\_{x : T\_1} T\_2$ is $\mathtt{Type}\_{\max(k, m)}$ where $T\_1$ has type $\mathtt{Type}\_k$ and $T\_2$ has type $\mathtt{Type}\_m$ in the context extended with $x : T_1$.
  4. The type of $\lambda x : T \; . \; e$ is $\prod_{x : T} T'$ where $T'$ is the type of $e$ in the context extended with $x : T$.
  5. The type of $e\_1 \; e\_2$ is $T[x/e\_2]$ where $e\_1$ has type $\prod\_{x : S} T$ and $e\_2$ has type $S$.

The typing rules refer to auxiliary functions `infer_universe`, `infer_pi`, and `check_equal`, which we have not defined yet. The function `infer_universe` infers the type of an expression, makes sure that the type is of the form $\mathtt{Type}_k$, and returns $k$. A common mistake is to think that you can implement it like this:

<pre class="brush: plain; title: ; notranslate" title="">(** Why is this infer_universe wrong? *)
and bad_infer_universe ctx t =
    match infer_type ctx t with
      | Universe k -> u
      | App _ | Var _ | Pi _ | Lambda _ -> Error.typing "type expected"
</pre>

This will not do. For example, what if `infer_type ctx t` returns the type $(\lambda x : \mathtt{Type}\_{4} \; . \; x) \mathtt{Type}\_3$? Then `infer_universe` will complain, because it does not see that the type it got is equal to $\mathtt{Type}_3$, even though it is not syntactically the same expression. We need to insert a normalization procedure which converts the type to a form from which we can read off its shape:

<pre class="brush: plain; title: ; notranslate" title="">(** [infer_universe ctx t] infers the universe level of type [t] in context [ctx]. *)
and infer_universe ctx t =
  let u = infer_type ctx t in
    match normalize ctx u with
      | Universe k -> k
      | App _ | Var _ | Pi _ | Lambda _ -> Error.typing "type expected"
</pre>

We shall implement normalization in a moment, but first we write down the other two auxiliary functions:

<pre class="brush: plain; title: ; notranslate" title="">(** [infer_pi ctx e] infers the type of [e] in context [ctx], verifies that it is
    of the form [Pi (x, t1, t2)] and returns the triple [(x, t1, t2)]. *)
and infer_pi ctx e =
  let t = infer_type ctx e in
    match normalize ctx t with
      | Pi a -> a
      | Var _ | App _ | Universe _ | Lambda _ -> Error.typing "function expected"

(** [check_equal ctx e1 e2] checks that expressions [e1] and [e2] are equal. *)
and check_equal ctx e1 e2 =
  if not (equal ctx e1 e2)
  then Error.typing "expressions %t and %t are not equal" (Print.expr e1) (Print.expr e2)
</pre>

### Normalization and equality

We need a function `normalize` which takes an expression and “computes” it, so that we can tell when something is a universe, and when something is a function. There are several strategies on how we might do this, and any will do as long as we have the following property: if $e\_1$ and $e\_2$ are equal (type theorists say that they are _judgmentally equal_, or sometimes that they are _definitionally equal_) then after normalization they should become syntactically equal, up to renaming of bound variables.

Our judgmental equality essentially has just two simple rules, [$\beta$-reduction](http://en.wikipedia.org/wiki/Beta_reduction#Reduction) and unfolding of definitions. So this is what the normalization procedure does:

<pre class="brush: plain; title: ; notranslate" title="">(** [normalize ctx e] normalizes the given expression [e] in context [ctx]. It removes
    all redexes and it unfolds all definitions. It performs normalization under binders.  *)
let rec normalize ctx = function
  | Var x ->
    (match
        (try lookup_value x ctx
         with Not_found -> Error.runtime "unkown identifier %t" (Print.variable x))
     with
       | None -> Var x
       | Some e -> normalize ctx e)
  | App (e1, e2) ->
    let e2 = normalize ctx e2 in
      (match normalize ctx e1 with
        | Lambda (x, _, e1') -> normalize ctx (subst [(x,e2)] e1')
        | e1 -> App (e1, e2))
  | Universe k -> Universe k
  | Pi a -> Pi (normalize_abstraction ctx a)
  | Lambda a -> Lambda (normalize_abstraction ctx a)

and normalize_abstraction ctx (x, t, e) =
  let t = normalize ctx t in
    (x, t, normalize (extend x t ctx) e)
</pre>

How about testing for equality of expressions, which was needed in the rule for application? We normalize, then compare for syntactic equality. We make sure that in comparison of abstractions both bound variables are the same:

<pre class="brush: plain; title: ; notranslate" title="">(** [equal ctx e1 e2] determines whether normalized [e1] and [e2] are equal up to renaming
    of bound variables. *)
let equal ctx e1 e2 =
  let rec equal e1 e2 =
    match e1, e2 with
      | Var x1, Var x2 -> x1 = x2
      | App (e11, e12), App (e21, e22) -> equal e11 e21 && equal e12 e22
      | Universe k1, Universe k2 -> k1 = k2
      | Pi a1, Pi a2 -> equal_abstraction a1 a2
      | Lambda a1, Lambda a2 -> equal_abstraction a1 a2
      | (Var _ | App _ | Universe _ | Pi _ | Lambda _), _ -> false
  and equal_abstraction (x, t1, e1) (y, t2, e2) =
    equal t1 t2 && (equal e1 (subst [(y, Var x)] e2))
  in
    equal (normalize ctx e1) (normalize ctx e2)
</pre>

And that is it! We have the core of the system written down. The rest is just [chrome](http://www.jargon.net/jargonfile/c/chrome.html): lexer, parser, toplevel, error reporting, pretty printer. Those are the things nobody ever explains because they are boring as soon as you have managed to implement them once. Nevertheless, let us have a brief look. The code is accessible at the Github project [`andrejbauer/tt`](https://github.com/andrejbauer/tt/tree/blog-part-I) (the branch `blog-part-I`).

### The infrastructure

#### Parser: [`parser.mly`](https://github.com/andrejbauer/tt/blob/blog-part-I/parser.mly) and [`lexer.mll`](https://github.com/andrejbauer/tt/blob/blog-part-I/lexer.mll)

You never ever want to write a parser with your bare hands. Insetad, you should use a [parser generator](http://en.wikipedia.org/wiki/Compiler-compiler). There are many, I used [menhir](http://gallium.inria.fr/~fpottier/menhir/). Parser generators can be a bit scary, but a good way to get started is to take someone else's parser and fiddle with it.

#### Pretty printer: [`print.ml`](https://github.com/andrejbauer/tt/blob/blog-part-I/print.ml) and [`beautify.ml`](https://github.com/andrejbauer/tt/blob/blog-part-I/beautify.ml)

Pretty printing is the opposite of parsing. In a usual programming language we do not have to print expressions with bound variables (because they get converted to non-printable closures), but here we do. It is worthwhile renaming the bound variables before printing them out, which is what `Beautify.beautify` does.

#### Error reporting: [`error.ml`](https://github.com/andrejbauer/tt/blob/blog-part-I/error.ml)

Not surprisingly, errors are reported with exceptions. The only thing to note here is that it should be possible to do pretty printing in error messages, otherwise you will be tempted to produce uninformative error messages. Our implementation of course does that.

#### Toplevel: [`tt.ml`](https://github.com/andrejbauer/tt/blob/blog-part-I/tt.ml)

The toplevel does nothing suprising. After parsing the command-line arguments and loading files, it enters an interactive toplevel loop. One neat trick that the toplevel does is that it looks for [rlwrap](http://utopia.knoware.nl/~hlub/rlwrap/#rlwrap) or [ledit](http://pauillac.inria.fr/~ddr/ledit/) and wraps itself with it. This gives us line-editing capabilities for free.

The toplevel commands are:

  * `Help.` print a description of toplevel commands.
  * `Context.` print current context.
  * `Parameter <i>x</i> : <i>t</i>.` assume that variable `<i>x</i>` has type `<i>t</i>`.
  * `Definition <i>x</i> := <i>e</i>.` define `<i>x</i>` to be `<i>e</i>`.
  * `Check <code><i>e</i>`.</code> infer the type of `<i>e</i>`.
  * `Eval <code><i>e</i>`.</code> normalize `<i>e</i>`.

Here is a sample session:

<pre class="brush: plain; title: ; notranslate" title="">tt blog-part-I
[Type Ctrl-D to exit or "Help." for help.]
# Parameter N : Type 0.
N is assumed
# Parameter z : N. Parameter s : N -> N.
z is assumed
s is assumed
# Definition three := fun f : N -> N => fun x : N => f (f (f x)).
three is defined
# Context.
three = fun f : N -> N => fun x : N => f (f (f x))
    : (N -> N) -> N -> N
s : N -> N
z : N
N : Type 0
# Check (three (three s)).
three (three s)
    : N -> N
# Eval (three (three s)) z.
    = s (s (s (s (s (s (s (s (s z))))))))
    : N
</pre>

### Where to go from here?

The whole program is 618 lines of code, and only 312 if we discount empty lines and comments. The core is just 92 lines, the rest is infrastructure. Not too bad. There are many ways in which we can improve `tt`, such as:

  1. Improve efficiency by implementing de Bruijn indice or some other mechanism that avoids substitutions.
  2. Improve the normalization procedure so that it unfolds definitins on demand, rather than eagerly.
  3. Improve the parser so that it accepts more flexible syntax.
  4. Improve type inference so that not all bound variables have to be explicitly typed.
  5. Add basic datatypes `unit`, `bool` and `nat`.
  6. Add simple products, coproducts and dependent sums.
  7. Implement a cummulative hierachy so that $\mathtt{Type}\_k$ is a subtype of $\mathtt{Type}\_{k+1}$.
  8. Add inductive datatypes.
  9. Add a stronger judgmental equality, for example $\eta$-reduction.
 10. Implement tactics and an interactive proof mode.
 11. Rule the world.

I may do some of these in subsequent blog posts, if there is interest. Or if you do it, make a pull request on git and write a guest blog post!
