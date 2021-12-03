---
title: "Python's lambda is broken!"
author: Andrej Bauer
layout: post
categories:
  - General
---

I quite like Python for teaching. And people praise it for the `lambda` construct which is a bit like $\lambda$-abstraction in functional languages. However, it is **broken**!

<!--more-->To see how 

`lambda` is broken, try generating a list of functions $[f\_0, ..., f\_9]$ where $f_i(n) = i + n$. First attempt:

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">>>> fs = [(lambda n: i + n) for i in range(10)]
>>> fs[3](4)
13
</pre>

Wait a minute, `fs[3](4)` ought to be `3 + 4 = 7`! It looks like all 10 functions share the same “last” value of `i`, which is `9`. Indeed:

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">>>> [f(4) for f in fs]
[13, 13, 13, 13, 13, 13, 13, 13, 13, 13]
</pre>

This is certainly unexpected. Let us try to get around the problem by not using `lambda`:

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">>>> fs = []
>>> for i in range(10):
...    def f(n): return i+n
...    fs.append(f)
...
>>> [f(4) for f in fs]
[13, 13, 13, 13, 13, 13, 13, 13, 13, 13]
</pre>

Still not working, so the reason is deeper, probably in the way environments are handled. Maybe like this:

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">>>> fs = []
>>> for i in range(10):
...    def f(n, i=i): return i+n
...    fs.append(f)
...
>>> [f(4) for f in fs]
[4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
</pre>

Victory! But try explaining to students what is going on.

Just to be sure, Haskell does the right thing, of course!

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">Prelude> let fs = [(\n -> i + n) | i <- [0..9]]
Prelude> [f(4) | f <- fs]
[4,5,6,7,8,9,10,11,12,13]
</pre>

What were the implementors of Python thinking?!
