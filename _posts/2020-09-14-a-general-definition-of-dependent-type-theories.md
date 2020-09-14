---
title: "A general definition of dependent type theories"
author: Andrej Bauer
layout: post
categories:
  - Publications
  - Type theory
---

The preprint version of the paper [A general definition of dependent type
theories](https://arxiv.org/abs/2009.05539) has finally appeared on the arXiv! Over three
years ago [Peter Lumsdaine](http://peterlefanulumsdaine.com) invited me to work on the
topic, which I gladly accepted, and dragged my student [Philipp
Haselwarter](http://haselwarter.org/~philipp/) into it. We set out to give *an* answer to
the queation:

> **What is type theory, precisely?**

At least for me the motivation to work on such a thankless topic came from Vladimir
Voevodsky, who would ask the question to type-theoretic audiences. Some took him to be a
troll and others a newcomer who just had to learn more type theory. I was among the
latter, but eventually the question got through to me – I could point to any number of
*specific* examples of type theories, but not a comprehensive and mathematically precise
definition of the *general* concept.

It is too easy to dismiss the question by claiming that type theory is an open-ended concept
which therefore cannot be completely captured by any mathematical definition. Of
course it is open-ended, but it does not follow at all that we should not even
attempt to define it. If geometers were equally fatalistic about the open-ended notion of
space we would never have had modern geometry, topology, sheaves – heck, half of 20th
century mathematics would not be there!

Of course, we are neither the first nor the last to give a definition of type theory, and
that is how things should be. We claim no priority or supremacy over other definitions and
views of type theory. Our approach could perhaps be described as "concrete" and
"proof-theoretic":

1. We wanted to *stay close to traditional syntax*.
2. We gave a *complete* and *precise* definition.
3. We aimed for a level of generality that allows useful meta-theory of a wide range of type theories.

One can argue each of the above points, and we have done so among ourselves many times.
Nevertheless, I feel that we have accomplished something worthwhile – but the ultimate
judges will be our readers, or lack of them. You are kindly invited to take a look at the
paper.

**Download PDF:** [`arxiv.org/pdf/2009.05539.pdf`](https://arxiv.org/pdf/2009.05539.pdf)

I should not forget to mention that Peter, with modest help from Philipp and me,
formalized almost the entire paper in Coq! See the repository
[`general-type-theories`](https://github.com/peterlefanulumsdaine/general-type-theories) at
GitHub.

