---
id: 69
title: Seemingly impossible functional programs
date: 2007-09-28T17:21:22+02:00
author: Martin Escardo
layout: post
guid: http://math.andrej.com/2007/09/28/seemingly-impossible-functional-programs/
permalink: /2007/09/28/seemingly-impossible-functional-programs/
categories:
  - Computation
  - Guest post
  - Tutorial
---

Andrej has invited me to write about certain surprising functional
programs.
The first program, due to [Ulrich Berger](http://www.cs.swan.ac.uk/~csulrich/) (1990), performs exhaustive
search over the “[Cantor space](http://en.wikipedia.org/wiki/Cantor_space)” of infinite sequences of binary
digits. I have included references at the end. A weak form of
exhaustive search amounts to checking whether or not a total predicate
holds for all elements of the Cantor space. Thus, this amounts to
universal quantification over the Cantor space. Can this possibly be
done algorithmically, in finite time?
<!--more-->


A stronger one amounts to
finding an example such that the predicate holds, if such an example
exists, and saying that there isn't any otherwise.

I will use the language [Haskell](http://www.haskell.org/), but it is possible to
quickly translate the programs to e.g. ML or [OCaml](http://www.ocaml.org). The source code shown here is attached as [seemingly-impossible.hs](/wp-content/uploads/2007/09/seemingly-impossible.hs).

We could use the booleans to represent binary digits, or even the
integers, but I prefer to use a different type to avoid confusions:

<pre>> data Bit = Zero | One
>          deriving (Eq)</pre>

The <tt>deriving</tt> clause tells Haskell to figure out how to decide equality of bits automatically.

For the type of infinite sequences, we could use the built-in type of
lazy lists for most algorithms considered here. But, in order to
illustrate certain points, I will take the mathematical view and
regard sequences as functions defined on the natural numbers. The next
version of the definition of Haskell will have a built-in type of
natural numbers. For the moment, I implement it as the type of
integers:

<pre>> type Natural = Integer
> type Cantor = Natural -> Bit</pre>

The operator <tt>(#)</tt> takes a bit <tt>x</tt> and a
sequence <tt>a</tt> and produces a new sequence <tt>x # a</tt> with
<tt>x</tt> as the head and <tt>a</tt> as the tail (very much like the
built-in operation <tt>(:)</tt> for lists):

<pre>> (#) :: Bit -> Cantor -> Cantor
> x # a = \i -> if i == 0 then x else a(i-1)</pre>

Notice that the notation <tt>\i -> ...</tt> stands for $\lambda i. \dots$.

Next, we come to the heart of the matter, the functions that perform
exhaustive search over the Cantor space. The specification of the
function <tt>find</tt> is that, for any total <tt>p</tt>, one should
have that <tt>find p</tt> is always a total element of the Cantor
space, and, moreover, if there is <tt>a</tt> in the Cantor space with
<tt>p a = True</tt>, then <tt>a = find p</tt> is an example of such an
<tt>a</tt>.

<pre>> forsome, forevery :: (Cantor -> Bool) -> Bool
> find :: (Cantor -> Bool) -> Cantor</pre>

Because I will have several implementations of <tt>find</tt>, I
have to choose one to be able to compile and run the program. A
canonical choice is the first one,

<pre>> find = find_i</pre>

but you are invited to experiment with the other ones. For the following
definition of <tt>find_i</tt> to make sense, you have to take the above choice.

The function <tt>find</tt> takes a predicate on the Cantor
space, and hence it will typically have a $\lambda$-expression as
argument. In the following definition this is not necessary,
because <tt>(\a -> p a) = p</tt> by the $\eta$ rule. But I have
adopted it for the sake of clarity, as then we can read “<tt>find(\a -> p a)</tt>” aloud as “find <tt>a</tt> such that
<tt>p(a)</tt>“:

<pre>> forsome p = p(find(\a -> p a))
> forevery p = not(forsome(\a -> not(p a)))</pre>

Notice that the function <tt>forevery</tt> (universal quantification)
is obtained from the function <tt>forsome</tt> (existential
quantification) via the [De Morgan Law](http://en.wikipedia.org/wiki/De_Morgan's_laws). The functionals <tt>forsome</tt>
and <tt>find_i</tt> are defined by mutual recursion:

<pre>> find_i :: (Cantor -> Bool) -> Cantor
> find_i p = if forsome(\a -> p(Zero # a))
>            then Zero # find_i(\a -> p(Zero # a))
>            else One  # find_i(\a -> p(One  # a))</pre>

The intuitive idea of the algorithm <tt>find_i</tt> is clear: if
there is an example starting with zero, then the result is taken
to start with zero, otherwise it must start with one. Then we
recursively build the tail using the same idea. What may not be
clear is whether the recursion eventually produces a digit,
because of the indirect recursive call via the call to
<tt>forsome</tt>. A mathematical proof proceeds by induction on
the modulus of uniform continuity of <tt>p</tt>, defined below.

It may be more natural to return an example only if there is
one, and otherwise tell there isn't any:

<pre>> search :: (Cantor -> Bool) -> Maybe Cantor
> search p = if forsome(\a -> p a) then Just(find(\a -> p a)) else Nothing</pre>

The <tt>Maybe</tt> type constructor is predefined by Haskell as

> <tt>data Maybe a = Just a | Nothing</tt>

Type-theoretic remark: the type <tt>Maybe a</tt> corresponds to
the sum type $A+1$, where the only element of $1$ is called
<tt>Nothing</tt> and where <tt>Just</tt> is the insertion $A \to
A+1$.

Exercise: show that both <tt>forsome</tt> and <tt>find</tt> can be
defined directly from <tt>search</tt> assuming we had defined
<tt>search</tt> first.

Common wisdom tells us that function types don't have decidable
equality. In fact, e.g. the function type <tt>Integer -> Integer</tt> doesn't have decidable equality because of the
[Halting Problem](http://en.wikipedia.org/wiki/Halting_problem), as is well known. However, common wisdom is not
always correct, and, in fact, some other function types do have
decidable equality, for example the type <tt>Cantor -> y</tt> for
any type <tt>y</tt> with decidable equality, without
contradicting Turing:

<pre>> equal :: Eq y => (Cantor -> y) -> (Cantor -> y) -> Bool
> equal f g = forevery(\a -> f a == g a)</pre>

This seems strange, even fishy, because the Cantor space is in
some sense bigger than the integers. In a follow-up post,
I'll explain that this has to do with the fact that the Cantor
space is topologically compact, but the integers are not.

Let's run an example:

<pre>> coerce :: Bit -> Natural
> coerce Zero = 0
> coerce One = 1

> f, g, h :: Cantor -> Integer

> f a = coerce(a(7 * coerce(a 4) +  4 * (coerce(a 7)) + 4))

> g a = coerce(a(coerce(a 4) + 11 * (coerce(a 7))))

> h a = if a 7 == Zero
>       then if a 4 == Zero then coerce(a  4) else coerce(a 11)
>       else if a 4 == One  then coerce(a 15) else coerce(a  8)</pre>

Now we call the <tt>ghci</tt> interpreter:

<pre>$ ghci seemingly-impossible.lhs
   ___         ___ _
  / _  /  // __(_)
 / /_// /_/ / /  | |      GHC Interactive, version 6.6, for Haskell 98.
/ /_/ __  / /___| |      http://www.haskell.org/ghc/
____// /_/____/|_|      Type :? for help.

Loading package base ... linking ... done.
[1 of 1] Compiling Main             ( seemingly-impossible.lhs, interpreted )
Ok, modules loaded: Main.

*Main></pre>

At this point we can evaluate expressions at the interpreter's prompt.
First I ask it to print time and space usage after each evaluation:

<pre>*Main> :set +s</pre>

On my Dell 410 laptop running at 1.73GHz, I test the following
expressions:

<pre>*Main> equal f g
False
(0.10 secs, 3490296 bytes)

*Main> equal f h
True
(0.87 secs, 36048844 bytes)

*Main> equal g h
False
(0.09 secs, 3494064 bytes)

*Main> equal f f
True
(0.91 secs, 38642544 bytes)

*Main> equal g g
True
(0.15 secs, 6127796 bytes)

*Main> equal h h
True
(0.83 secs, 32787372 bytes)</pre>

By changing the implementation of <tt>find</tt>, I'll make this
faster and also will be able to run bigger examples. But let's
carry on with the current implementation for the moment.

The following was Berger's main motivation for considering the
above constructions:

<pre>> modulus :: (Cantor -> Integer) -> Natural
> modulus f = least(\n -> forevery(\a -> forevery(\b -> eq n a b --> (f a == f b))))</pre>

This is sometimes called the _Fan Functional_, and goes back to Brouwer
(1920's) and it is well known in the higher-type computability theory
community (see Normann (2006) below). It finds the
_modulus of uniform continuity_, defined as the least natural
number $n$ such that

> $\forall \alpha,\beta(\alpha =_n \beta \to f(\alpha)=f(\beta),$

where

> $\alpha =\_n \beta \iff \forall i < n. \alpha\_i = \beta_i.$

What is going on here is that computable functionals are continuous,
which amounts to saying that finite amounts of the output depend only
on finite amounts of the input. But the Cantor space is compact, and
in analysis and topology there is a theorem that says that continuous
functions defined on a compact space are [_uniformly_](http://en.wikipedia.org/wiki/Uniform_continuity)
continuous. In this context, this amounts to the existence of a single
$n$ such that for all inputs it is enough to look at depth $n$ to get
the answer (which in this case is always finite, because it is an
integer). I'll explain all this in another post. Here I will
illustrate this by running the program in some examples.

Notice that the Haskell definition is the same as the mathematical
one, provided we define all the other needed ingredients:

<pre>> least :: (Natural -> Bool) -> Natural
> least p = if p 0 then 0 else 1 + least(\n -> p(n+1))

> (-->) :: Bool -> Bool -> Bool
> p --> q = not p || q

> eq :: Natural -> Cantor -> Cantor -> Bool
> eq 0 a b = True
> eq (n+1) a b = a n == b n  &&  eq n a b</pre>

To understand the modulus functional in practice, define projections
as follows:

<pre>> proj :: Natural -> (Cantor -> Integer)
> proj i = \a -> coerce(a i)</pre>

Then we get:

<pre>*Main> modulus (\a -> 45000)
0
(0.00 secs, 0 bytes)

*Main> modulus (proj 1)
2
(0.00 secs, 0 bytes)

*Main> modulus (proj 2)
3
(0.01 secs, 0 bytes)

*Main> modulus (proj 3)
4
(0.05 secs, 820144 bytes)

*Main> modulus (proj 4)
5
(0.30 secs, 5173540 bytes)

*Main> modulus (proj 5)
6
(1.69 secs, 31112400 bytes)

*Main> modulus (proj 6)
7
(9.24 secs, 171456820 bytes)</pre>

So, intuitively, the modulus is the last index of the input that the
function uses plus one. For a constant function, like the above, the
modulus is zero, because no index is used.

**Technical remark**. The notion of modulus of uniform
continuity needed for the proof of termination of <tt>find_i</tt>
is not literally the same as above, but a slight variant
(sometimes called the _intensional_ modulus of uniform
continuity, whereas ours is referred to as the
_extensional_ one). But I won't go into such mathematical
subtleties here. The main idea is that when the modulus is $0$ the
recursion terminates and one of the branches of the definition of
<tt>find_i</tt> is followed, and a new recursion is started, to
produce the next digit of the example. When the modulus of
<tt>p</tt> is $n+1$, the modulus of the predicate <tt>\a -> p(Zero # a)</tt> is $n$ or smaller, and so recursive calls are always made
with smaller moduli and hence eventually terminate. **End of
remark.**

Now I'll try to get faster implementations of <tt>find</tt>.
I'll modify the original implementation in several stages.
Firstly, I will remove the mutual recursion by expanding the
definition of the function <tt>forsome</tt> in the definition of
the function <tt>find_i</tt>:

<pre>> find_ii p = if p(Zero # find_ii(\a -> p(Zero # a)))
>             then Zero # find_ii(\a -> p(Zero # a))
>             else One  # find_ii(\a -> p(One  # a))</pre>

This should have essentially the same speed.
Now notice that the branches of the conditional are the same if we
make zero and one into a parameter <tt>h</tt>. Hence one can “factor
out” the conditional as follows:

<pre>> find_iii :: (Cantor -> Bool) -> Cantor
> find_iii p = h # find_iii(\a -> p(h # a))
>        where h = if p(Zero # find_iii(\a -> p(Zero # a))) then Zero else One</pre>

This is (exponentially!) faster for some examples. A clue for
this is that <tt>h</tt> will be evaluated only if and when it is
“used” (our language is lazy). Let's run an example, replacing the
above definition of <tt>find</tt> by <tt>find = find_iii</tt>:

<pre>*Main> equal f h
True
(0.00 secs, 522668 bytes)

*Main> equal (proj 1000) (proj 1000)
True
(0.00 secs, 0 bytes)

*Main> equal (proj 1000) (proj 4000)
False
(0.03 secs, 1422680 bytes)

*Main> equal (proj 1000) (proj(2^20))
False
(7.02 secs, 336290704 bytes)</pre>

As you can see, the bigger the projection functions we try,
the longer the comparison gets. To see how bad the first algorithm is, let's switch back to <tt>find = find_i</tt>:

<pre>*Main> equal (proj 10) (proj 10)
True
(0.05 secs, 1529036 bytes)

*Main> equal (proj 10) (proj 15)
False
(1.61 secs, 72659036 bytes)

*Main> equal (proj 10) (proj 20)
False
(60.62 secs, 2780497676 bytes)</pre>

The previous examples cannot be run with this algorithm unless we had
more bits available than there are atoms in the observable universe
and we were willing to wait several billion-billion years, because the
algorithm is exponential in the modulus of continuity.

You probably noticed that there is another obvious improvement
starting from <tt>find_ii</tt>:

<pre>> find_iv :: (Cantor -> Bool) -> Cantor
> find_iv p = let leftbranch = Zero # find_iv(\a -> p(Zero # a))
>             in if p(leftbranch)
>                then leftbranch
>                else One # find_iv(\a -> p(One # a))</pre>

Actually, I never thought about the performance of this algorithm or
experimented with it. Let's see what we get (you need to replace
<tt>find = find_iv</tt>):

<pre>*Main> equal (proj 10) (proj 20)
False
(0.00 secs, 522120 bytes)

*Main> equal (proj 10) (proj 200)
False
(0.04 secs, 1550824 bytes)

*Main> equal (proj 10) (proj 2000)
False
(3.71 secs, 146039744 bytes)

*Main> equal (proj 10) (proj 20000)
Interrupted.</pre>

Much better than <tt>find_i</tt>, but much worse than
<tt>find_iii</tt>! I gave up in the last example, because it
started to slow down my edition of this post after a minute or so.

But there is a much better algorithm, which I now present. I won't
attempt to explain the working of this algorithm in this post (see
my LICS'2007 paper below if you are really interested), but I include
a few remarks below:

<pre>> find_v :: (Cantor -> Bool) -> Cantor
> find_v p = \n ->  if q n (find_v(q n)) then Zero else One
>  where q n a = p(\i -> if i < n then find_v p i else if i == n then Zero else a(i-n-1))</pre>

All the above algorithms, except this one, can be easily rewritten to
use lazy lists rather than functions defined on the natural
numbers. This algorithm takes advantage of the fact that to access an
element of a sequence represented as a function, it is not necessary
to scan all the preceding elements. In a perhaps mysterious way, this
algorithm implicitly figures out which entries of its argument
<tt>p</tt> uses, and constructs only those explicitly. You can access
the other ones if you wish, but the algorithm <tt>find_v</tt> doesn't
force their evaluation. One way to see that <tt>find_v</tt> is correct
is to show, by induction on <tt>n</tt>, that <tt>find_i p n = find_v p n</tt>, which is not too difficult, although the calculations get big
at some stages if one doesn't carefully introduce suitable auxiliary
notation. A better way is to understand this directly, as done in the
above paper (you need to look for the product functional, which
generalizes this).

Now this gets really fast (take <tt>find = find_v</tt>):

<pre>*Main> equal (proj (2^300)) (proj (2^300))
True
(0.00 secs, 522148 bytes)
*Main> equal (proj (2^300)) (proj (2^400))
False
(0.00 secs, 525064 bytes)</pre>

But if the functions use several of their arguments, not just one (see
example below), this isn't so good any more. To fix this, first
rewrite the above program as follows, introducing an auxiliary
variable <tt>b</tt> to name the result, and replace one of the
recursive calls (there are two) to use <tt>b</tt> instead:

<pre>> find_vi :: (Cantor -> Bool) -> Cantor
> find_vi p = b
>  where b = \n -> if q n (find_vi(q n)) then Zero else One
>        q n a = p(\i -> if i < n then b i else if i == n then Zero else a(i-n-1))</pre>

Lazy evaluation doesn't help here, because <tt>b</tt> is a
function, and in fact this makes the program slightly slower. Now,
to make it significantly faster, we apply the identity function to
the definition of <tt>b</tt>. Or rather an elaborate
implementation of the identity function, that stores <tt>b</tt>
into an infinite binary tree in a breadth-first manner and then
retrieves it back (this trick implements memoization with
logarithmic overhead):

<pre>> find_vii :: (Cantor -> Bool) -> Cantor
> find_vii p = b
>  where b = id'(\n -> if q n (find_vii(q n)) then Zero else One)
>        q n a = p(\i -> if i < n then b i else if i == n then Zero else a(i-n-1))

> data T x = B x (T x) (T x)

> code :: (Natural -> x) -> T x
> code f = B (f 0) (code(\n -> f(2*n+1)))
>                  (code(\n -> f(2*n+2)))

> decode :: T x -> (Natural -> x)
> decode (B x l r) n |  n == 0    = x
>                    |  odd n     = decode l ((n-1) `div` 2)
>                    |  otherwise = decode r ((n-2) `div` 2)

> id' :: (Natural -> x) -> (Natural -> x)
> id' = decode.code</pre>

Now take <tt>find = find_vii</tt>, and test:

<pre>> f',g',h' :: Cantor -> Integer

> f' a = a'(10*a'(3^80)+100*a'(4^80)+1000*a'(5^80)) where a' i = coerce(a i)

> g' a = a'(10*a'(3^80)+100*a'(4^80)+1000*a'(6^80)) where a' i = coerce(a i)

> h' a = a' k
>     where i = if a'(5^80) == 0 then 0    else 1000
>           j = if a'(3^80) == 1 then 10+i else i
>           k = if a'(4^80) == 0 then j    else 100+j
>           a' i = coerce(a i)

*Main> equal f' g'
False
(6.75 secs, 814435692 bytes)

*Main> equal f' h'
True
(3.20 secs, 383266912 bytes)

*Main> equal g' h'
False
(6.79 secs, 813083216 bytes)

*Main> equal f' f'
True
(3.20 secs, 383384908 bytes)

*Main> equal g' g'
True
(3.31 secs, 400711084 bytes)

*Main> equal h' h'
True
(3.22 secs, 383274252 bytes)</pre>

Among all the above algorithms, only <tt>find_vii</tt> can cope
with the above examples. A more interesting example is this. Two
finite sequences $s$ and $t$ of natural numbers have the
same _set_ of elements iff the two functions

> $\bigwedge\_{i < |s|} \mathrm{proj}\_{s\_i}$ and $\bigwedge\_{i < |t|}
> \mathrm{proj}\_{t\_i}$

are equal, where the above notation indicates the pointwise
logical-and (conjunction) of the projections, and where $|s|$ is the
length of $s$. Here is an implementation of this
idea:

<pre>> pointwiseand :: [Natural] -> (Cantor -> Bool)
> pointwiseand [] = \b -> True
> pointwiseand (n:a) = \b -> (b n == One) && pointwiseand a b

> sameelements :: [Natural] -> [Natural] -> Bool
> sameelements a b = equal (pointwiseand a) (pointwiseand b)

*Main>  sameelements
  [6^60, 5^50, 1, 5, 6, 6, 8, 9, 3, 4, 6, 2, 4,6, 1, 6^60, 7^700, 1, 1, 1, 3, 3^30]
  [1, 2, 3, 4, 5, 6, 7, 8, 9, 3^30, 5^50, 6^60, 7^70]
False
(0.14 secs, 21716248 bytes)

*Main> sameelements
  [6^60, 5^50, 1, 5, 6, 6, 8, 9, 3, 4, 6, 2, 4,6, 1, 6^60, 7^70, 1, 1, 1, 3, 3^30]
  [1, 2, 3, 4, 5, 6, 7, 8, 9, 3^30, 5^50, 6^60, 7^70]
False
(0.10 secs, 14093520 bytes)

*Main> sameelements
  [6^60, 5^50, 1, 5, 6, 6, 8, 9, 3, 4, 6, 2, 4,6, 1, 6^60, 7^70, 1, 1, 1, 3, 3^30]
  [1, 2, 3, 4, 5, 6, 8, 9, 3^30, 5^50, 6^60, 7^70]
True
(0.10 secs, 12610056 bytes)

*Main> sameelements
 [6^60, 5^50, 1, 5, 6, 6, 8, 9, 3, 4, 6, 2, 4,6, 1, 6^60, 7^70, 1, 1, 1, 3, 3^30]
 [1, 2, 3, 4, 5, 6, 8, 9, 3^30, 5^50, 6^60, 7^700]
False
(0.12 secs, 17130684 bytes)

*Main> sameelements
[6^60, 5^50, 1, 5, 6, 6, 8, 9, 3, 4, 6, 2, 4,6, 1, 6^60, 7^700, 1, 1, 1, 3, 3^30]
[1, 2, 3, 4, 5, 6, 8, 9, 3^30, 5^50, 6^60, 7^700]
True
(0.12 secs, 17604776 bytes)</pre>

It is natural to ask whether there are applications to program
verification. I don't know, but [Dan Ghica](http://www.cs.bham.ac.uk/~drg/) and I speculate that
there are, and we are planning to investigate this.

An even faster search algorithm is offered in the first comment below.

* * *

### References with comments

  1. [Ulrich Berger](http://www.cs.swan.ac.uk/~csulrich/). **Totale Objekte und Mengen in der Bereichtheorie**. PhD thesis, Munich LMU, 1990.
  2. [M.H. Escardo](http://www.cs.bham.ac.uk/~mhe/).  **[Infinite sets that admit fast exhaustive
    search](http://www.cs.bham.ac.uk/~mhe/papers/exhaustive.pdf)**. In LICS'2007, Poland, Wroclaw, July.
    Download [companion Haskell program](http://www.cs.bham.ac.uk/~mhe/papers/exhaustive.hs).This paper investigates which kinds of infinite sets admit exhaustive
    search. It gives several algorithms for systematically building new
    searchable sets from old. It also shows that, for a rich collection of
    types, any subset that admits a quantifier also admits a searcher. The
    algorithm for constructing the searcher from the quantifier is slow,
    and so at present this result is of theoretical interest only. But the
    other algorithms are fast.
  3. M.H. Escardo.  **[Synthetic topology of data types and
    classical spaces](http://www.cs.bham.ac.uk/~mhe/papers/entcs87.pdf)**. ENTCS, Elsevier, volume 87, pages 21-156, November
    2004.I would nowadays call this algorithmic topology of program types,
    rather than synthetic topology of data types, and in future writings
    this is how I'll refer to it. It shows how notions and theorems from
    general topology can be directly mapped into programming languages (I
    use Haskell again). But it also shows how this can be mapped back to
    classical topology. Exhaustively searchable sets feature there as
    computational manifestations of compact sets.
  4. M.H. Escardo and W.K. Ho.  **[Operational domain theory
    and topology of a sequential programming language](http://www.cs.bham.ac.uk/~mhe/papers/escardo-ho-operational.pdf)**.
    In Proceedings of the 20th Annual IEEE Symposium on Logic in Computer Science (LICS), June 2005, pages 427-436.If you want to learn a bit about the use of domain theory and topology
    for reasoning about programs, this is a possible starting point.
    Rather than defining a denotational semantics using domain theory and
    topology, we extract them directly from the operational semantics of
    the language (PCF, which can be regarded as a faithful subset of
    Haskell), side-stepping denotational semantics. Many definitions of
    domain theory and denotational semantics arise as theorems here. There
    is a proof of Berger's program, including the appropriate notion of
    modulus of uniform continuity needed for the proof.
  5. [Dag Normann](http://www.math.uio.no/~dnormann/).  **[Computing with functionals - computability theory or computer science?](http://www.math.uio.no/~dnormann/Bulletin.Normann.04.pdf)** . Bulletin of Symbolic Logic, 12(1):43-59, 2006.This is a nice short history and survey of higher-type computability
    theory (the subject was established in the late 1950's by work of
    Kleene and Kreisel, but had some precursors). This theory is not well
    known among functional programmers, but it probably should be, at
    least among those with theoretical inclinations. Somebody someday
    should write an expository account to computer scientists.
  6. [Alex Simpson](http://homepages.inf.ed.ac.uk/als/). **[Lazy Functional Algorithms for Exact Real Functionals](http://homepages.inf.ed.ac.uk/als/Research/lazy.ps.gz)**. In _Mathematical Foundations of Computer Science 1998_,
    Springer LNCS 1450, pp. 456-464, 1998.One can use infinite sequences to represent real numbers exactly.
    Using the universal quantification functional, Alex Simpson developed
    an algorithm for Riemann integration. The algorithm turns out to be
    inefficient, but this is not the universal quantifier's fault: the
    Haskell profiler tells me that the integration program performs about
    10000 universal quantifications per second, 3000 of which return
    <tt>True</tt>.
