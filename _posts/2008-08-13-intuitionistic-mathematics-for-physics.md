---
id: 89
title: Intuitionistic mathematics for physics
date: 2008-08-13T09:35:29+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/2008/08/13/intuitionistic-mathematics-for-physics/
permalink: /2008/08/13/intuitionistic-mathematics-for-physics/
categories:
  - Constructive math
  - Tutorial
---
At [MSFP 2008](http://msfp.org.uk/) in Iceland I chatted with [Dan Piponi](http://homepage.mac.com/sigfpe/) about physics and intuitionistic mathematics, and he encouraged me to write down some of the ideas. I have little, if anything, original to say, so this seems like an excellent opportunity for a blog post. So let me explain why I think _intuitionistic mathematics is good for physics_.  
<!--more-->

Intuitionistic mathematics, whose main proponent was [L.E.J. Brouwer](http://en.wikipedia.org/wiki/L._E._J._Brouwer), is largely misunderstood by mathematicians. Consequently, physicists have strange ideas about it, too. For example, [David Deutsch](http://www.qubit.org/people/david/) somehow managed to write in his otherwise excellent popular science book [&#8220;The Fabric of Reality&#8221;](http://www.qubit.org/people/david/index.php?path=The%20Fabric%20of%20Reality) that intuitionists deny existence of infinitely many natural numbers (those would be the [ultrafinitists](http://en.wikipedia.org/wiki/Ultrafinitism), if there are any). He also produced rather silly arguments against intuitionistic mathematics, which I explained to myself by believing that he never had a chance to learn that intuitionistic mathematics _supports_ his point of view. 

While Brouwer&#8217;s and other [preintuitionists&#8217;](http://en.wikipedia.org/wiki/Preintuitionism) reasons for intuitionistic mathematics were [philosophical in nature](http://plato.stanford.edu/entries/intuitionistic-logic-development/), there is today a vibrant community of mathematicians, logicians, computer scientists, and even the [odd physicist](http://arxiv.org/abs/quant-ph/0703060), who work with intuitionistic mathematics not because of their philosophical conviction but because it is simply the right kind of math for what they are doing. 

### Intuitionistic understanding of truth

A common obstacle in understanding intuitionistic logic is the opinion that the difference between classical and intuitionistic logic arises because classicists and intuitionists just happen to disagree about what is true. A typical example of this is the principle known as [Proof by Contradiction](http://en.wikipedia.org/wiki/Reductio_ad_absurdum):

> _For every proposition $\phi$, if $\phi$ is not false then $\phi$ is true._ 

With a formula we write this as

> $\forall \phi \in \mathsf{Prop}, \lnot \lnot \phi \Rightarrow \phi$. 

Classical mathematicians accept it as true. Intuitionists do not accept it, but neither do they claim it is false. In fact, they claim that the principle has no counterexamples, that is

> $\lnot \exists \phi \in \mathsf{Prop},  
> \lnot (\lnot \lnot \phi \Rightarrow \phi)$. 

This becomes very confusing for classical mathematicians who think that the two displayed formulae are equivalent, because they believe in Proof by Contradiction. It is like believing that the Earth is flat while trying to make sense of Kepler&#8217;s Laws of planetary motion.

The difference between intuitionistic and classical logic is in the _criteria_ for truth, i.e., what evidence must be provided before a statement is accepted as true. Speaking vaguely, intuitionistic logic demands _positive evidence_, while classical logic is happy with _lack of negative evidence_. The intuitionist view is closer to the criterion of truth in science, where we normally confirm a statement with an experiment (positive evidence), but this analogy should not be taken too far. 

What counts as &#8220;evidence&#8221; is open to interpretation. Before I describe the three most common ones below, let me just explain the difference between $\phi$ (&#8220;$\phi$ is true&#8221;) and $\lnot \lnot \phi$ (&#8220;$\phi$ is not false&#8221;). Intuitionistically:

  * $\phi$ holds if there is positive evidence supporting it,
  * $\lnot \phi$ holds if it is contradictory to assume $\phi$, that is to say, evidence of $\phi$ would entail a contradiction.
  * $\lnot \lnot \phi$ holds if it is contradictory to assume that it is contradictory to assume $\phi$.

That is a bit complicated. In essence, it says that $\lnot \lnot \phi$ is accepted when there is no evidence against it. In other words, $\lnot \lnot \phi$ means something like &#8220;$\phi$ cannot be falsified&#8221; or &#8220;$\phi$ is _potentially_ true&#8221;. For example, if someone says

> &#8220;There is a particle which does not interact with anything in the universe.&#8221; 

that would be a statement which is not accepted as true, for how would you ever present positive evidence? But it is accepted as potentially true, for how would you ever falsify it? 

A statement which is logically equivalent to one of the form $\lnot \lnot \phi$ is called _doubly negated_. For the purposes of this post I shall call a statement $\phi$ _potentially true_ if its double negation $\lnot \lnot \phi$ is true. It seems nontrivial to come up with useful statement in physics which are only potentially true (but see the discussion about infinitesimals below). Perhaps [Karl Popper](http://en.wikipedia.org/wiki/Karl_Popper) would have something to say about that. 

Let me now describe three most common interpretations of &#8220;evidence&#8221; in intuitionistic logic.

#### Computational interpretation

This is the interpretation of intuitionistic logic commonly presented in computer science. We view all sets as represented by suitable data structures&mdash;a reasonable point of view for a computer scientist. Then a statement is taken to be true if there exists a program (computational evidence) witnessing its truth. To demonstrate the idea, consider the statement

> $\forall x \in A, \exists y \in B, \phi(x, y)$. 

This is taken to be true if there exists a program which accepts $x$ and outputs $y$ together with computational evidence that $\phi(x,y)$ holds. Another example: the statement

> $\forall x \in A, \phi(x) \lor \psi(x)$ 

is true if there exists a program which takes $x$ as input and outputs either $0$ and evidence of $\phi(x)$, or $1$ and evidence of $\psi(x)$. In other words, the program is [a decision procedure](http://en.wikipedia.org/wiki/Decision_procedure) which tells us which of the two disjuncts holds, and why. Under this interpretation the [Law of Excluded Middle](http://en.wikipedia.org/wiki/Law_of_excluded_middle) fails because there are unsolvable decision problems, such as the [Halting problem](http://en.wikipedia.org/wiki/Halting_problem).

The computationally minded readers might entertain themselves by figuring out a computational explanation of potentially true statements (Hint: first interpret Pierce&#8217;s Law in terms of continuations). I have not done it myself.

#### Topological interpretation

We may replace the phrases &#8220;data structure&#8221; and &#8220;program&#8221; in the computational interpretation by &#8220;topological space&#8221; and &#8220;continuous function&#8221;, respectively. Thus a statement is true if it is witnessed by a continuous function which transforms input (hypotheses) to output (conclusions). 

The basis for this explanation may be found in physics if we think about what it means for a function to be continuous in terms of communication or information processing. Suppose an observer wants to communicate a real-valued quantity $x$ to another observer. They can do it in many ways: by making sounds, by sending electromagnetic signals, by sending particles from one place to another, by manufacturing and sending a stick of length $x$ by mail, etc. However, as long as they use up only a finite amount of resources (time, space, energy) they will be able to communicate only a finite amount of information about $x$. Similarly, in any physical process (computer, brain, abacus) which transforms an input value $x$ to an output value $f(x)$ the rate of information flow is finite. Consequently, in finite time the process will obtain only a finite amount of information about $x$, on the basis of which it will output a finite amount of information about $f(x)$. This is just the definition of continuity of $f$ phrased in terms of information flow rather than $\epsilon$ and $\delta$. Notice that we are _not_ assuming that $f$ is computable because we do not want to make the rather sweeping assumption that all physical processes are computable. 

The conclusion is that _&#8220;all functions are continuous&#8221;_, including those that witness truth of statements.

You might be thinking that an [analog-to-digital converter](http://en.wikipedia.org/wiki/Analog-to-digital_converter) is a counterexample to the above argument. It is a device which takes as input an electric signal and outputs either 0 or 1, depending on whether the voltage of the signal is below or above a given threshold. Indeed, this would be a discontinuous function, if only such converters worked _exactly_. But they do not, they always have a tolerance level, and the manufacturer makes no guarantees about it working correctly very close to the threshold value. 

A useful exercise is to think about the difference between &#8220;all functions are continuous&#8221;, &#8220;potentially all functions are continuous&#8221;, and &#8220;all functions are potentially continuous&#8221;. Which one does the above argument about finite rate of information processing support?

#### Local truth

This explanation of intuitionistic logic is a bit more subtle, but also much more powerful and versatile. It is known by categorical logicians as the _Kripke-Joyal_ or _sheaf semantics_, while most logicians are familiar at least with the older [Kripke semantics](http://en.wikipedia.org/wiki/Kripke_semantics).

Imagine a planet and a meteorologist at each point of the surface, measuring the local temperature $T$. We assume that $T$ varies continuously with position. A statement such as $T > 273$ is true at some points of the planet and false at others. We say that it is _locally true_ at $x$ if there exists a small neighborhood around $x$ where it is true. In other words, a statement is locally, or stably true at a given point if it remains true when we perturb the point a little. 

On this planet a statement is _globally true_ if it is locally true everywhere, and it is _globally false_ if its negation is locally true everywhere. There are also many intermediate levels of truth. The _truth value_ (a measure of truth) of a statement is the set of those points at which the statement is locally true. Such a set is always [open](http://en.wikipedia.org/wiki/Open_set). 

The explanation so far is a bit wrong. For a statement to be locally true at $x$, not only must it be true in a neighborhood of $x$, but it must also be true everywhere in the neighborhood &#8220;for the same reason&#8221;. For example, the statement

> $T > 273$ or $T \leq 273$ 

is true at $x$ if there exists a neighborhood $U$ of $x$ such that $T > 273$ everywhere on $U$, or $T \leq 273$ everywhere on $U$. The reason, namely which of the two possibilities holds, must be the same everywhere on $U$. 

The truth value of $T = 273$ is the _interior_ of the set of those points at which $T$ equals 273, while the truth value of $T \neq 273$ is the _exterior_ of the set of those points at which $T$ equals 273. Thus the truth value of the disjunction

> $T = 273$ or $T \neq 273$ 

need not be the entire planet&mdash;it will miss isolated points at which $T$ is 273. The Law of Excluded Middle is _not_ valid.

By changing the underlying space and topology, we can express various notions of truth. We can, for example, incorporate passage of time, or a universe branching into possible worlds. In the most general case the underlying space need not even be a space, but a [category](http://en.wikipedia.org/wiki/Category_(mathematics)) with a so-called [Grothendieck topology](http://en.wikipedia.org/wiki/Grothendieck_topology) which determines what &#8220;locally&#8221; means.

Apart from being a wonderful mathematical tool, it should be possible to use sheaf semantics to clarify concepts in physics. I would expect the notions of &#8220;truth stable under small perturbation&#8221; and &#8220;truth local to an observer&#8221; to appeal to physicists. Fancy kinds of sheaf semantics have been proposed to explain features of quantum mechanics, see for example [this paper](http://arxiv.org/abs/0709.4364) by [Bas Spitters](http://www.cs.ru.nl/~spitters/) and his coworkers.

### Smooth infinitesimal analysis

Philosophical explanations and entertaining stories about intuitionistic mathematics are one thing, but getting actual benefits out of it are another. For physicists this means that they will want to calculate things with it. The good news is that they are already doing it, they just don&#8217;t know it! 

There is something odd about how physicists are taught mathematics&mdash;at least in my department. Physics majors learn the differential and integral calculus in the style of Cauchy and Weierstrass, with $\epsilon$&ndash;$delta$ definitions of continuity and differentiability. They are told by math professors that it is a sin to differentiate a non-differentiable function. They might even be told that the original differential and integral calculus, as invented by Leibniz and Newton, was flawed because it used the unclear concept of [infinitesimals](http://en.wikipedia.org/wiki/Infinitesimal), which were supposed to be infinitely small yet positive quantities.

Then these same students go to a physics class in which a physics professor _never_ performs $\epsilon$&ndash;$\delta$ calculations, freely differentiates everything in sight, and tops it off by using the outlawed infinitesimals to calculate lots of cool things. What are the students supposed to think? Clearly, the &#8220;correct&#8221; mathematics is useless to them. It&#8217;s a waste of time. Why aren&#8217;t they taught mathematics that gives a foundation to what the physics professors are actually doing? Is there such math?

Yes there is. It&#8217;s the mathematics of infinitesimal calculus, brought forward to the 20th century by [Anders Kock](http://home.imf.au.dk/kock/) and [Bill Lawvere](http://www.acsu.buffalo.edu/~wlawvere/) under the name [Synthetic Differential Geometry](http://en.wikipedia.org/wiki/Synthetic_differential_geometry) (SDG), or Smooth Infinitesimal Analysis. (I am too young to know exactly who invented what, but I&#8217;ve heard people say that [Eduardo Dubuc](http://www.genealogy.math.ndsu.nodak.edu/id.php?id=6615) also played a part. I would be happy to correct bibliographical omissions on my part.) By the way, I am _not_ talking about [Robinson&#8217;s non-standard analysis](http://en.wikipedia.org/wiki/Non-standard_analysis), which uses classical logic.

This is not the place to properly introduce synthetic differential geometry. I will limit myself to a few basic ideas and results. For a first reading I highly recommend [John Bell&#8217;s](http://publish.uwo.ca/~jbell/) booklet [A Primer of Infinitesimal Analysis](http://books.google.si/books?id=fk1UY6qm8mYC&dq=john+bell+infinitesimal+analysis&pg=PP1&ots=OeqA0XeU95&sig=CXMDUZKBdjXfNneJDN5I4pBiQdQ&hl=en&sa=X&oi=book_result&resnum=1&ct=result). If you refuse to read physical books, you may try his shorter [An Invitation to Smooth Infinitesimal Analysis](http://publish.uwo.ca/~jbell/invitation%20to%20SIA.pdf) online. For further reading Anders Kock&#8217;s [Synthetic differential geometry](http://www.cambridge.org/uk/catalogue/catalogue.asp?isbn=9780521687386) is an obvious choice (available [online](http://home.imf.au.dk/kock/sdg99.pdf)!), and there is also Moerdijk and Reyes&#8217;s [Models of smooth infinitesimals analysis](http://books.google.com/books?id=31QyAAAACAAJ&dq=models+of+smooth+infinitesimal+analysis&ei=ydahSJOyCISasgO9kpWeBQ), which shows in detail how to construct models of SDG using sheaves of germs of smooth functions.

To get a feeling for what is going on, and why intuitionistic logic is needed, let us review the usual proof that infinitesimals do not exist. This requires a bit of logical nitpicking, so bare with me. Both intuitionistic and classical mathematics agree that there is no real number $x$ which is neither negative, nor zero, nor positive:

> $\lnot \exists x \in \mathbb{R}, \lnot (x < 0) \land \lnot (x = 0) \land \lnot (x > 0)$. 

(There is some disagreement as to whether every number is either negative, zero, or positive, but that is beside the point right now.) A _nilpotent infinitesimal of second degree_, or just _infinitesimal_ for short, is a real number $dx$ whose square is zero. Any such $dx$ is neither negative nor positive, because both $dx > 0$ and $dx < 0$ imply $dx^2 > 0$, which contradicts $dx^2 = 0$. If $dx$ were also non-zero, we would have a number which is neither negative, zero, nor positive. Thus we proved that an infinitesimal cannot be non-zero:

> $dx^2 = 0 \Rightarrow \lnot \lnot (dx = 0)$. 

A classical mathematician will now conclude that $dx = 0$ by applying Proof by Contradiction. Intuitionistically we have only shown that _infinitesimals are **potentially** equal to zero._

But are there any infinitesimals which are _actually_ different from zero? It can be shown from the main axiom of SDG (see below) that non-zero infinitesimals potentially exist. It is a confusing world: on one hand all infinitesimals are potentially zero, but on the other non-zero ones potentially exist. Like all good things in life, intuitionistic mathematics is an acquired taste (and addictive). 

Can a physicist make sense of all this? We may think of infinitesimals as quantities so small that they cannot be experimentally distinguished from zero (they are potentially zero), but neither can they be shown to all equal zero (potentially there are some non-zero ones). By the way, we are not talking about lengths below [Planck length](http://en.wikipedia.org/wiki/Planck_length), as there are clearly reals numbers smaller than $1.6 * 10^(-35)$ whose square is positive.

The actual axiom which gets the infinitesimal calculus going does not explicitly state anything about non-zero infinitesimals. Instead, it expresses the principle of _micro-affinity_ (sometimes called micro-linearity) that physicists use in their calculations.

> **Principle of micro-affinity:** An infinitesimal change in the independent variable $x$ causes an affine (linear) change in the dependent variable $y = f(x)$. 

More precisely, if $f : R \to R$ is _any_ function, $x \in R$ and $dx$ is an infinitesimal, then there exists a unique number $f'(x)$, called _the derivative of $f$ at $x$_, such that $f(x + dx) = f(x) + f'(x) dx$. This principle has many consequences, such as potential existence of non-zero infinitesimals described above. For actual calculations the most important consequence is

> **Law of cancellation:** If $a$ and $b$ are real numbers such that $a \cdot dx$ = $b \cdot dx$ for all infinitesimals $dx$ then $a = b$. 

What this says is that we may cancel infinitesimals when they are _arbitrary_. This is important because infinitesimals do not have inverses (they are potentially zero). Nevertheless, we may cancel them in an equation, as long as they are arbitrary. 

Let me show how this works in practice by calculating the derivative of $f(x) = x^2$. For _arbitrary_ infinitesimal $dx$ we have

> $f'(x) \cdot dx = f(x + dx) &#8211; f(x) = (x + dx)^2 &#8211; x^2 = x^2 + 2 x \cdot dx + dx^2 &#8211; x^2 = 2 x \cdot dx$ 

where we used the fact that $dx^2 = 0$. Because $dx$ is arbitrary, we may cancel it on both sides and get $f'(x) = 2 x$. I emphasize that this is a _mathematically precise_ and _logically correct_ calculation. It is in fact very close to the [usual treatment](http://en.wikipedia.org/wiki/Infinitesimal#History_of_the_infinitesimal) which goes like this:

> $f'(x) = (f(x+dx) &#8211; f(x))/dx = (x^2 + 2 x \cdot dx &#8211; dx^2 &#8211; x^2)/dx = 2 x + dx = 2 x$ 

There are two incorrect steps here: we divided by an infinitesimal $dx$ without knowing that it is different from zero (it isn&#8217;t!), and we pretended that $2 x + dx$ is equal to $2 x$ because &#8220;$dx$ is very small&#8221;. By the same reasoning we should have concluded that $f(x+dx) &#8211; f(x) = f(x) &#8211; f(x) = 0$, but we did not. Why? 

The principle of micro-affinity allows us to easily derive the usual rules for computing derivatives, the potential existence of non-zero infinitesimals, prove the [fundamental theorem of calculus](http://en.wikipedia.or/wiki/Fundamental_theorem_of_calculus#Second_part) in two lines, derive the wave equation like physicists do it, etc. And it is all correct, exact math. No approximations, no guilty feeling about throwing away &#8220;negligible terms&#8221; here but not there, and other hocus-pocus that physicists have to resort to because nobody told them about this stuff.

Just for fun, let me compute more derivatives. The general strategy in computing $f'(x)$ is to consider an arbitrary infinitesimal $dx$ and express $f'(x) \cdot dx = f(x + dx) &#8211; f(x)$ as a quantity multiplied by $dx$. Then we cancel $dx$ on both sides and get $f'(x)$. Throughout we use the fact that $dx^2 = 0$. Here we go:

  * The derivative of $x^n$ is $n \cdot x^(n-1)$:  
    > $(x+dx)^n &#8211; x^n = x^n + n x^(n-1) \cdot dx &#8211; x^n = n x^(n-1) \cdot dx$ 

  * Leibniz&#8217;s formula for derivatives of products $(f(x)\cdot g(x))&#8217; = f'(x) \cdot g(x) + f(x) \cdot g'(x)$:  
    > $f(x+dx) \cdot g(x+dx) &#8211; f(x) \cdot g(x) = $  
    > $(f(x) + f'(x) \cdot dx) (g(x) + g'(x) \cdot dx) &#8211; f(x) \cdot g(x) =$  
    > $(f'(x) g(x) + f(x) \cdot g'(x)) \cdot dx$. 

  * Chain rule $f(g(x))&#8217; = f'(g(x)) \cdot g'(x)$  
    > $f(g(x+dx)) &#8211; f(g(x)) =$  
    > $f(g(x) + g'(x) \cdot dx) &#8211; f(g(x)) =$  
    > $f(g(x)) + f'(g(x)) \cdot g'(x) \cdot dx &#8211; f(g(x)) =$  
    > $f'(g(x)) \cdot g'(x) \cdot dx$ 
    
    where we used the fact that $g'(x) \cdot dx$ is infinitesimal because its square is zero. </li> </ul> 
    
    There you have it, in a paragraph we derived precisely and in sufficient detail what usually takes a whole lecture of $\epsilon$&ndash;$\delta$ manipulations. 
    
    If we stick to classical logic, the Principle of micro-affinity is false. To see this, consider a function with a jump, such as
    
    > $j(x) = 0$ &nbsp;&nbsp; if $x < 0$  
    > $j(x) = 1$ &nbsp;&nbsp; if $x \geq 0$ 
    
    At $x = 0$ the principle of micro-affinity fails. This is a counterexample only in classical mathematics because intuitionistically we cannot prove that there is a function with a jump. Concretely, the above definition of $j(x)$ is not intuitionistically valid because it presupposes $\forall x \in R, x < 0 \lor x \geq 0$.
    
    #### Space-time anomalies
    
    But wait! Intuitionistically we _can_ construct non-differentiable continuous functions, such as the absolute value $f(x) = |x|$, for which the principle of micro-affinity fails, too. Well, I am not telling the whole story. The smooth real line $R$ of infinitesimal analysis is not the [usual real line](http://en.wikipedia.org/wiki/Real_line) $\mathbb{R}$, as constructed by [Richard Dedekind](http://en.wikipedia.org/wiki/Richard_Dedekind). It does not support computation of absolute values.
    
    This seems pretty bad. If we cannot have a function such as the absolute value, then it is not clear how to model phenomena that involve sudden change of direction, such as reflection of light and collision of particles. Can rays not bounce of mirrors, intuitionistically? Yes they can, it is just that the intuitionistic treatment of sudden changes is more profound than the classical one. 
    
    Consider a particle which moves freely up to time $t_0$, then bounces off a wall, and moves freely after that. Its position $p$ is described as a function of time $t$ in two parts,
    
    > $p(t) = p\_1(t)$ &nbsp;&nbsp; if $t \leq t\_0$  
    > $p(t) = p\_2(t)$ &nbsp;&nbsp; if $t \geq t\_0$ 
    
    where $p\_1$ and $p\_2$ are smooth functions, and $p\_1(t\_0) = p\_2(t\_0)$. Because $p$ is defined separately for $t \leq t\_0$ and for $t \geq t\_0$, its domain of definition is the union of two half-lines
    
    > $D = \lbrace t \in R \mid t \leq t_0 \rbrace \cup  
    > \lbrace t \in R \mid t \geq t_0 \rbrace$. 
    
    Classical mathematics proves that $D = R$, which amounts to forgetting that $t_0$ is a special moment. In the smooth world, $D$ is only a subset of $R$, but is _not_ equal to $R$ because it carries more information than $R$. As strange as this may seem, it is useful because it encodes moments in time or places in space where special things happen, such as sudden change of movement or sudden change of density. Smooth space-time, say $R^4$, allows only smooth motion and smooth distribution of mass. If we place non-smooth mass in it, the space will change to a subset of $R^4$ which carries additional information about the anomalies contained in it.
    
    This post has become very long so I will stop here.
