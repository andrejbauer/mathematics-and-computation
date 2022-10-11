---
author: Andrej Bauer
title: "Happy birthday, Dana!"
layout: post
categories:
  - News
---

Today [Dana Scott](https://www.cmu.edu/math/people/faculty/scott.html) is celebrating the 90th birthday today. **Happy birthday, Dana!** I am forever grateful for your kindness and the knowledge that I received from you. I hope to pass at least a part of it onto my students.

On the occasion [Steve Awodey](https://awodey.github.io) assembled selected works by Dana Scott at [`CMU-HoTT/scott`](https://github.com/CMU-HoTT/scott) repository. It is an amazing collection of papers that had deep impact on logic, set theory, computation, and programming languages. I hope in the future we can extend it and possibly present it in better format.

As a special treat, I recount here the story the invention of the famous $D_\infty$ model of the untyped $\lambda$-calculus.
I heard it first when I was Dana's student. In 2008 I asked Dana to recount it in the form of a short interview.

<!--more-->

**These days domain theory is a mature branch of mathematics. It has had profound influence on the theory and practice of programming languages. When did you start working on it and why?**

**Dana Scott:** I was in Amsterdam in 1968/69 with my family. I met Strachey at IFIP WG2.2 in summer of 1969. I arranged leave from Princeton to work with him in the fall of 1969 in Oxford. I was trying to convince Strachey to use a type theory based on domains.

**One of your famous results is the construction of a domain $D_\infty$ which is isomorphic to its own continuous function space $D_\infty \to D_\infty$. How did you invent it?**

**D. S.:** $D_\infty$ did not come until later. I remember it was a quiet Saturday in November 1969 at home. I had proved that if domains $D$ and $E$ have a countable basis of finite elements, then so does the continuous function space $D \to E$. In understanding how often the basis for $D \to E$ was more complicated than the bases for $D$ and $E$, I then thought, “Oh, no, there must exist a bad $D$ with a basis so 'dense' that the basis for $D \to D$ is just as complicated – in fact, isomorphic.” But I never proved the existence of models exactly that way because I soon saw that the iteration of $X \mapsto (X \to X)$ constructed a suitable basis in the limit. That was the actual $D_\infty$ construction.

**Why do you say “oh no”? It was an important discovery!**

**D. S.:** Since, I had claimed for years that the type-free $\lambda$-calculus has no “mathematical” models (as distinguished from term models), I said to myself, “Oh, no, now I will have to eat my own words!”

**The existence of term models is guaranteed by the Church-Rosser theorem from 1936 which implies that the untyped lambda calculus is consistent?**

**D. S.:** Yes.

**The domain $D_\infty$ is an involved construction which gives a model for the calculus with both $\beta$- and $\eta$-rules. Is it easier to give a model which satisfies the $\beta$-rule only?**

**D. S.:** Since the powerset of natural numbers $P\omega$ (with suitable topology) is universal for countably-based $T_0$-spaces, and since a continuous lattice is a retract of every superspace, it follows that $P\omega \to P\omega$ is a retract of $P\omega$. This gives a non-$\eta$ model without any infinity-limit constructions. But continuous lattices had not yet been invented in 1969 – that I knew of.

**Where can the interested readers read more about this topic?**

**D.S.:** I would recommend these two:

*   Scott, D. [A type-theoretical alternative to ISWIM, CUCH, OWHY](https://github.com/CMU-HoTT/scott/blob/main/pdfs/1993-a-type-theoretical-aternative-to-ISWIM-CUCH-OWHY.pdf). Theoretical Computer Science, vol. 121 (1993), pp. 411-440.
*   Scott, D. [Some Reflections on Strachey and his Work](https://doi.org/10.1023/A:1010018211714). A Special Issue Dedicated to Christopher Strachey, edited by O. Danvy and C. Talcott. Higer-Order and Symbolic Computation, vol. 13 (2000), pp. 103-114.

**Thank you very much!**

**Dana Scott:** You are welcome.
