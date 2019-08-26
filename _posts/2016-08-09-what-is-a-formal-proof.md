---
id: 1920
title: What is a formal proof?
date: 2016-08-09T14:28:11+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=1920
permalink: /2016/08/09/what-is-a-formal-proof/
categories:
  - Andromeda
  - Logic
---
Mike Shulman just wrote a very nice [blog post on what is a formal proof](https://golem.ph.utexas.edu/category/2016/08/what_is_a_formal_proof.html). I much agree with what he says, but I would like to offer my own perspective. I started writing it as a comment to Mike&#8217;s post and then realized that it is too long, and that I would like to have it recorded independently as well. Please read Mike&#8217;s blog post first.

<!--more-->

Just as Mike, I am discussing here formal proofs from the point of view of proof assistants, i.e., what criteria need to be satisfied by the things we call &#8220;formal proofs&#8221; for them to serve their intended purpose, which is: to convince machines (and indirectly humans) of mathematical truths.  Just as Mike, I shall call a (formal) proof a _complete_ derivation tree in a formal system, such as type theory or first-order logic.

What Mikes calls an _argument_ I would prefer to call a _proof representation_. This can be any kind of concrete representation of the actual formal proof. The representation may be very indirect and might require a lot of effort to reconstruct the original proof. Unless we deal with an extremely simple formal system, there is always the possibility to have _invalid representations_, i.e., data of the correct datatype which however does not represent a proof.

I am guaranteed to reinvent the wheel here, at least partially, since many people before me thought of the problem, but here I go anyway. Here are (some) criteria that formal proofs should satisfy:

  * **Reproducibility:** it should be possible to replicate and communicate proofs. If I have a proof it ought to be possible for me to send you a copy of the proof.
  * **Objectivity:** all copies of the same proof should represent the same piece of information, and there should be no question what is being represented.
  * **Verifiability:** it should be possible to recognize the fact that something is a proof.

There is another plausible requirement:

  * **Falsifiability:** it should be possible to recognize the fact that something is _not_ a proof.

Unlike the other three requirements, I find falsifiability questionable. I have received too many messages from amateur mathematicians who could not be convinced that their proofs were wrong. Also, mathematics is a cooperative activity in which mistakes (both honest and dishonest) are easily dealt with – once we expand the resources allocated to verifying a proof we simply give up. An adversarial situation, such as [proof carrying code](https://en.wikipedia.org/wiki/Proof-carrying_code), is a different story with a different set of requirements.

The requirements  impose conditions on how formal proofs in a proof assistant might be designed.  Reproducibility dictates that proofs should be easily accessible and communicable. That is, they should be pieces of digital information that are commonly handled by computers. They should not be prohibitively large, of if they are, they need to be suitably compressed, lest storage and communication become unfeasible. Objectivity is almost automatic in the era of crisp digital data. We will worry about Planck-scale proof objects later. Verifiability can be ensured by developing and implementing algorithms that recognize correct representations of proofs.

This post grew out of a comment that I wanted to make about a particular statement in Mike&#8217;s post. He says:

> &#8220;&#8230; for a proof assistant to honestly call itself an _implementation_ of that formal system, it ought to include, somewhere in its internals, some data structure that represents those proofs reasonably faithfully.&#8221;

This requirement is too stringent. I think Mike is shooting for some combination of reproducibility and verifiability, but explicit storage of proofs in raw form is only one way to achieve them. What we need instead is _efficient communication_ and _verification _of (communicated) proofs. These can both be achieved without storage of proofs in explicit form.

Proofs may be stored and communicated in implicit form, and proof assistants such as Coq and Agda do this. Do not be fooled into thinking that Coq gives you the &#8220;proof terms&#8221;, or that Agda aficionados type down actual complete proofs.  Those are not the derivation trees, because they are missing large subtrees of equality reasoning. Complete proofs are too big to be communicated or stored in memory (or some day they will be), and little or nothing is gained by storing them or re-verifying their complete forms. Instead, it is better to devise compact representations of proofs which get _elaborated_ or _evaluated_ into actual proofs on the fly. Mike comments on this and explains that Coq and Agda both involve a large amount of elaboration, but let me point out that even the elaborated stuff is still only a shadow of the actual derivation tree. The data that gets stored in the Coq .vo file is really a bunch of instructions for the proof checker to easily reconstruct the proof using a specific algorithm. The _actual_ derivation tree is implicit in the execution trace of the proof checker, stored in the space-time continuum and inaccessible with pre-Star Trek technology. It does not matter that we cannot get to it, because the whole process is replicable. If we feel like going through the derivation tree again, we can just run the proof assistant again.

I am aware of the fact that people strongly advocate some points which I am arguing against, two of which might be:

  * Proofs assistants must provide proofs that can be independently checked.
  * Proof checking must be _decidable_, not just _semi-decidable._

As far as I can tell, nobody actually subscribes to these in practice. (Now that the [angry Haskell mob](http://math.andrej.com/2016/08/06/hask-is-not-a-category/) has subsided, I feel like I can take a hit from an angry proof assistant mob, which the following three paragraphs are intended to attract. What I _really_ want the angry mob to think about deeply is how their professed beliefs match up with their practice.)

First, nobody downloads compiled .vo files that contain the proof certificates, we all download other people&#8217;s original .v files and compile them ourselves. So the .vo files and proof certificates are a double illusion: they do not contain actual proofs but half-digested stuff that may still require a lot of work to verify, and nobody uses them to communicate or verify proofs anyhow. They are just an optimization technique for faster loading of libraries. The _real_ representations of proofs are in the .v files, and those can only be _semi-_checked for correctness.

Second, in practice it is irrelevant whether checking a proof is decidable because the elaboration phase and the various proof search techniques are possibly non-terminating anyhow. If there are a couple of possibly non-terminating layers on top of the trusted kernel, we might as well  let the kernel be possibly non-terminating, too, and instead squeeze some extra expressivity and efficiency from it.

Third, and still staying with decidability of proof checking, what actually _is_ annoying are uncontrollable or unidentifiable sources of inefficiency. Have you ever danced a little dance around Coq or Agda to cajole its _terminating_ normalization procedure into finishing before getting [run over by Andromeda](https://en.wikipedia.org/wiki/Andromeda–Milky_Way_collision)? Bow to the gods of decidable proof checking.

It is far more important that _cooperating_ parties be able to communicate and verify proofs efficiently, than it is to be able to tell whether an _adversary_ is wasting our time. Therefore, proofs should be, and in practice are communicated in the most flexible manner possible, as programs. LCF-style proof assistants embrace this idea, while others move slowly towards it by giving the user ever greater control over the internal mechanisms of the proof assistant (for instance, witness Coq&#8217;s recent developments such as partial user control over the universe mechanism, or Agda&#8217;s rewriting hackery). In an adversarial situations, such as [proof carrying code](https://en.wikipedia.org/wiki/Proof-carrying_code), the design requirements for formalized proofs are completely different from the situation we are considering.

We do not expect humans to memorize every proof of every mathematical statement they ever use, nor do we imagine that knowledge of a mathematical fact is the same thing as the proof of it. Humans actually memorize &#8220;proof ideas&#8221; which allow them to replicate the proofs whenever they need to. Proof assistants operate in much the same way, for good reasons.