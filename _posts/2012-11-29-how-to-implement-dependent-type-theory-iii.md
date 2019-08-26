---
id: 1337
title: How to implement dependent type theory III
date: 2012-11-29T05:55:28+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=1337
permalink: /2012/11/29/how-to-implement-dependent-type-theory-iii/
categories:
  - Homotopy type theory
  - Programming
  - Software
  - Tutorial
---
I spent a week trying to implement higher-order pattern unification. I looked at couple of PhD dissertations, talked to lots of smart people, and failed because the substitutions were just getting in the way all the time. So today we are going to bite the bullet and implement [de Bruijn indices](http://en.wikipedia.org/wiki/De_Bruijn_index) and [explicit substitutions](http://en.wikipedia.org/wiki/Explicit_substitution).

The code is available on Github in the repository [andrejbauer/tt](https://github.com/andrejbauer/tt/tree/blog-part-III) (the `blog-part-III` branch).

<!--more-->

People say that de Bruijn indices and explicit substitutions are difficult to implement. I agree, I spent far too long debugging my code. But because every bug crashed and burnt my program immediately, I at least knew I was not done. In contrast, &#8220;manual&#8221; substitutions hide their bugs really well, and so are even more difficult to get right. I am convinced that my implementation from part II is still buggy.

### Blitz introduction to de Bruijn indices and explicit substitution

If you do not know about [de Bruijn indices](http://en.wikipedia.org/wiki/De_Bruijn_index) and [explicit substitutions](http://en.wikipedia.org/wiki/Explicit_substitution) you should first read the relevant Wikipedia pages, and perhaps the [original paper on explicit substitutions](http://www.hpl.hp.com/techreports/Compaq-DEC/SRC-RR-54.pdf), written by a truly impressive group of authors. Here is an inadequate short explanation for those who cannot be bothered to click on links.

We keep looking up variables in a context by their names, which seems a bit inefficient. We might have the bright idea of referring to _positions_ in the context directly. We can indeed do this, and because a context is like a stack there are two choices:

  * _de Bruijn levels_ are positions as counted from the bottom of the stack,
  * _de Bruijn indices_ are positions as counter from the top of the stack.

We will use the indices. Thus, when the context grows all the old indices have to be _shifted_ by one, which sounds more horrible than it is, as levels bring their own problems (which?). For instance, the $\lambda$-term $\lambda x \,.\, \lambda y \,.\, x$ is written with de Bruijn indices as $\lambda \, (\lambda \, 1)$, whereas $\lambda x \,.\, \lambda y \,.\, y$ is written as $\lambda \, (\lambda \, 0)$. (Just go read the Wikipedia article on [de Bruijn indices](http://en.wikipedia.org/wiki/De_Bruijn_index) if you have not seen this before.)

The shifting and pushing of new things onto the context is expressed with explicit substitutions:

<pre class="brush: plain; title: ; notranslate" title="">type substitution =
  | Shift of int
  | Dot of expr * substitution
</pre>

Read `Shift k` as &#8220;add $k$ to all indices&#8221; and `Dot(e,s)` as &#8220;push $e$ and use $s$&#8221;. In mathematical notation we write $\uparrow^n$ instead of `Shift n` and $e \cdot \sigma$ instead of `Dot(e,sigma)`. An explicit substitution $\sigma$ acts on an expression $e$ to give a new expression $[\sigma] e$. For example:

  * $\[\uparrow^k\] (\mathtt{Var}\, m) = \mathtt{Var} (k + m)$
  * $\[e \cdot \sigma)\] (\mathtt{Var}\, 0) = e$
  * $\[e \cdot \sigma)\] (\mathtt{Var}\, (k+1)) = \[\sigma\](\mathtt{Var}\, k).$

Below we will read off the other equations from the source code. Substitutions are performed on demand, which means that $[\sigma] e$ is an expression that needs to be accounted for in the syntax.

### Splitting the syntax

The user is going to type in syntax with names, which we have to convert to an internal syntax that uses the indices. We should also keep the original names around for pretty-printing purposes. Therefore we need a datatype [`Input.exp`](https://github.com/andrejbauer/tt/blob/blog-part-III/input.ml) for parsing,

<pre class="brush: plain; title: ; notranslate" title="">(** Abstract syntax of expressions as given by the user. *)
type expr = expr' * Common.position
and expr' =
  | Var of Common.variable
  | Universe of int
  | Pi of abstraction
  | Lambda of abstraction
  | App of expr * expr

(** An abstraction [(x,t,e)] indicates that [x] of type [t] is bound in [e]. *)
and abstraction = Common.variable * expr * expr
</pre>

and a datatype [`Syntax.expr`](https://github.com/andrejbauer/tt/blob/blog-part-III/syntax.ml) for the internal syntax:

<pre class="brush: plain; title: ; notranslate" title="">(** Abstract syntax of expressions, where de Bruijn indices are used to represent
    variables. *)
type expr = expr' * Common.position
and expr' =
  | Var of int                   (* de Briujn index *)
  | Subst of substitution * expr (* explicit substitution *)
  | Universe of universe
  | Pi of abstraction
  | Lambda of abstraction
  | App of expr * expr

(** An abstraction [(x,t,e)] indicates that [x] of type [t] is bound in [e]. We also keep around
    the original name [x] of the bound variable for pretty-printing purposes. *)
and abstraction = Common.variable * expr * expr

(** Explicit substitutions. *)
and substitution =
  | Shift of int
  | Dot of expr * substitution
</pre>

Conversion from one to the other is done by [`Desugar.desugar`](https://github.com/andrejbauer/tt/blob/blog-part-III/desugar.ml). Notice that we do not throw away variable names, but rather keep them around in the internal syntax so that we can print them out later. Strangely enough, [`beautify.ml`](https://github.com/andrejbauer/tt/blob/blog-part-III/beautify.ml) gets shorter with de Bruijn indices.

### Explicit substitutions

The [`Syntax`](https://github.com/andrejbauer/tt/blob/blog-part-III/syntax.ml) module contains a couple of functions for handling explicit substitutions. First we have `Syntax.composition` which tells us how substitutions are composed:

<pre class="brush: plain; title: ; notranslate" title="">let rec compose s t =
  match s, t with
    | s, Shift 0 -&gt; s
    | Dot (e, s), Shift m -&gt; compose s (Shift (m - 1))
    | Shift m, Shift n -&gt; Shift (m + n)
    | s, Dot (e, t) -&gt; Dot (mk_subst s e, compose s t)
</pre>

In mathematical notation:

  * $\sigma \circ \uparrow^0 = \sigma$
  * $(e \cdot \sigma) \circ \uparrow^{m} = s \circ \uparrow^{m-1}$
  * $\uparrow^{m} \circ \uparrow^{n} = \uparrow^{m + n}$
  * $\sigma \circ (e \cdot \tau) = [\sigma] e \cdot (\sigma \circ \tau)$

Of course, composition $\circ$ is the operation characterized by the equation $\[\sigma \circ \tau] e = [\sigma\]([\tau] e)$. Next we have `Syntax.subst` which explains how substitutions are performed:

<pre class="brush: plain; title: ; notranslate" title="">(** [subst s e] applies explicit substitution [s] in expression [e]. It does so
    lazily, i.e., it does just enough to expose the outermost constructor of [e]. *)
let subst =
  let rec subst s ((e', loc) as e) =
    match s, e' with
      | Shift m, Var k -&gt; Var (k + m), loc
      | Dot (e, s), Var 0 -&gt; subst idsubst e
      | Dot (e, s), Var k -&gt; subst s (Var (k - 1), loc)
      | s, Subst (t, e) -&gt; subst s (subst t e)
      | _, Universe _ -&gt; e
      | s, Pi a -&gt; Pi (subst_abstraction s a), loc
      | s, Lambda a -&gt; Lambda (subst_abstraction s a), loc
      | s, App (e1, e2) -&gt; App (mk_subst s e1, mk_subst s e2), loc
  and subst_abstraction s (x, e1, e2) =
    let e1 = mk_subst s e1 in
    let e2 = mk_subst (Dot (mk_var 0, compose (Shift 1) s)) e2 in
      (x, e1, e2)
  in
    subst
</pre>

The code is not very readable, but in mathematical notation the interesting bits say:

  * $\[\uparrow^m\](\mathtt{Var}\,k) = \mathtt{Var}\,(k + m)$
  * $\[e \cdot \sigma\] (\mathtt{Var}\,0) = e$
  * $\[e \cdot \sigma\] (\mathtt{Var}\,k) = \[\sigma\](\mathtt{Var}(k-1))$
  * $\[\sigma\](\lambda\, e) = \lambda \, ([\mathtt{Var}\,0 \cdot (\uparrow^1 \circ \sigma)] e)$
  * $\[\sigma\](e\_1\,e\_2) = ([\sigma]e\_1)([\sigma]e\_2)$

There is also `Syntax.occurs` which checks whether a given index appears freely in an expression. This is not entirely trivial because explicit substitutions and abstractions change the indices, so the function has to keep track of what is what.

You may wonder what happened to $\beta$-reduction. If you look at `Norm.norm` you will discover it burried in the code for normalization of applications:  
$$(\lambda \, e\_1)\, e\_2 = [e\_2 \cdot \uparrow^0] e\_1.$$

### Normalization

In the last part we demonstrated normalization by evaluation. We always normalized everything all the way, which is an overkill. For example, during equality checking the [weak head normal form](http://encyclopedia2.thefreedictionary.com/Weak+Head+Normal+Form) suffices to get the comparison started, and then we normalize on demand. So I replaced normalization by evaluation with direct normalization, as done in [`norm.ml`](https://github.com/andrejbauer/tt/blob/blog-part-III/norm.ml). We still need normal forms when the user asks for them. Luckily, a single function can perform both kinds of normalization.

### Optimization

The source contains no optimizations at all because its purpose is to be as clear as possible. The whole program is still pretty small, we are at 824 lines while the core is just 247 lines. The speed is comparable to the previous version, but with a bit of effort we should be able to speed it up considerably. Here are some opportunities:

  * we normalize a definition every time we look it up in the context,
  * explicit substitutions tend to cancel out, and it is a good idea to look for common special cases, like composition with the identity substitution,
  * there is a lot of shifting happening when we look things up in the context, perhaps some of those could be avoided

If anyone wants to work on these, I would be delighted to make a pull request.

I really have to do some serious math and stop playing around, so do not expect the next part anytime soon.