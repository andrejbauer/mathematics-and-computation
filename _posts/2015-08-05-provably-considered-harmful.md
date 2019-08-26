---
id: 1868
title: Provably considered harmful
date: 2015-08-05T20:19:14+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=1868
permalink: /2015/08/05/provably-considered-harmful/
categories:
  - General
  - Off topic
---
This is officially a rant and should be read as such.

Here is my pet peeve: theoretical computer scientists misuse the word &#8220;provably&#8221;. Stop it. Stop it!  
<!--more-->

Theoretical computer science is closer to mathematics than it is to computer science. There are definitions, theorems and proofs. Theoretical computer scientists must understand mathematical terminology. The words &#8220;proof&#8221; and &#8220;provable&#8221; are in the domain of mathematical logic. A statement is provable if it has a proof in a given formal system. It makes no sense to say &#8220;provable&#8221; without specifying or implying a specific proof system.

But theoretical computer scientists say things like (I just googled these randomly) [&#8220;A Provably Optimal Algorithm for Crowdsourcing&#8221;](http://papers.nips.cc/paper/5431-spectral-methods-meet-em-a-provably-optimal-algorithm-for-crowdsourcing.pdf) and [&#8220;A Provably Correct Learning Algorithm for Latent-Variable PCFGs&#8221;](http://homepages.inf.ed.ac.uk/scohen/acl14pivot+supp.pdf) and even [&#8220;provably true&#8221;.](https://books.google.ba/books?id=mXCEJoEKRccC&pg=PA116&lpg=PA116&dq=provably+types&source=bl&ots=JvvbEb_mLM&sig=KU7Y0CeTHafUZ1YJOYXV7ZRseW4&hl=en&sa=X&ved=0CCYQ6AEwAmoVChMI1qqOsb6SxwIVBtUsCh3qUAwS#v=onepage&q=provably%20types&f=false)

So what is a &#8220;provably optimal algorithm&#8221; ? It is an algorithm for which there exists a proof of optimality. But why would you ever want to say that in the title of your paper? I can think of several reasons:

  1. You proved that there exists a proof of optimality but did not actually find the proof itself. This of course is highly unlikely,  but that does even not matter, for as soon as we know there exists a proof, the algorithm **is** optimal. Just say &#8220;optimal algorithm&#8221; and the world will be a more exact place.
  2. Your paper is an intricate piece of logic which analyzes existence of proofs of optimality in some super-important formal systems. This of course is not what theoretical computer scientists do for the most part. Any paper which actually did this, would instead say something like &#8220;$\mathrm{Ind}(\Sigma^0_1)$-provability of optimality&#8221;.
  3. You distinguish between algorithms which are optimal and those which are optimal and you proved they&#8217;re optimal. In that case we should turn tables: if you ever publish a claim of optimality without having proved it, put that in your title and call it &#8220;Unproved optimal algorithm&#8221;.
  4. You proved that your algorithm is optimal, showed the proof to the anonymous referee and the editor, and then published your optimal algorithm without proof. You want to tease your readers by telling them &#8220;there is a proof but it&#8217;s a secret&#8221;. If this is what you meant to convey, then the title was well chosen.

To see that &#8220;provable&#8221; is just a buzzword, consider what it would mean to have the opposite, that is an &#8220;unprovably optimal algorithm&#8221;. That is an algorithm which is optimal, but there exists no proof of optimality. Such a thing can be manufactured by a logician, probably, but is certainly not found in everyday life.

As someone is going to say that &#8220;provably true&#8221; makes sense, let me also comment on that. A statement is true if it is valid in all models. So &#8220;provably true&#8221; would mean something like &#8220;there exists a proof in a given formal system that the statement is valid in all models&#8221;. Well, I will not deny that a situation might arise in which this sort of thing is precisely what you would consider, but I will also bet you that it is far more likely that &#8220;provably true&#8221; should just be replaced by either &#8220;provable&#8221; or &#8220;true&#8221;, depending on the particularities of the situation.

**As a rule of thumb, unless you are a logician, if you feel like using the word &#8220;provably&#8221;, just skip it.**

And as long as I am ranting, please stop introducing every single concept with &#8220;informally&#8221; and prefixing every single displayed formula with &#8220;formally&#8221;. Which is it,

  1. you think that &#8220;informal&#8221; descriptions are somehow unworthy or broken, and you should therefore alert the reader that you&#8217;re lying to them, or
  2. you think that &#8220;formal&#8221; descriptions are an unnecessary burden which must be included in the paper to satisfy the gods of mathematics?

If the former, stop lying to your readers, and if the latter stop doing theoretical computer science.

Now I will go on to refereeing that pile of POPL papers which must contain at least a dozen misuses of &#8220;provably&#8221; and two dozen false formal/informal dichotomies.