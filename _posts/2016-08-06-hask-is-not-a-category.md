---
id: 1908
title: Hask is not a category
date: 2016-08-06T22:36:40+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=1908
permalink: /2016/08/06/hask-is-not-a-category/
categories:
  - Computation
  - Programming
---
This post is going to draw an angry Haskell mob, but I just have to say it out loud: I have never seen a definition of the so-called [category Hask](https://wiki.haskell.org/Hask) and I do not actually believe there is one until someone does some serious work.

<!--more-->

Let us look at the matter a bit closer. The [Haskell wiki page on Hask](https://wiki.haskell.org/Hask) says:

<p style="padding-left: 30px;">
  The objects of Hask are Haskell types, and the morphisms from objects <code>A</code> to <code>B</code> are Haskell functions of type <code>A -> B</code>. The identity morphism for object <code>A</code> is <code>id :: A -> A</code>, and the composition of morphisms <code>f</code> and <code>g</code> is <code>f . g = \x -> f (g x)</code>.
</p>

Presumably “function” here means “closed expression”. It is then immediately noticed that there is a problem because the supposed identity morphisms do not actually work correctly: `seq undefined () = undefined` and `seq (undefined . id) () = ()`, therefore we do not have `undefined . id = undefined`.

The proposed solution is to equate `f :: A -> B` and `g :: A -> B` when `f x = g x` for all `x :: A`. Again, we may presume that here `x` ranges over all closed expressions of type `A`. But this begs the question: _what does `f x = g x` mean?_ Obviously, it cannot mean “syntactically equal expressions”. If we had a notion of observational or contextual equivalence then we could use that, but there is no such thing until somebody provides an operational semantics of Haskell. Written down, in detail, in standard form.

The wiki page gives two references. One is about the denotational semantics of Haskell, which is just a certain category of continuous posets. That is all fine, but such a category is not the syntactic category we are looking for. The other paper is a fine piece of work that uses denotational semantics to prove cool things, but does not speak of any syntactic category for Haskell.

There are several ways in which we could resolve the problem:

  1. If we define a notion of observational or contextual equivalence for Haskell, then we will know what it means for two expressions to be indistinguishable. We can then use this notion to equate indistinguishable morphisms.
  2. We could try to define the equality relation more carefully. The wiki page does a first step by specifying that at a function type equality is the extensional equality. Similarly, we could define that two pairs are equal if their components are equal, etc. But there are a lot of type constructors (including recursive types) and you'd have to go through them, and define a notion of equality on all of them. And after that, you need to show that this notion of equality actually gives a category. All the while, there will be a nagging doubt as to what it all means, since there is no operational semantics of Haskell.
  3. We could import a category-theoretic structure from a denotational semantics. It seems that denotational semantics of Haskell actually exists and is some sort of a category of domains. However, this would just mean we're restricting attention to a subcategory of the semantic category on the definable objects and morphisms. There is little to no advantage of doing so, and it's better to just stick with the semantic category.

Until someone actually does some work, **there is no Hask**! I'd delighted to be wrong, but I have not seen a complete construction of such a category yet.

Perhaps you think it is OK to pretend that something is a category when it is not. In that case, you would also pretend that the Haskell monads are actual category-theoretic monads. I recall a story from one of my math professors: when she was still a doctoral student she participated as “math support” in the construction of a small experimental nuclear reactor in Slovenia. One of the physicsts asked her to estimate the value of the harmonic series $1 + 1/2 + 1/3 + \cdots$ to four decimals. When she tried to explain the series diverged, he said “that's ok, let's just pretend it converges”.

**Supplemental: ** Of the three solutions mentioned above I like the best the one where we give Haskell an operational semantics. It's more or less clear how we would do this, after all Haskell is more or less a glorified PCF. However, the thing that worries me is `seq`. Because of it `undefined` and `undefined . id` are _not_ observationally equivalent, which means that we cannot use observational equivalence for equality of morphisms. We could try the wiki definition: `f :: A -> B` and `g :: A -> B` represent the same morphisms if `f x` and `g x` are observationally equivalent for all closed expressions `x :: A`. But then we need to prove something after that to know that we really have a category. For instance, I do not find it obvious anymore that programs which involve seq behave nicely. And what happens with higher-order functions, where observational equivalence and extensional equality get mixed up, is everything still holding water? There are just too many questions to be answered before we have a category.

**Supplemental II:** Now that the mob is here, I can see certain patterns in the comments, so I will allow myself replying to them en masse by supplementing the post. I hope you all will notice this. Let me be clear that I am not arguing against the usefulness of category-theoretic thinking in programming. In fact, I support programming that is informed by abstraction, as it often leads to new insights and helps gets things done correctly. (And anyone who knows my work should find this completely obvious.)

Nor am I objecting to “fast & loose” mode of thinking while investigating a new idea in Haskell, that is obviously quite useful as well. I am objecting to:

  1. The fact the the Haskell wiki claims there is such a thing as “the category Hask” and it pretends that everything is ok.
  2. The fact that some people find it acceptable to defend broken mathematics on the grounds that it is useful. Non-broken mathematics is also useful, as well as correct. Good engineers do not rationalize broken math by saying “life is tough”.

Anyhow, we do not need the Hask category. There already are other categories into which we can map Haskell, and they explain things quite well. It is ok to say “you can think of Haskell as a sort of category, but beware, there are technical details which break this idea, so you need to be a bit careful”. It is not ok to write on the Haskell wiki “Hask is a category”. Which is why I put up this blog post, so when people Google for Hask they'll hopefully find the truth behind it.

**Supplemental III**: On Twitter people have suggested some references that provide an operational semantics of Haskell:

  * John Launchbury: [A natural semantics for lazy evaluation](http://www.cse.chalmers.se/edu/year/2015/course/DAT140/Launchbury.pdf)
  * Alan Jeffrey: [A fully abstract semantics for concurrent graph reduction](http://ect.bell-labs.com/who/ajeffrey/papers/cs1293.pdf)

Can we use these to define a suitable notion of equality of morphisms? (And let's forget about `seq` for the time being.)
