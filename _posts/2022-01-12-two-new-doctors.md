---
title: Two new doctors!
author: Andrej Bauer
layout: post
categories:
  - News
---

Within a month two of my students defended their theses: [Dr. Anja Petković Komel](https://anjapetkovic.com) just before Christmas, and [Dr. Philipp Haselwarter](https://haselwarter.org) just yesterday. I am very proud of them. Congratulations!

<!--more-->

Philipp's thesis [An Effective Metatheory for Type Theory](https://haselwarter.org/assets/pdfs/effective-metatheory-for-type-theory.pdf) has three parts:

1. A formulation and a study of the notion of **finitary type theories** and **standard type theories**. These are closely related to the [general type theories](https://arxiv.org/abs/2009.05539) that were developed with [Peter Lumsdaine](http://peterlefanulumsdaine.com), but are tailored for implementation.

2. A formulation and the study of **context-free finitary type theories**, which are type theories without explicit contexts. Instead, the variables are annotated with their types. Philipp shows that one can pass between the two versions of type theory.

3. A novel effectful meta-language **Andromeda meta-language** (AML) for proof assistants which uses algebraic effects and handlers to allow flexible interaction between a generic proof assistant and the user.


Anja's thesis [Meta-analysis of type theories with an application to the design of formal proofs](https://anjapetkovic.com/img/doctoralThesis.pdf) also has three parts:

1. A formulation and a study of **transformations of finitary type theories** with an associated category of finitary type theories.

2. A **user-extensible equality checking algorithm** for standard type theories which specializes to several existing equality checking algorithms for specific type theories.

3. A **general elaboration theorem** in which the transformation of type theories are used to prove that every finitary type theory (not necessarily fully annotated) can be elaborated to a standard type theory (fully annotated one).

In addition, Philipp has done a great amount of work on implementing context-free type theories and the effective meta-language in [Andromeda 2](http://www.andromeda-prover.org), and Anja implemented the generic equality checking algorithm. In the final push to get the theses out the implementation suffered a little bit and is lagging behind. I hope we can bring it up to speed and make it usable. Anja has ideas on how to implement transformations of type theories in a proof assistant.

Of course, I am very happy with the particular results, but I am even happier with the fact that Philipp and Anja made an important step in the development of type theory as a branch of mathematics and computer science: they did not study a *particular* type theory or a narrow family of them, as has hitherto been the norm, but *dependent type theories in general*. Their theses contain interesting non-trivial meta-theorems that apply to large classes of type theories, and can no doubt be generalized even further.
There is lots of low-hanging fruit out there.
