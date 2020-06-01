---
title: "Everything you wanted to know about proof assistants (but were afraid to ask)"
author: Andrej Bauer
layout: post
categories:
  - Tutorial
  - Formalized mathematics
---

When a mathematician first encounters formalized mathematics and [proof
assistants](https://en.wikipedia.org/wiki/Proof_assistant) they find themselves using a
complex piece of software that is maddeningly stupid and brilliantly smart at the same
time. The proof assistant uses strange concepts, such as "type checking", "implicit
arguments" and "type classes", which have little to do with mathematics and feel more
programming concepts

In this post I explain that the design of proof assistants is fashioned after how
mathematics is done in practice, even though this may not be obvious at first sight.

From a mathematical point of view I shall speak about trivialities, namely the
mathematical [vernacular](https://en.wikipedia.org/wiki/Vernacular) and the mathematical
culture that you learned by osmosis as a student from your teachers. You see, a proof
assistant is a mere machine that, unlike humans, is unable to receive knowledge implicitly
through social interaction. Therefore, computer scientists invented concepts, such as
, which reflect help the machine understand
how mathematics is actually done. If huma

You therefore have to meet it half way


assistants take the cultural and linguistic phenomena

make
explicit and precise concepts which mathematicians use all the time but do not consider
them to be part of "proper mathematics".


<!--more-->


#### The proof assistant language

When you work with a proof assistant you do *not* write down complete proofs in a formal
logical system. That would be quite impossible because you are not a machine. Instead, you
give the proof assistant *hints*, *high-level instructions* or *advice* on what you want
and how it should go about constructing complete formal proofs under the hood. You do so
in a specialized computer language that you need to learn and use precisely. *Any*
inaccuracy on your part will throw off the proof assistant and cause it to complain. On
the bright side, the proof assistant language is designed to reflect the traditional
mathematical vernacular as much as possible.


#### Notation

Mathematicians use all sorts of notations: letters from Latin, Greek, and Hebrew
alphabets, various symbols, fractions, diagrams, etc. Therefore, proof assistants support
a variety of notational conveniences.

If you are lucky, your proof assistant will come with an easy way of typing mathematical
symbols, for instance, when you type `\otimes` you will automatically get the
corresponding UTF-8 character `⊗`. If you are unlucky, you will spend a couple of days
installing arcane editing modes in an editor from 1970's, or will be subjected to using an
experimental proof assistant that has no support for mathematical symbols.

When a new symbol is introduced we need to specify its precedence and associativity:

* **Precedence** (or **priority**) tells how tightly the operation binds, e.g., because
  `×` has a higher precedence than `+`, the expression `6 + 4 × 9` is understood as `6 +
  (4 × 9)` rather than `(6 + 4) × 9`.

* **Associativity** tells us how to place parentheses when the operation is repeated
  several times, e.g., because `-` is *left-associative* the expression `10 - 5 - 2` is
  read as `(10 - 5) - 2` rather than `10 - (5 - 2)`. The symbol `+` is also
  left-associative, and it is irrelvant that addition of numbers happens to be an
  associative operation. The proof assistant insists on precise and unambiguous notation
  *before* you can even write down the associativity law.

Your proof assistant will have some way of specifying new notations that will likely
involve specifying precedence and associativity.


#### Everything has a name

When you have a piece of mathematics on a whiteboard you can point to anything you like
and your colleague immediately sees what you are referring to. In mathematical prose
anything that is referred to must be numbered: theorems, equations, diagrams, etc. Because
using numbers as references is primitive and error-prone, LaTeX allows you to use
labels that it automatically converts to numbers.

A proof assistant is no different, except that it does not use numbers at all. Anything
that can be referred to has a name: theorems, definitions, constructions, operations,
constants, components of structure, tactics, etc. There is rather more naming going on
than one might expect. For instance, in a formalization of ring theory we might encounter
the following names:

* `ring_struct`: a structure $(R, 0, 1, {+}, {×}, {-})$ where $0, 1 \in R$, $+$ and $\times$
  are binary operations on $R$, and $-$ is a unary operation on $R$, but *without* the
  ring axioms,

* each component of a `ring_struct` needs a name: `carrier`, `zero`, `one`, `plus`, `times` and
  `negation`,

* notations for the components: `0` for `zero`, `1` for `one`, `+` for `plus`, `×` for
  `times`, and `-` for `negation`,

* precedences and associativity for `+`, `×` and `-`,

* `ring_axioms`: a collection of axioms, each having a name, stating that a ring structure
  is a ring: `plus_commutative`, `plus_associative`, `zero_neutral`, `negation_inverse`,
  `times_commutative`, `times_associative`, `one_neutral`, and `distributivity`.

* `ring`: a structure which combines `ring_struct` and `ring_axioms` to give a ring.

That is more than a dozen names just to define a ring, and we are only getting started. In
large formalization projects naming conventions become extremely important, lest one gets
lost in a morass of unintelligible ad-hoc names. For instance, the [HoTT
library](https://github.com/HoTT/HoTT) is a medium-sized formalization of homotopy type
theory whose [global index](http://hott.github.io/HoTT/coqdoc-html/) has more than 40000
entries. When was the last time you wrote a LaTeX file with 400 labels, let alone 40000?

A proof assistant helps organize formalized mathematics into units called "modules",
"sections" or "namespaces". Of course, each module has a name. Here is the [dependency
graph](http://hott.github.io/HoTT/dependencies/HoTTCore.svg) of the core modules in the
HoTT library. There is an edge between units if one refers to an entity in the other.

Sometimes a proof assistant generates a bunch of things automatically and gives them
names. For example, when you define the natural numbers in [Coq]((https://coq.inria.fr)) with

    Inductive N : Type := Zero | Succ : nat -> nat.

the response you get is

    N is defined
    N_rect is defined
    N_ind is defined
    N_rec is defined
    N_sind is defined

So in addition to the natural number `N` we also got four other things. As it turns out,
these are various forms of induction and recursion for natural numbers. For instance,
`N_ind` is the familiar induction principle

    ∀ P : N → Prop, P Zero → (∀ n : N, P n → P (Succ n)) → ∀ n : N, P n


#### Type checking

A proof assistant verifies that the things you give it make sense. It does so in several
stages.

First it perfroms *lexical analysis*, which prevents you from writing down complete
nonsense, such as trying to name a theorem `I#$🤪)!hate_^ℓ∈m`. Next comes *syntax parsing*,
which makes sure the expressions you write have matching parentheses and are generally
well formed, although they need not make mathematical sense.

After parsing the proof assistant verifies that the components of your expressions make
mathematical sense. For example, if you defined a function `f : real → real` and variables
`x, y : real` then the expression `f(x,y)` is problematic, because `f` wants just one
argument but it was given two. Computer scientists call this sort of a problem a **type
error**. A proof assistant performs **type checking** by running an algorithm which
verifies that there are no type errors. When it detects a problem, it prints out a cryptic
error message. You will have to learn read such messages. For example,
[Coq](https://coq.inria.fr) responds to the above ill-formed expression `f(x,y)` with

    Error:
    The term "(x, y)" has type "(real * real)%type"
    while it is expected to have type "real".


It is sort of intelligible, except that for some reason it printed "`(real * real)%type`"
instead of "`real * real`". [Agda](https://wiki.portal.chalmers.se/agda/pmwiki.php)'s error
message is worse:

    (_A_11 × _B_12) !=< real
    when checking that the inferred type of an application
      _A_11 × _B_12
    matches the expected type
      real

It is not clear what the first line is about, perhaps "`!=<`" is a Swedish expletive. It
speaks of an "inferred type of an application" `_A_11 × _B_12`, which is odd as the
application `f(x,y)` should have type `real`. And where did it get the ridiculous names
`_A_11` and `_B_12`? (Hint: it is saying that the application of the *pairing* opration to
`x` and `y` should have type `real`). You will get used to this sort of thing.

### Elaboration

It is not true that the parsing phase is followed by type checking. Before type checking
there is an extra phase which employs a number of techniques to guess what the user
actually meant to write. You may not be aware of this, but in order to understand a
typical mathematical text you have to do a lot of guessing.


##### Type inference

In the statement

> *If $p$ is prime and $p$ divides $a \cdot b$ then $p$ divides $a$ or it divides $b$.*

you can tell that $p$, $a$ and $b$ are natural numbers because divisibility and primality
are about natural numbers. You *inferred* the types of symbols from their usage. A proof
assistant can do the same because its type checking algorithm has a type inference
component that has the ability to infer the missing types.

To be quite precise, it is possible to read the above statement as referring to integers,
or even to an [integral domain](https://en.wikipedia.org/wiki/Integral_domain). A
mathematician will guess what is meant from the wider social context, but a proof
assistant needs a little help. Typically, there is a command, such as `import`, `require`
or `open` which tells the proof assistant what units of mathematics we're going to work
with.

Sometimes it is necessary to specify what is going on in just a single expression. For
instance, in Coq you can write "`(⋯)%S`" to indicate that the expression inside the
parentheses is to be read in *scope* `S` (In Coq the word "context" means something else).
Thus, in the above error message Coq printed "`(real * real)%type`" instead of "`real *
real`" to helpfully tell us that the `*` symbol refers to product of types, and not to
multiplication of natural numbers.

##### Implicit coercions

Let us return to the example of a ring. In Coq it would be defined as a *structure*:


##### Implicit arguments

Mathematicians prefer concise and handy notation that does not contain unecessary clutter.
Imagine you had to write a text on linear algebra in which every single sum of vectors
$x + y$ would have to be explicltly tagged with the vector space, so you would have to
write $x +_V y$ all the time. That would not only be annoying but also counter-productive,
as no harm is done by eliding the subscript $V$ because it can be easily inferred.

A proof assistant can handle such easily inferred **implicit arguments**. In Coq, Agda and Lean


##### Type classes


### What to expect?
