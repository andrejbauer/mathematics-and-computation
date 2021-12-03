---
id: 338
title: 'Constructive gem: double exponentials'
date: 2009-10-12T00:58:10+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=338
permalink: /2009/10/12/constructive-gem-double-exponentials/
categories:
  - Gems and stones
  - Programming
---
In the last constructive gem we studied the exponential $2^\mathbb{N}$ and its isomorphic copies. This time we shall compute the _double_ exponential $2^{2^\mathbb{N}}$ and even write some Haskell code.<!--more-->

By $2$ we mean the set $\lbrace 0,1\rbrace$ of the Boolean values. First note that there is a difference between $(2^2)^\mathbb{N}$ and $2^{2^\mathbb{N}}$. The former is isomorphic to the Cantor space $2^\mathbb{N}$ because $(2^2)^\mathbb{N} = 2^{2 \times \mathbb{N}} = 2^\mathbb{N}$, while the latter is the space of _functionals_, which are maps from infinite binary sequences to bits. In Haskell we would define these as

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">type Nat = Int -- notational convenience
type Natural = Integer -- notational convenience
type Cantor = Nat -> Bool
type Functional = Cantor -> Bool
</pre>

Throughout we will write $0$ and $1$ for false and true, but convert them to Boolean values `False` and `True` in Haskell code. You may download all Haskell code from this post in one chunk here: [double.hs](/wp-content/uploads/2009/10/double.hs).

What can we say about $2^{2^\mathbb{N}}$? In classical set theory the basic observation is that $2^\mathbb{N}$ has the cardinality of continuum, and that $2^{2^\mathbb{N}}$ has cardinality even greater than that, but it is undecidable from the standard axioms of set theory whether the cardinality of $2^{2^\mathbb{N}}$ is $\aleph_2$ or something larger (this is an instance of the [Generalized Continuum Hypothesis](http://en.wikipedia.org/wiki/Continuum_hypothesis#The_generalized_continuum_hypothesis)). There seems to be no consensus among set theorists about what the answer should be. Is there a consensus among constructive mathematicians?

Because constructive mathematics is “backwards compatible” with classical mathematics, we cannot be specific about $2^{2^\mathbb{N}}$ without assuming additional axioms. And this is where fun begins with constructive mathematics: assume an axiom which contradicts classical logic and see what happens (set theorists do something similar with their non-standard axioms, except that theirs are compatible with classical logic). Of course, such axioms do not just drop from the sky, they are always well motivated by some aspect of computation or geometry. I should warn you that the anti-classical axioms are the mathematical equivalent of psychoactive drugs: they take some getting used to, they are addictive and warp your sense of reality.

Before we digest the axiom let us ask what sort of functionals we are able to come up with constructively. An easy one would be “evaluate at $n$”, defined as  
$$E_n(\alpha) = \alpha(n)$$  
(We use lower-case Greek letters for infinite binary sequences and capital letters for functionals.) Or we can combine several bits of a sequence with a Boolean function, such as  
$$F(\alpha) = \alpha(0) \land (\alpha(7) \lor \lnot \alpha(13)).$$  
This particular functional has the property that there is a constant, namely $13$, such that its value depends only on the bits $0$ through $13$ of $\alpha$ (of course it only depends on bits $0$, $7$ and $13$, but we will just keep track of the highest bit on which the functional depends). In general, we say that a functional $F \in 2^{2^\mathbb{N}}$ is _uniformly continuous_, if it has a _modulus (of uniform continuity)_, which is a number $k \in \mathbb{N}$ such that $F(\alpha)$ depends only on the bits $0$ through $k$ of $\alpha$. The terminology comes from the fact that such functionals are precisely the uniformly continuous maps from the Cantor space $2^\mathbb{N}$ to the discrete space $2$. (I leave it as exercise for you to define the suitable metric on $2^\mathbb{N}$, constructively of course.)

A uniformly continuous functional may be represented by a finite amount of information as follows. Every functional $F \in 2^{2^\mathbb{N}}$ can be decomposed uniquely into two functionals $F\_0$ and $F\_1$ such that

> $F(\alpha) = F_0(\lambda n. \alpha(n+1))$ when $\alpha(0) = 0$,  
> $F(\alpha) = F_1(\lambda n. \alpha(n+1))$ when $\alpha(0) = 1$. 

The decomposition corresponds to investigating the first bit of the input $\alpha$ and making a decision based on that. In terms of exponential arithmetic, the decomposition of $F$ into $F\_0$ and $F\_1$ corresponds to the isomorphism  
$$2^{2^\mathbb{N}} = 2^{2^{1 + \mathbb{N}}} = 2^{2 \times 2^\mathbb{N}} = (2^{2^\mathbb{N}})^2 = 2^{2^\mathbb{N}} \times 2^{2^\mathbb{N}}.$$  
We may decompose $F\_0$ and $F\_1$ further into $F\_{00}$, $F\_{01}$, $F\_{10}$, and $F\_{11}$, and keep going. If $F$ is uniformly continuous with modulus $k$ then after $k$ decompositions we get constant functionals. Thus we can represent every uniformly continuous functional with an element of the inductive type

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">data UCF = Const Bool | Decompose UCF UCF
</pre>

The functional which always returns the value `b` is represented by `Const b`, whereas `Decompose x y` represents the functional whose decompositions $F\_0$ and $F\_1$ are represented by `x` and `y`, respectively. The Haskell function that converts the representation into a functional is:

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">fn :: UCF -> Functional
fn (Const b) alpha = b
fn (Decompose x y) alpha = fn (if alpha 0 then y else x) (\n -> alpha (n+1))
</pre>

Unfortunately, every functional has infinitely many representations because we may keep decomposing even if the functional is constant. For example, the functional $F(\alpha) = 0$ can be represented by `Const False`, or `Decompose (Const False) (Const False)`, and so on. This will not do for our purposes. We need a representation that represents each uniformly continuous functional uniquely. Furthermore, we want the representation expressed as an inductive type, so we cannot just take the above representation and remove some elements from it.

After a day of head scratching and a nudge in the right direction by [Sergio Cabello](http://www.fmf.uni-lj.si/~cabello/), I came up with the following representation. A uniformly continuous functional $F \in 2^{2^\mathbb{N}}$ is either constant or non-constant, and a non-constant functional $F$ has precisely one of the following forms:

  * $F(\alpha) = (\alpha(0) = b)$ for a unique $b \in \lbrace 0,1 \rbrace$, i.e., $F$ makes its decision by looking at the head of $\alpha$, or
  * $F(\alpha) = (\alpha(0) = b) \land G(\lambda n. \alpha(n+1))$ for a unique $b \in \lbrace 0,1 \rbrace$ and a unique non-constant $G$, or
  * $F(\alpha) = (\alpha(0) = b) \lor G(\lambda n. \alpha(n+1))$ for a unique $b \in \lbrace 0,1 \rbrace$ and a unique non-constant $G$, or
  * $F(\alpha)$ decomposes uniquely into non-constant functionals $F\_0$ and $F\_1$, as above.

This leads to the following two-stage definition in Haskell:

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">-- representation of non-constant functionals
data UCF' = Head Bool
          | And Bool UCF'
          | Or Bool UCF'
          | Decompose UCF' UCF'
            deriving (Eq, Show)

-- representation of arbitrary functionals
data UCF = Const Bool
         | Nonconst UCF'
           deriving (Eq, Show)
</pre>

Here are the maps that convert representations to functionals:

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">-- convert a non-constant representation to the functional
fn' :: UCF' -> Functional
fn' f \alpha = compute 0 f
    where compute k (Head b) = (\alpha k == b)
          compute k (And b x) = (\alpha k == b) &amp;&amp; (compute (k+1) x)
          compute k (Or b x) = (\alpha k == b) || (compute (k+1) x)
          compute k (Decompose x y) = (\alpha k == False &amp;&amp; compute (k+1) x) ||
                                      (\alpha k == True &amp;&amp; compute (k+1) y)

-- convert a representation to the functional
fn :: UCF -> Functional
fn (Const b) = const b
fn (Nonconst x) = fn' x
</pre>

So much about uniformly continuous functionals. What about the non-uniformly continuous ones? Here is one:

> $F(\alpha) = 1$ when $\forall n \in \mathbb{N}, \alpha(n) = 0$,  
> $F(\alpha) = 0$ otherwise.

Unfortunately, this is not a constructively valid definition because it presupposes that every $\alpha \in 2^\mathbb{N}$ is equal to the zero sequence or not. Here is another attempt:

> $F(\alpha) = 0$ if the least $n \in \mathbb{N}$ for which $\alpha(n) = 1$ is even,  
> $F(\alpha) = 1$ if the least $n \in \mathbb{N}$ for which $\alpha(n) = 1$ is odd.

This is a constructive definition (you can easily translate it into Haskell), the functional is not uniformly continuous, but unfortunately it is not _total_ either because its value is undefined when $\alpha$ is the zero sequence. Try as hard as you may, you will not be able to define constructively a functional which is not uniformly continuous. If you can't beat them, join them:

> **Axiom:** _All functionals $2^\mathbb{N} \to 2$ are uniformly continuous._

I am going to convince you that the axiom is true, or more precisely that it _could_ be true, by writing in Haskell the inverse of `fn :: UCF -> Functional`, thus witnessing the fact that in the Haskell world _every_ functional has a `UCF` representation and so is uniformly continuous. But first let me just mention that books on constructive mathematics never phrase the axiom in the above form. In Brouwerian intuitionism our axiom is actually a theorem which follows from two more basic principles (I am misrepresenting them a bit, I hope the experts won't mind):

> **Continuity principle:** [_All maps are continuous._](/2006/03/27/sometimes-all-functions-are-continuous/)
> 
> **Fan Principle:** _The Cantor space is compact._

It's not too hard to derive our axiom from these two (compactness here is meant in the sense of Heine-Borel: every cover of the Cantor space by open balls has a finite subcover). If you want to know more about this topic, see:

> D. Bridges, H. Ishihara, and P. Schuster: _Compactness and continuity, constructively revisited_ in: _Computer Science Logic_ (J. Bradfield, ed; Proceedings of 16th International Workshop CSL 2002, 11th Annual Conference of the EACSL, Edinburgh, Scotland, September 22-25), Lecture Notes in Computer Science 2471, 89-102, Springer-Verlag, Berlin and Heidelberg, 2002.

There is an evil Springer [link](http://www.springerlink.com/content/nck0v2atr5auxjve/) to the paper that wants to sell it to you for 25 USD, and unfortunately none of the authors published it on the web.

To define the inverse of `fn` I will use [seemingly impossible functionals](/2007/09/28/seemingly-impossible-functional-programs/) by [Martin Escardo](http://www.cs.bham.ac.uk/~mhe/). Here's a fairly fast version of his quantifiers:

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">-- Martin Escardo's find, forevery and forsome functionals
find :: Functional -> Cantor
find p = branch x l r
    where branch x l r n |  n == 0    = x
                         |  odd n     = l ((n-1) $div$ 2)
                         |  otherwise = r ((n-2) $div$ 2)
          x = forsome (\l -> forsome (\r -> p (branch True l r)))
          l = find (\l -> forsome (\r -> p(branch x l r)))
          r = find (\r -> p (branch x l r))

forevery, forsome :: Functional -> Bool
forsome f = f (find f)
forevery f = not (forsome (not . f))
</pre>

You don't have to understand this (although you really should, read [the post](/2007/09/28/seemingly-impossible-functional-programs/)), just remember that `forevery f` is `True` precisely when `f` always returns `True`. This allows us to detect whether a functional $f$ is constant by checking whether $f(\alpha) = f(\lambda n. 0)$ for all $\alpha \in 2^\mathbb{N}$. Here's the function we need:

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">-- get_const f returns Just b if f is constantly b, and Nothing otherwise
get_const :: (Functional) -> Maybe Bool
get_const f =
    let b = f (const False) in
    if forevery (\\alpha -> f \alpha == b) then Just b else Nothing
</pre>

And here is the inverse of `fn`, there is no point in explaining the code, just stare at it for a while:

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">-- in order to define the inverse of fn we need an auxiliary function shift
prepend :: Bool -> (Nat -> Bool) -> (Nat -> Bool)
prepend b \alpha 0 = b
prepend b \alpha (n+1) = \alpha n

shift :: Bool -> (Functional) -> Functional
shift b f = f . (prepend b)

-- the inverse of fn' computes the representation of a non-constant functional
unfn' :: Functional -> UCF'
unfn' f = case (get_const (shift False f), get_const (shift True f)) of
            (Just True, Just False) -> Head False
            (Just False, Just True) -> Head True
            (Just False, Nothing) -> And True (unfn' (shift True f))
            (Nothing, Just False) -> And False (unfn' (shift False f))
            (Just True, Nothing) -> Or False (unfn' (shift True f))
            (Nothing, Just True) -> Or True (unfn' (shift False f))
            (Nothing, Nothing) -> Decompose (unfn' (shift False f)) (unfn' (shift True f))

-- finally, the inverse of fn computes the representation of a functional
unfn :: Functional -> UCF
unfn f = case get_const f of
           Just b -> Const b
           Nothing -> Nonconst (unfn' f)
</pre>

Let's try it out:

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">> let f \alpha = \alpha 0 || \alpha 2
> unfn f
Nonconst (Or True (Decompose (Head True) (Head True)))
> let g = fn (unfn f)
> forevery (\\alpha -> f \alpha == g \alpha)
True
</pre>

In a sense we computed the double exponential $2^{2^\mathbb{N}}$ to be isomorphic to the inductive datatype `UCF`. But this is ugly and we can do better, namely  
$$2^{2^\mathbb{N}} = \mathbb{N}.$$  
If you think this is weird, remember that you just took in an anti-classical axiom. To establish the equality we have to show that $\mathbb{N}$ is isomorphic to `UCF`. This is not complicated as `UCF` is an inductive type: the low bits of a number are used as tags for alternatives and the high bits for the data:

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">-- encode a pair of numbers by interleaving their bits
pair :: Natural -> Natural -> Natural
pair 0 0 = 0
pair m n = let (mq, mr) = divMod m 2
               (nq, nr) = divMod n 2
           in mr + 2 * nr + 4 * pair mq nq

-- decode a pair of numbers
unpair :: Natural -> (Natural, Natural)
unpair 0 = (0, 0)
unpair n = let (p,xr) = divMod n 2
               (q,yr) = divMod p 2
               (x,y) = unpair q
           in (xr + 2*x, yr + 2*y)

-- enumeration of all elments of UCF' without repetitions
enum' :: Natural -> UCF'
enum' 0 = Head False
enum' 1 = Head True
enum' (n+2) = case n $mod$ 5 of
                 0 -> And False (enum' (n $div$ 5))
                 1 -> And True (enum' (n $div$ 5))
                 2 -> Or False (enum' (n $div$ 5))
                 3 -> Or True (enum' (n $div$ 5))
                 4 -> Decompose (enum' n0) (enum' n1) where (n0, n1) = unpair (n $div$ 5)

-- the inverse of enum' computes the index of a given representation
denum' :: UCF' -> Natural
denum' (Head False) = 0
denum' (Head True) = 1
denum' (And False x) = 2 + 5 * denum' x
denum' (And True x) = 3 + 5 * denum' x
denum' (Or False x) = 4 + 5 * denum' x
denum' (Or True x) = 5 + 5 * denum' x
denum' (Decompose x y) = 6 + 5 * pair (denum' x) (denum' y)

-- enumeration of all elements of UCF without repetitions
enum :: Natural -> UCF
enum 0 = Const False
enum 1 = Const True
enum (n+2) = Nonconst (enum' n)

-- the inverse of enum computes the index of a given representation
denum :: UCF -> Natural
denum (Const False) = 0
denum (Const True) = 1
denum (Nonconst x) = 2 + denum' x
</pre>

The isomorphisms between $2^{2^\mathbb{N}}$ and $\mathbb{N}$ are `denum.unfn` and `fn.enum`. They work faster than I expected. For example, computing the code of the functional $F(\alpha) = \alpha(0) \land (\alpha(7) \lor \lnot \alpha(13))$ from above takes two seconds on my old Thinkpad X41 tablet with GHCi 6.8.2:

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">> denum (unfn (\alpha -> alpha 0 && (\alpha 7 || not (alpha 13))))
87817326431460771517190893150548229499215350322029536332330582392\
18806567712528926647782037625464558715616413319854776533154457748\
50369951148002019452847630950654803575772277566553803846025187184\
34444574497140925493969286388704593318292908330044401516114387588\
41129568723129083535935666107640185745007715819259946270361339845\
63266376803845196832828240730548739044529176512107067406391527837\
57557358360782528688863949682777531085194899507204378035121581634\
24414088402731389247357737928169297087400188551068409902167210976\
99668535678352198115657924571726602015561676282558489121953241400\
31207429948640258928848640629219636659534812792822670096916525074\
92689877547982499255923044560155940630587612552147776483441652816\
33236765741973747177767093758966792753915098622478083341278699474\
61724291491874192863031534896067586188321251023323955047888297199\
99217044991519287327160933912040296276276242348097165496172742690\
86466569441720773638821952373188913643662294845373908383902122732\
57690268796744633096769122526030738819573331098032907140498720008\
13035742950851348313598383399074414967055732327291982453954045810\
80842325049649761748796838786086458738890864373475302175875704290\
69913688074348037854515150494366271992924434038972072364623933515\
35108523881948862331674561312861919905943354459088929891444774041\
37877258586791658859754564125677939626809742619915779730287028484\
60639819192296728586447064779019114742341835006766442016072934648\
63875973516361673678057437839898835537149537164515633053161142888\
18005648558646358710551291222742512100699868862843079002494001711\
30529624644030648543655285826939709869391484019919363825896807557\
03355972387881865951424806790745995688760042329946947624109661700\
82452571386658548081130928574260460399814489165244566557234765399\
2658988664393075487299560192769248990004510
(1.95 secs, 79012892 bytes)
</pre>

That's 1798 digits if I am counting correctly. And here is the verification that `(denum.unfn).(fn.enum)` is the identity for all numbers up to 10000:

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">> map (denum . unfn . fn . enum) [0..10000] == [0..10000]
True
(24.31 secs, 1392197128 bytes)</pre>
</pre>

The enumeration of functionals is also handy for trying out Martin's functionals “randomly”:

<pre class="brush: plain; gutter: false; title: ; notranslate" title="">> forevery (fn (enum 109809128310938019831032110823012831203922))
False
(0.17 secs, 4694172 bytes)
> map (find (fn (enum 100000000000))) [0..15]
[True,True,True,True,True,True,True,True,True,True,False,True,True,True,True,True]
(1.08 secs, 41505604 bytes)
</pre>

Even though this is slightly impressive and fun, the datatype `UCF` could be improved to give an even better representation of functionals. For example, the representation of the functional $E_n(\alpha) = \alpha(n)$ is prohibitively large, around $\Theta(2^n)$. We should look for a datatype which allows direct access to the $n$-th bit of $\alpha$, so to speak. But not today, this post is long enough.
