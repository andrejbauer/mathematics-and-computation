---
id: 283
title: 'Constructive gem: juggling exponentials'
date: 2009-09-09T19:58:05+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=283
permalink: /2009/09/09/constructive-gem-juggling-exponentials/
bfa_ata_body_title:
  - 'Constructive gem: juggling exponentials'
bfa_ata_display_body_title:
  - ""
bfa_ata_body_title_multi:
  - 'Constructive gem: juggling exponentials'
bfa_ata_meta_title:
  - ""
bfa_ata_meta_keywords:
  - ""
bfa_ata_meta_description:
  - ""
categories:
  - Gems and stones
---
Constructive gems are usually not about particular results, because all constructive results can be proved classically as well, but rather about the _method_ and the way of thinking. I demonstrate a constructive proof which can be reused in three different settings (set theory, topology, computability) because constructive mathematics has many different interpretations.

<!--more-->

Let me first introduce some notation:

  * $1 = \{0\}$ is the singleton set, or the _unit._
  * $2 = 1 + 1 = \{0,1\}$ is the _booleans._
  * In general, $[n]= \{0, 1, \ldots, n-1\}$ is the $n$-fold coproduct of singletons. For brevity we will write $n$ instead of $[n]$.
  * In general $A + B$ is the disjoint sum of $A$ and $B$.
  * The _product_ $A \times B$ is the cartesian product of $A$ and $B$.
  * The _exponential_ $B^A$, also written as $A \to B$, is the set of functions from $A$ to $B$.

I should warn you that $2$ is not in general isomorphic to the set of truth values $\Omega$, and consequently $2^A$ is _not_ generally isomorphic to $\Omega^A = P(A)$, the powerset of $A$. Rather, the elements of $2^A$ are the characteristic functions of _decidable_ subsets of $A$.

Now suppose someone asks you to show that $3^\mathbb{N}$ and $5^\mathbb{N}$ are isomorphic. If you are classically trained you might say: &#8220;They are isomorphic because they both have the cardinality of continuum.&#8221; That&#8217;s a quick and dirty proof. But then you are asked to show that $3^\mathbb{N}$ and $5^\mathbb{N}$ are isomorphic _as topological spaces_, and you have to think again. You could construct an actual homeomorphism, although any self-respecting topologist will notice that both spaces are &#8220;compact, countably based, 0-dimensional Hausdorff spaces without isolated points, therefore homeomorphic to the Cantor space by a well-known theorem&#8221;. That&#8217;s the kind of answer I would expect from my topology friends. And when you are done with that, you will be asked to show that $3^\mathbb{N}$ are $5^\mathbb{N}$ are _computably_ isomorphic, so you will have to think again. Can we not have a single proof which works in all three cases?

To find such a proof, you should forget heavy weapons from set theory and topology, and just look at the sets involved. How they are _constructed_ will tell you what tools to use in your proof. The spaces $3^\mathbb{N}$ and $5^\mathbb{N}$ are _exponentials_, so we should use $lambda$-calculus! Recall the exponential laws, where I write equality in place of isomorphism,

  * $(A \times B)^C = A^C \times B^C$ and
  * $(A^B)^C = A^{B \times C}$.

The isomorphism $i : (A \times B)^C \to A^C \times B^C$ and its inverse $j$ may be written down explicitly, for example in Haskell:

<pre class="brush: plain; title: ; notranslate" title="">i :: (c -&gt; (a,b)) -&gt; (c -&gt; a, c -&gt; b)
i f = (fst . f, snd . f)

j :: (c -&gt; a, c -&gt; b) -&gt; (c -&gt; (a, b))
j (g, h) c = (g c, h c)
</pre>

I will leave the pair of isomorphisms for the other exponential law as an exercise. There are other isomorphisms which are good to know about (where again we write equality instead of isomorphism):

  * $A^0 = 1$, $1^A = 1$, and $A^1 = A$,
  * $A^{B+C} = A^B \times A^C$,
  * $(A+B) \times C = A \times C + B \times C$,
  * $\mathbb{N} = 1 + \mathbb{N} = 2 \times \mathbb{N} = \mathbb{N} \times \mathbb{N} = \mathbb{N} + \mathbb{N}$.

You should write down Haskell functions which witness these. The laws are easy to remember and use because they look like the usual laws of arithmetic. In fact, there is a [deep and fascinating connection](http://www.cl.cam.ac.uk/~mpf23/papers/Types/shortremarks.pdf) between the laws of bicartesian closed categories and arithmetic.

Here is how we can compute with exponentials:

> $5^\mathbb{N} = 5^{1 + \mathbb{N}} = 5^1 \times 5^\mathbb{N} = 5 \times 5^\mathbb{N} = 4 \times 5^\mathbb{N} + 1 \times 5^\mathbb{N} = 4 \times 5^\mathbb{N} + 5^\mathbb{N}$,

therefore

> $5^\mathbb{N} = 4 \times 5^\mathbb{N} + 5^\mathbb{N} =4 \times 5^\mathbb{N} + 5^{1 + \mathbb{N}} = 4 \times 5^\mathbb{N} + 5 \times 5^\mathbb{N} = 9 \times 5^\mathbb{N}$

and now

> $5^\mathbb{N} = 5^{\mathbb{N} \times \mathbb{N}} = (5^\mathbb{N})^\mathbb{N} = (9 \times 5^\mathbb{N})^\mathbb{N} = 9^\mathbb{N} \times 5^{\mathbb{N} \times \mathbb{N}} = 9^\mathbb{N} \times 5^\mathbb{N} = 45^\mathbb{N}$.

This is fun, but how is it helping us to show that $3^\mathbb{N} = 5^\mathbb{N}$? Well, if we could also show that $3^\mathbb{N} = 45^\mathbb{N}$ we would be done. Indeed,

> $3^\mathbb{N} = 3 \times 3^\mathbb{N} = 2 \times 3^\mathbb{N} + 3^\mathbb{N} = 2 \times 3^\mathbb{N} + 3 \times 3^\mathbb{N} = 5 \times 3^\mathbb{N} = 5 \times (3 \times 3^\mathbb{N}) = 15 \times 3^\mathbb{N}$,

and now we finish off the proof:

> $3^\mathbb{N} = (3^\mathbb{N})^\mathbb{N} = (15 \times 3^\mathbb{N})^\mathbb{N} = 15^\mathbb{N} \times 3^{\mathbb{N} \times \mathbb{N}} = 15^\mathbb{N} \times 3^\mathbb{N} = 45^\mathbb{N}$.

Because we only used the basic exponential laws which are witnessed by constructive functions (Haskell programs, if you wish) they hold _constructively._ This immediately tells us that:

  * the sets $3^\mathbb{N}$ and $5^\mathbb{N}$ are in bijective correspondence because constructive mathematics is consistent with classical set theory,
  * the topological spaces $3^\mathbb{N}$ and $5^\mathbb{N}$ are homeomorphic because constructive mathematics is consistent with the assumption that all maps (hence also the isomorphisms involved) are continuous,
  * the isomorphism between $3^\mathbb{N}$ and $5^\mathbb{N}$ are computable simply because they can be written down in Haskell (or any other decent programming language).

I must admit to a little bit of cheating. I chose $3^\mathbb{N}$ and $5^\mathbb{N}$ because they can both be manipulated to $45^\mathbb{N}$. If you try to show $2^\mathbb{N} = 3^\mathbb{N}$ you will be probably get stuck; if not, show me how!

Let us think  about the general question of how to show that $m^\mathbb{N} = n^\mathbb{N}$ for $n, m \geq 2.$ We certainly expect this to hold, but what is the &#8220;best&#8221; proof? One idea is to first show that $m^\mathbb{N} = m^\mathbb{N} + m^\mathbb{N}$, from which it quickly follows that $m^\mathbb{N} = n \times m^\mathbb{N}$ and $m^\mathbb{N} = (n \times m)^\mathbb{N}$. But what is the slickest way to get $m^\mathbb{N} = m^\mathbb{N} + m^\mathbb{N}$?

For which $m$ and $n$ does my trick work? Observe that

> $m^\mathbb{N} = (m-1) \times m^\mathbb{N} + m^\mathbb{N} = (m-1) \times m^\mathbb{N} + m \times m^\mathbb{N} = (2 m &#8211; 1) \times m^\mathbb{N} =$  
> $= (2 m &#8211; 2) \times m^\mathbb{N} + m \times m^\mathbb{N} = (3 m &#8211; 2) \times m^\mathbb{N}$

and by applying this procedure $k$ times we get

> $m^\mathbb{N} = (k m &#8211; k + 1) \times m^\mathbb{N}$

from which it follows that

> $m^\mathbb{N} = (m^\mathbb{N})^\mathbb{N} = ((k m &#8211; k + 1) \times m^\mathbb{N})^\mathbb{N} =$  
> $= (k m &#8211; k + 1)^\mathbb{N} \times m^{\mathbb{N} \times \mathbb{N}} = (m (k m &#8211; k + 1))^\mathbb{N}.$

My trick can therefore show that $m^\mathbb{N} = n^\mathbb{N}$ provided there are $k$ and $j$ such that

> $m (k m &#8211; k + 1) = n (j n &#8211; j + 1)$.

This is a linear Diophantine equation in $k$ and $j$:

> $m (m &#8211; 1) k &#8211; n (n &#8211; 1) j = n &#8211; m$.

It has a solution if, and only if, the greatest common divisor of $m (m &#8211; 1)$ and $n (n &#8211; 1)$ divides $n &#8211; m$. It is easy to find pairs $(m,n)$ for which there is no solution, e.g., $(m=2,n=3)$, $(m=3,n=7)$, $(m=4,n=9)$, etc.

Perhaps someone can come up with a different trick that always works. Remember, you are only supposed to use the general laws that hold in bicartesian closed categories, for details see the paper [&#8220;Remarks on Isomorphisms in Typed Lambda Calculi with Empty and Sum Types&#8221;](http://www.cl.cam.ac.uk/~mpf23/papers/Types/shortremarks.pdf) by [Marcelo Fiore](www.cl.cam.ac.uk/~mpf23/), [Roberto Di Cosmo](http://www.dicosmo.org/index.html.en), and [Vincent Balat](http://www.pps.jussieu.fr/~balat/).