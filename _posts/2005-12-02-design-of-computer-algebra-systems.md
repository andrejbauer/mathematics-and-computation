---
id: 32
title: Design of Computer Algebra Systems
date: 2005-12-02T01:11:14+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=32
permalink: /2005/12/02/design-of-computer-algebra-systems/
categories:
  - General
---
Computer algebra systems (CAS), such as [Mathematica](http://www.wolfram.com), are complex systems that have been evolving for a couple of decades. They are advertised as advanced mathematical tools, and users expect them to be such. They are the next-generation calculators. But they also suffer from serious design flaws.

<!--more-->

Unfortunately, the current CAS implementations suffer from two serious problems. Firstly, in terms of programming language design they are horrible abominations. It is next to impossible to maintain a large piece of code in Mathematica. The bugs starts crawling in at around 3000 lines of code. Secondly, people _expect_ correct answers but they are given no guarantee. The advertisements and the documentation never warn you of typical traps that users fall in. I have seen this happen to my students many times.

Below is included a Mathematica notebook, as well as a PDF transcript of it, which shows you some pitfalls of Mathematica. Please, do not get me wrong, I _love_ Mathematica for all of the great things it can do. I teach my students how to use Mathematica, and I show them examples from their calculus classes that their teacher solved incorrectly, which Mathematica gets right. But I also _hate_ it for containing so many nasty surprises. As a mathematician, I care about mathematical correctness. It bugs me when a program is promoted under the name _Math_ematica, but its makers do not state clearly, under what conditions it gives correct answers.

I have no solutions to offer, yet. Designing a _safe_ Computer Algebra System which is also _useful_ is a big open problem.

**Download:** [Surprises.nb](/asset/data/Surprises.nb "Surprises in Mathematica") or [Surprises.pdf](/asset/data/Surprises.pdf "Surprises in Mathematica")

P.S. I am interested in other examples which show design flaws and inherent limiations of Mathematica, especially when they cause surprising or wrong answers. If you know any, please [send them to me](mailto:Andrej.Bauer@andrej.com).
