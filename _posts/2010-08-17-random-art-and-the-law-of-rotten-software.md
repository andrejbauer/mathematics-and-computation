---
id: 541
title: Random Art and the Law of Rotten Software
date: 2010-08-17T18:04:44+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=541
permalink: /2010/08/17/random-art-and-the-law-of-rotten-software/
bfa_ata_body_title:
  - Random Art and the Law of Rotten Software
bfa_ata_display_body_title:
  - ""
bfa_ata_body_title_multi:
  - Random Art and the Law of Rotten Software
bfa_ata_meta_title:
  - ""
bfa_ata_meta_keywords:
  - ""
bfa_ata_meta_description:
  - ""
categories:
  - Programming
  - Random art
---
Since the death of my old web server my [Random Art](http://www.random-art.org/) has not worked. Bringing it up to date and installing it on the new server was a nightmare in software management. But it was worth it. The new Random Art runs the random art program inside your browser!

<!--more-->

I implemented the old Random Art in 2005 withÂ [ocaml](http://www.ocaml.org/) and [cduce](http://www.cduce.org/). Cduce is a programming language for XML which statically checks correctness of produced XML. I thought that nothing could be better than a web site that has an a priori guarantee of 100% complicance with strict HMTL. Those were the days of idealism.

Well, in 2010 it turned out to be quite impossible to reinstall Random Art on the new server. First of all, the current version of cduce is incompatible with the one from 2005. In addition, the old version of random art relies on old ocaml libraries that are not available in current Linux distributions, so I cannot easily recompile it. If I really wanted to install the old version, I would have to install an antique Debian system from 2005, but then I would suffer from old security holes. There must be a software equivalent of theÂ [second law of thermodynamics](http://en.wikipedia.org/wiki/Second_law_of_thermodynamics), let&#8217;s call it the _Law of Rotting Software_:

> _&#8220;All software eventually fails, even if it you leave it alone.&#8221;_

So it was clear that I should junk cduce and use something sane, like [Django](http://www.djangoproject.com/). (I know there is [ocsigen](http://ocsigen.org/), but as we say in Slovene, even a donkey steps on thin ice only once). I separated the ocaml code that computes random pictures from cduce and reimplemented the web site in Django. The site was up and running in no time!Â Except that all pictures were uniformly gray. It took me a week to figure out that this was caused by a change between ocaml 3.10 and 3.11 in how they treat mutable record fields inside function closures. It is still not clear to me exactly what the change is because I am not able to produce a small example that shows the difference.

I wanted to make the new site more user friendly by allowing users to generate their own random pictures. They would have to compute images inside their web browsers because I cannot afford a cloud of servers. So I decided to try [Jake Donham](http://jaked.org/)&#8216;s amazingÂ [ocamljs](http://github.com/jaked/ocamljs) compiler that compiles ocaml to javascript. It worked, after a couple of days of making sure that the javascript code was equivalent to the ocaml code. I had to fix the pseudo-random number generator (which broke compatibility with the old random art), and remove a number of ambiguities about the evaluation order of arguments (ocaml evaluatesÂ Â `f x y` in an undefined order, but usually right to left, whereas Javascript evaluates the arguments in `f(x,y)` from left to right). I am amazed at having 1200 lines of ocaml code run inside a browser.

Anyhow, I hope you will enjoy [the new web site](http://www.random-art.org/). Now I just have to make it work under Internet Explorer, which does not support HTML5 canvas element that I use for drawing (I suppose I just have to get Google&#8217;s [excanvas](http://excanvas.sourceforge.net/) to work.) Also, I recommend Google Chrome over Firefox because its javascript engine is _way_ faster.