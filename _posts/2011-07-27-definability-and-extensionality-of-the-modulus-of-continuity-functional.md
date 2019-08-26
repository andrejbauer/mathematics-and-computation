---
id: 983
title: Definability and extensionality of the modulus of continuity functional
date: 2011-07-27T14:54:39+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=983
permalink: /2011/07/27/definability-and-extensionality-of-the-modulus-of-continuity-functional/
categories:
  - Computation
  - Tutorial
---
In an [earlier post](/2006/03/27/sometimes-all-functions-are-continuous/) I talked about the modulus of continuity functional, where I stated that it cannot be defined without using some form of computational effects. It is a bit hard to find the proof of this fact so I am posting it on my blog in two parts, for Google and everyone else to find more easily. In the first part I show that there is no extensional modulus of continuity. In the second part I will show that every functional that is defined in [PCF](http://en.wikipedia.org/wiki/Programming_language_for_Computable_Functions) (simply-typed $\lambda$-calculus with natural numbers and recursion) is extensional. <!--more-->

The original reference for the first part is Troelstra and van Dalen, _Constructivism in mathematics, volume 2_, Sections 9.6.10 and 9.6.11, page 500. I transformed the proof to make the main idea a bit more transparent.

Define the _finite type hierarchy_ $N\_0, N\_1, N\_2, \ldots$ over the natural numbers $\mathtt{nat}$ by $$N\_0 = \mathtt{nat}$$ and $$N\_{k+1} = N\_k \to \mathtt{nat}.$$ The elements of $N_k$ are known as the _type $k$ functionals_. Let us keep the exact meaning of $\mathtt{nat}$ and $\to$ a bit unspecified. We might interpret $\mathtt{nat}$ as the set of natural numbers, or as a domain, or as a datatype in a programming language. We require that $\mathbb{N} \subseteq N_0$, i.e., each number has a representation, but there might be extra elements in $\mathtt{nat}$, such as the undefined value $\perp$. The arrow $\to$ may represent the function type in a programming language, or an exponential in a cartesian-closed category. We will make things precise when we need to.

For each $k$ we define the _(hereditarily) total functionals_ $T\_k$ by $T\_0 = \mathbb{N}$ and  
$$T\_{k+1} = \lbrace f \in N\_{k+1} \mid \forall x \in T\_k . f x \in T\_0 \rbrace.$$  
We call $T\_0, T\_1, T_2, \ldots$ the _total hierachy_ derived from $N\_0, N\_1, N\_2, \ldots$. When $N\_k = T\_k$ for all $k$, we say that the hierarchy $N\_0, N\_1, N\_2, \ldots$ is _total_.

We also need the notion of _extensionality_. For each $k$ define the relation $\approx\_k$ on $T\_k$ by  
$$n \approx_0 m \iff n = m$$  
and  
$$f \approx\_{k+1} g \iff \forall x, y \in T\_k . x \approx_k y \Rightarrow f(x) = g(y).$$  
It can be shown easily that $\approx\_k$ is symmetric and transitive, but it need not be reflexive. We say that $f \in N\_k$ is _extensional_ when $f \approx_k f$.

After this barrage of definitions some examples will hopefully make things a bit clearer. It is easy to come up with non-total functions, just write down something that cycles. A total function which is not extensional would be the following type 3 functional `u`, implemented in ocaml:

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">let u f =
  let k = ref 0 in
  let a n = (k := 1 ; 0) in
    ignore (f a) ;
    !k
</pre>

The functional `u` returns 1 if its argument `f` evaluates its argument, and 0 otherwise. It is not extensional:

<pre class="brush: plain; gutter: false; title: ; notranslate" title=""># u (fun a -&gt; 0) ;;
- : int = 0
# u (fun a -&gt; 0 * a 0) ;;
- : int = 1
</pre>

As you can see, `u` uses local references. Exercise: write a total non-extensional functional using some other computational effect, such as exceptions or continuations.

To avoid writing down lots of ugly types, we preassign types to the following variables:

  * $i, j, k, m, n$ stand for the elements of $N_0 = \mathtt{nat}$,
  * $\alpha, \beta, \gamma$ stand for functions, which are the elements of $N_1 = \mathtt{nat} \to \mathtt{nat}$
  * $F, G, H$ stand for type 2 functionals, which are the elements of $N_2 = (\mathtt{nat} \to \mathtt{nat}) \to \mathtt{nat}$,
  * $\Phi, \Psi, \Xi$ stand for type 3 functionals, which are the elements of $N_3 = ((\mathtt{nat} \to \mathtt{nat}) \to \mathtt{nat}) \to \mathtt{nat}$.

We need one further piece of notation. Given a total function $\alpha$, let $\overline{\alpha}(k) = [\alpha(0), \alpha(1), \ldots, \alpha(k-1)]$ be the finite list of the first $k$ values of $\alpha$.

A total type 2 functional $F$ is _continuous at a total $\alpha$_ if the value $F(\alpha)$ depends only on a finite prefix $\overline{\alpha}(k)$: $$\forall \beta \in T_1 . \overline{\beta}(k) = \overline{\alpha}(k) \Rightarrow F(\alpha) = F(\beta).$$  
You should convince yourself that this definition of continuity coincides with the usual one for metric spaces if we equip $\mathbf{N}$ with the usual metric $d(i,j) = |i &#8211; j|$ and $T_1$  with the _comparison metric_ $$d(\alpha, \beta) = 2^{-\min \lbrace k \mid \alpha(k) \neq \beta(k) \rbrace}.$$ We would expect every computable total functional to be continuous because, intuitively speaking, in order for an algorithm to compute $F(\alpha)$ in finitely many steps it can only inspect finitely many values of $\alpha$. Of course, this assumes that an algorithm cannot do anything other than test $\alpha$ at various values. There are theorems in computability theory which say that, provided $F$ is extensional (see below), an algorithm cannot really do much else, even if it has the source code of $\alpha$ at its disposal. (Exercise: which theorems?)

To keep things simple we shall concentrate on continuity at the zero sequence $o = \lambda n . 0$. Thus a functional $F$ is continuous at $o$ if there exists $k$ such that $\forall \beta \in T_1. \overline{\beta}(k) = \overline{o}(k) \Rightarrow F(\beta) = F(o)$. We say that $k$ is a _modulus of continuity_ for $F$ at $o$.

It is natural to ask whether we can compute a modulus of continuity $k$ from the total functional $F$, i.e., whether there is a _modulus of continuity functional _$\Phi$ of type 3 such that $$\forall F \in T\_2. \forall \beta \in T\_1. \overline{\beta}(\Phi(F)) = \overline{o}(\Phi(F)) \Rightarrow F(\beta) = F(o).$$ The existence of $\Phi$ implies that all type 2 functionals are continuous. So clearly we cannot expect to have one in a setting where discontinuous functional can be defined, such as the category of sets.

But how about defining $\Phi$ in a programming language? Well, you can do it in ocaml by using local references:

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">let phi f =
  let k = ref (-1) in
  let o i = (k := max !k i ; 0) in
    ignore (f o) ;
    !k + 1
</pre>

We expect `phi` to compute a modulus of continuity if `f` is extensional, but I would really like to see a carefully written proof of this fact.

The modulus of continuity `phi` defined above is not extensional, since it returns different values for extensionally equal functionals:

<pre class="brush: plain; gutter: false; title: ; notranslate" title=""># phi (fun alpha -&gt; 0) ;;
- : int = 0
# phi (fun alpha -&gt; 0 * alpha 41) ;;
- : int = 42
</pre>

Can we have an extensional modulus of continuity? Suppose $\Psi$ were one. Let $n = \Psi (\lambda \alpha . 0)$ and consider the type 2 functional $H$ defined by  
$$H(\beta) = \Psi (\lambda \alpha . \beta(\alpha(n))).$$  
Because $\lambda \alpha . 0$ is extensionally equal to $\lambda \alpha . o(\alpha(n))$ we get by extensionality of $\Psi$ that  
$$H(o) = \Psi(\lambda \alpha . o (\alpha(n))) = \Psi (\lambda \alpha . 0) = n.$$  
On the other hand, if $\beta \neq o$ then the value $\beta(\alpha(n))$ cannot be determined by looking at $\alpha(0), \ldots, \alpha(n-1)$, therefore $H(\beta) = \Psi (\beta (\alpha (n))) > n$. This means that $H$ is not continuous at $o$, which contradicts existence of $\Psi$. We have shown:

<p style="padding-left: 30px;">
  <strong>Theorem:</strong> <em>There is no extensional modulus of continuity functional.</em>
</p>

The consequence of this is that we cannot define the modulus of continuity functional in a programming language in which all total functionals are extensional. Next time we will see that PCF is such a language.