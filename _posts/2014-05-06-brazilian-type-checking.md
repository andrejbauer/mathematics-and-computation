---
id: 1633
title: Brazilian type checking
date: 2014-05-06T11:59:15+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=1633
permalink: /2014/05/06/brazilian-type-checking/
categories:
  - Homotopy type theory
  - Talks
---
I just gave a talk at [&#8220;Semantics of proofs and certified mathematics&#8221;](https://ihp2014.pps.univ-paris-diderot.fr/doku.php?id=workshop_1). I spoke about a new proof checker [Chris Stone](http://www.cs.hmc.edu/~stone/) and I are working on. The interesting feature is that it has both kinds of equality, the &#8220;paths&#8221; and the &#8220;strict&#8221; ones. It is based on a [homotopy type system](https://uf-ias-2012.wikispaces.com/file/view/HTS.pdf/410120566/HTS.pdf) proposed by [Vladimir Voevodsky](http://www.math.ias.edu/~vladimir/Site3/home.html). The slides contain talk notes and explain why it is &#8220;Brazilian&#8221;.

**Download slides:** [brazilian-type-checking.pdf  
](/wp-content/uploads/2014/05/brazilian-type-checking.pdf)  
**GitHub repository:** <https://github.com/andrejbauer/tt>

**Abstract:** Proof assistants verify that inputs are correct up to judgmental equality. Proofs are easier and smaller if equalities without computational content are verified by an oracle, because proof terms for these equations can be omitted. In order to keep judgmental equality decidable, though, typical proof assistants use a limited definition implemented by a fixed equivalence algorithm. While other equalities can be expressed using propositional identity types and explicit equality proofs and coercions, in some situations these create prohibitive levels of overhead in the proof.  
Voevodsky has proposed a type theory with two identity types, one propositional and one judgmental. This lets us hypothesize new judgmental equalities for use during type checking, but generally renders the equational theory undecidable without help from the user.

Rather than reimpose the full overhead of term-level coercions for judgmental equality, we propose algebraic effect handlers as a general mechanism to provide local extensions to the proof assistant&#8217;s algorithms. As a special case, we retain a simple form of handlers even in the final proof terms, small proof-specific hints that extend the trusted verifier in sound ways.