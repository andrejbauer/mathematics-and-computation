---
id: 67
title: The Role of the Interval Domain in Modern Exact Real Arithmetic
date: 2007-09-18T07:39:45+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/2007/09/18/the-role-of-the-interval-domain-in-modern-exact-real-airthmetic/
permalink: /2007/09/18/the-role-of-the-interval-domain-in-modern-exact-real-airthmetic/
categories:
  - Computation
  - Constructive math
  - RZ
  - Talks
---
With [Iztok Kavkler](http://www.fmf.uni-lj.si/~kavkler/).

**Abstract:** The interval domain was proposed by Dana Scott as a domain-theoretic model for real numbers. It is a successful theoretical idea which also inspired a number of computational models for real numbers. However, current state-of-the-art implementations of real numbers, e.g., Mueller&#8217;s iRRAM and Lambov&#8217;s RealLib, do not seem to be based on the interval domain. In fact, their authors have observed that domain-theoretic concepts such as monotonicity of functions hinder efficiency of computation.

I will review the data structures and algorithms that are used in modern implementations of exact real arithmetic. They provide important insights, but some questions remain about what theoretical models support them, and how we can show them to be correct. It turns out that the correctness is not always clear, and that the good old interval domain still has a few tricks to offer.

**Download slides:** [domains8-slides.pdf](/wp-content/uploads/2007/09/domains8-slides.pdf)