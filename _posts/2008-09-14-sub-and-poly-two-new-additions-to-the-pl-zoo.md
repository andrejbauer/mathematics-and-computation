---
id: 95
title: Sub and Poly, two new additions to the PL Zoo
date: 2008-09-14T15:29:30+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=95
permalink: /2008/09/14/sub-and-poly-two-new-additions-to-the-pl-zoo/
categories:
  - PL zoo
  - Software
---
I have added two new languages to the [Programming Languages Zoo](http://andrej.com/plzoo/) which demonstrate polymorphic type inference and type checking with subtypes.  
<!--more-->

The first one is **poly**, which is an extension of MiniHaskell with parametric polymorphism and type inference. In fact, evaluation is exactly the same as in MiniHaskell, the only difference is omission of type information in the source code and type inference rather than type checking. Have a look at the implementation of type inferrence if you would like to see a very simple algorithm for inferring polymorphic types.

The second language is **sub**, which is an extension of MiniML with records and subypes. Have a look at the implementation of type checking if you would like to see a very simple algorithm for type checking in the presence of subtyping.