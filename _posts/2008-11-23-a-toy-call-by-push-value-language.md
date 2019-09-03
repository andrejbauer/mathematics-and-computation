---
id: 137
title: A toy call-by-push-value language
date: 2008-11-23T12:22:17+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=137
permalink: /2008/11/23/a-toy-call-by-push-value-language/
categories:
  - Programming languages
---
I have added two new languages to the [PL Zoo](http://andrej.com/plzoo/). The minor addition is **miniml+error**, which is just MiniML with an error exception (raised by division by 0) that cannot be caught. The purpose is to demonstrate handling of fatal errors during runtime. The more interesting new animal is **levy** (written by [Matija Pretnar](http://matija.pretnar.info/) and myself), an implementation of [Paul Levy&#8217;s](http://www.cs.bham.ac.uk/~pbl/) call-by-push-value language. If you only know about Haskell&#8217;s call-by-name and ML&#8217;s call-by-value, I invite you to learn about call-by-push-value. Start by reading [Paul&#8217;s FAQ](http://www.cs.bham.ac.uk/~pbl/cbpv.html).
