---
id: 1933
title: Formal proofs are not just deduction steps
date: 2016-08-30T17:08:36+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=1933
permalink: /2016/08/30/formal-proofs-are-not-just-deduction-steps/
categories:
  - General
---
I have participated in a couple of [lengthy](http://math.andrej.com/2016/08/09/what-is-a-formal-proof/) [discussions](https://golem.ph.utexas.edu/category/2016/08/what_is_a_formal_proof.html) about formal proofs. I realized that an old misconception is creeping in. Let me expose it.

<!--more-->

In traditional mathematical logic (by which I mean first-order logic, as established by Hilbert, Ackermann, Skolem, Gödel and others) the concepts of _logical formula_ and _formal __proof_ are the central notions. This is so because the main goal of traditional logic is the meta-mathematical study of _provability,_ i.e., what can be proved in principle. Other concerns, such as what can be computed in principle, are relegated to other disciplines, such as computability theory.

It is too easy to forget that mathematical logic is only an idealization of what mathematicians actually do. Indeed, a bizarre reversal has occurred in which mathematicians have adopted the practice of dressing up their activity as a series of theorems with proofs, even when a different kind of presentation is called for. Definitions are allowed but seen as just convenient abbreviations, and logicians enforce this view with the [Conservativity theorem](https://en.wikipedia.org/wiki/Conservativity_theorem). Some even feel embarrassed about placing too much motivation and explanatory text in between the theorems, and others are annoyed by a speaker who spends a moment on motivation instead of plunging right into a series of unexplained technical moves.

To show what I am talking about let us consider a typical situation when the theorem-proof form is inappropriate. Often we see a statement and a proof of the form

> **Theorem:** There exists a gadget $x$ such that $\phi(x)$.
> 
> Proof. We construct $x$ as follows. (An explicit construction $C$ is given). QED

but then the rest of the the text clearly refers to the particular construction $C$ from the proof. At a formal level this is wrong because the theorem states $\exists x . \phi(x)$ and it therefore _abstracts away_ the construction in the proof (this is _not_ about excluded middle at all, in case you are wondering). Whatever is done inside the proof is inaccessible because [proofs are irrelevant](https://www.cs.cmu.edu/~fp/courses/15317-f08/lectures/08-irrelevance.pdf).

Lately Vladimir Voevodsky has been advocating a different style of writing in which we state _Problems_ which are then solved by giving _constructions_ (see for instance [page 3 here](http://arxiv.org/pdf/1601.02158v1.pdf))_._ This is a strict generalization of traditional logic because a theorem with a proof can be seen as the problem/construction “construct the proof of the given statement”. Vladimir Voevodsky may have been motivated by Martin-Löf's type theory, where this is the common view, but let us also note that Euclid [did it as well](http://aleph0.clarku.edu/~djoyce/java/elements/bookIV/propIV10.html). Remembering Euclid and paying attention to Martin-Löf's teaching is a very positive development, but is not the one I would like to talk about.

Another crucial component of mathematical activity which is obscured by traditional logic is _computation_. Traditional logic, and to some extent also type theory, hides computation behind equality. Would you like to compute $2 + 2$? Just make a series of deduction steps whose conclusion is $2 + 2 = 4$. But how do we know what we are supposed to prove if we have not calculated the result yet? Computation is _not_ about proving equalities, it is a _process_ which leads from inputs to outputs. Moreover, I claim that computation is a _fundamental_ process which requires no expression in terms of another activity, nor does it need an independent justification.

Another word for computation is _manipulation of objects_. Even in traditional logic we must admit that before logic itself comes manipulation of syntax. One has to be able not only to build and recognize syntactic objects, but also manipulate them in non-trivial ways by performing substitution. Once substitution is on the table we're only a step away from $\lambda$-calculus.

The over-emphasis on formal derivations is making difficult certain discussions and design decisions about computer-verified mathematics. Some insist that formal derivations must be accessible, either explicitly as objects stored in memory or implicitly through applications of structural recursion, for independent proof-checking or proof transformations. I think this is fine as far as derivations and constructions go, but let us not forget computation. It is a design error to encode computations as chains of equations glued together by applications of transitivity. An independent verification of a computation involves independently re-running the computation – not verifying someone else's trace of it encoded as a derivation. A transformation of a computation is not a transformation of a chain of equations – it is something else, but what? I am not sure.

Once computation is recognized as essential, irreducible and fundamental, we can start asking the right questions:

  1. _What is computation in general?_
  2. _What form of computation should be allowed in proof checkers?_
  3. _How do we specify computation in proof objects so that it can be independently verified by proof checkers?_

We have a pretty good idea about the answer to the first question.

A good answer to the second question seems difficult to accept. Several modern proof assistants encode computation in terms of normalization of terms, which shows that they have not quite freed themselves from the traditional view that computation is about proving equalities. If we really do believe that computation is basic then proof checkers should allow _general_ and _explicit_ computation inside the trusted core. After all, if you do not trust your own computer to compute correctly, why would you trust it to verify proofs?

The third question is about design. Coq has [Mtac](http://plv.mpi-sws.org/mtac/), HOL and Andromeda essentially _are_ [meta](http://www.ocaml.org/)-[level](http://andromedans.github.io/andromeda/meta-language.html) programming languages, and Agda has [rewrite rules](http://www.types2016.uns.ac.rs/images/abstracts/cockx.pdf). I suppose I do not have to explain my view here: there is little reason to make the user jump through hoops by having them encode computation as normalization, or application of tactics, or whatnot. Just give them a programming language!

Lest someone misunderstands me, let me conclude by a couple of disclaimers.

First, I am _not_ saying that anything was wrong with the 20th century logic. It was amazing, it was a revolution, a pinnacle of human achievement. It's just that the current century (and possible all the subsequent ones) belongs to computers. The 20th century logicians thought about what _can be formally proved in principle_, while we need to think about _how to formally prove in practice_.

Second, I am _not_ advocating untrusted or insecure proof checkers. I am advocating _flexible_ trusted proof checkers that allow users a _direct expression_ of their mathematical activity, which is not possible as long as we stick to the traditional notion of formal derivation.

**Supplemental:** I think I should explain a bit more precisely how I imagine basic computations would be performed in a trusted kernel. A traditional kernel checks that the given certificate is valid evidence of derivability of some judgment. (Note: I did not say that kernels check formal derivations because they do not do that in practice. Not a single one I know.) For instance, in Martin-Löf type theory a typing judgment $\Gamma \vdash e : A$ contains enough information to decide whether it is derivable, so it can be used as a certificate for its own derivability. Now, sometimes it makes sense to compute parts of the judgment on the fly (typically $e$) instead of giving it explicitly, for various reasons (efficiency, modularity, automation). In such cases it should be possible to provide a program $p$ which computes those parts, and the kernel should know how to run $p$. (It is irrelevant whether $p$ is total,  but that is a separate discussion.) There is of course the  question of how we can trust computations. There are in fact several such questions:

  1. _Can we trust the kernel to faithfully execute programs? _For instance, if the kernel uses the CPU to compute sums of 64-bit integers, can that be trusted? And what if the language interpreter has a bug? This is the same sort of trust as general trust in the kernel, so it is not really new: in order to know that the kernel works correctly we need to certify all components that it depends on (the CPU, the operating system, the compiler used to compile the kernel, the source code of the kernel, etc.)
  2. _Can the programs executed by the kernel perform illegal instructions that corrupt the it or trick it into doing something bad?_ This is a standard question about programming languages that is addressed by [safety theorems](https://www.cs.cmu.edu/~fp/courses/15312-f04/handouts/06-safety.pdf).
  3. _Can we trust that the given program $p$ actually computes the intended object?_ In some situations this question is irrelevant because the evidence will be checked later on anyway. An example of this would be a program which computes (parts of) a witness $(a,b)$ for a statement $\sum\_{x : A} B(x)$. We do not care where $(a,b)$ came from because the kernel is going to use them as certificates of $\sum\_{x : A} B(x)$ and discover potential problems anyhow. In other situations we are very much interested in knowing that the program does the right thing, but this is a standard situation as well: if you need to know that your program works correctly, state and prove the correctness criterion.

So I think there's nothing new or fishy about trust and correctness in what I am proposing. The important thing is that we let the kernel run arbitrary programs that the user can express directly the way programs are normally written in an general-purpose programming language. Insisting that computation take on a particular form (a chain of equations tied together by transitivity, prolog-like proof search, a confluent and terminating normalization procedure) is ultimately limiting.
