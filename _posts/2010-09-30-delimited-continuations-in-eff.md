---
id: 728
title: Delimited continuations in eff
date: 2010-09-30T15:42:45+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=728
permalink: /2010/09/30/delimited-continuations-in-eff/
bfa_ata_body_title:
  - Delimited continuations in eff
bfa_ata_display_body_title:
  - ""
bfa_ata_body_title_multi:
  - Delimited continuations in eff
bfa_ata_meta_title:
  - ""
bfa_ata_meta_keywords:
  - ""
bfa_ata_meta_description:
  - ""
categories:
  - Eff
---
**[UPDATE 2012-03-08: since this post was written eff has changed considerably. For updated information, please visit the [eff page](/eff/).]**

****Let&#8217;s keep the blog rolling! Here are delimited continuations in eff, and a bunch of questions I do not know the answers to.

<!--more-->

I am not going to explain what [continuations](http://en.wikipedia.org/wiki/Continuation) and [delimited continuations](http://en.wikipedia.org/wiki/Delimited_continuation) are, I will just show how to get them in eff. I should also warn you that delimited continuations confuse me deeply. The definition of `reset` and `shift` is simple:

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">effect reset:
  operation shift f: f (lambda x: yield x)
</pre>

Reset is done with &#8220;`with reset:`&#8220;. Shift takes a function as a parameter and passes to it the continuation (delimited by the correspoding `with`). Here is a basic example:

<pre class="brush: plain; gutter: false; highlight: [4]; title: ; notranslate" title="">&gt;&gt;&gt; with reset:
...     shift (lambda k: k(k(k(7)))) * 2 + 1
...
63
</pre>

Let&#8217;s see if we understand this. When shift hapens its continuation is &#8220;multiply by 2 and add 1&#8221;. So `k` will be the function $x \mapsto 2 x + 1$. Thus $k(k(k(7)))$ is $2 \cdot (2 \cdot (2 \cdot 7 +1) + 1) + 1 = 63$, if I got my arithmetic right.

They say that continuations are the GOTO statement of functional programming:

<pre class="brush: plain; gutter: false; highlight: [3]; title: ; notranslate" title="">&gt;&gt;&gt; (with reset: (shift (lambda k: 10)) * 3 + 1) + 2
...
12
</pre>

This time when shift happens the continuation is &#8220;multiply by 3 and add 1&#8221;, so $k$ is the map $x \mapsto 3 x + 1$. But shift ignores $k$ and just passes $10$ straight to reset (that&#8217;s the GOTO), so the answer is $10 + 2 = 12$.

Let us compute the type of shift. The continuation is a function of type $A \to B$. The argument of shift is a function which accepts the continuation so it has type $(A \to B) \to C$. But this only makese sense if the result of `shift` is the same as the result of the continuation, therefore $C = B$. The type of `shift` is  
$$B^{B^A} \times B^A \to B.$$  
As an algebraic operation `shift` takes a parameter of type $B^{B^A}$, has arity $A$, and the carrier is $B$. This is a bit odd since the type of the parameter depends on the carrier and the arity. As is well known, continuations are _not_ algebraic operations. But it seems like eff is telling us that _delimited_ continuations are algebraic, if we look at them the right way. Indeed, consider the signature $\Sigma$ whose only operation is $\mathtt{shift}$ of type $(B^{B^A}, A)$. A $\Sigma$-algebra is a set $C$ with an operation $\mathtt{shift}\_C : B^{B^A} \times C^A \to C$. Would we expect $\mathtt{shift}\_C$ to satisfy any equations? By staring at the above definition of `shift`, we see that we should require, for all $k : A \to C$, $f : B^A \to B$ and $j : C \to B$,  
$$j \circ \mathtt{shift}_C(f, k) = f( j \circ k).$$  
Strictly speaking, this is not an equation in the sense of universal algebra because we used composition as well as $\mathtt{shift}\_C$, whereas classical universal algebra only allows equations involving $\mathtt{shift}\_C$. Nevertheless, we are still awfully close to being algebraic. Perhaps we are staring at a monad for delimited continuations? I need to think about this, or be told that someone already has. Also, what are some examples of $\Sigma$-algebras $(C, \mathtt{shift}_C)$, other than delimited continuations?

Since in eff we can have multiple instances of an effect, we get delimited continuations with multiple prompts, i.e., multiple resets. For example, try wrapping your head around the following piece of code:

<pre class="brush: plain; gutter: false; highlight: [9,10,11,12,13,14,15,16,17,18]; title: ; notranslate" title="">&gt;&gt;&gt; with io:
...     with reset as promptA:
...         print_string "Batman"
...         with reset as promptB:
...             promptB.shift (lambda k: k (k (promptA.shift (lambda l: l (k (l (k ())))))))
...             print_string "Robin"
...          print_string "Cat woman"
...
Batman
Robin
Robin
Robin
Cat woman
Robin
Robin
Robin
Cat woman
()
</pre>

I have no idea what this sort of thing is good for, perhaps someone can suggest a useful program with multiple resets.