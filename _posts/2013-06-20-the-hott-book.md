---
id: 1419
title: The HoTT book
date: 2013-06-20T20:59:03+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=1419
permalink: /2013/06/20/the-hott-book/
categories:
  - Constructive math
  - General
  - Homotopy type theory
  - News
  - Publications
---
The HoTT book is finished!

Since spring, and even before that, I have participated in a great collaborative effort on writing a book on Homotopy Type Theory. It is finally finished and ready for public consumption. You can get the book freely at <http://homotopytypetheory.org/book/>. Mike Shulman has written [about the contents of the book](http://golem.ph.utexas.edu/category/2013/06/the_hott_book.html), so I am not going to repeat that here. Instead, I would like to comment on the socio-technological aspects of making the book, and in particular about what we learned from open-source community about collaborative research.

<!--more-->

We are a group of two dozen mathematicians who wrote a 600 page book in less than half a year. This is quite amazing, since mathematicians do not normally work together in large groups. In a small group they can get away with using obsolete technology, such as sending each other source LaTeX files by email, but with two dozen people even Dropbox or any other file synchronization system would have failed miserably. Luckily, many of us are computer scientists disguised as mathematicians, so we knew how to tackle the logistics. We used [git](http://git-scm.com/) and [github.com](https://github.com/). In the beginning it took some convincing and getting used to, although it was not too bad. In the end the repository served not only as an archive for our files, but also as a central hub for planning and discussions. For several months I checked github more often than email and Facbook. Github _was_ my Facebook (without the cute kittens). If you do not know about tools like git but you write scientific papers (or you create any kind of digital content) you really, really should learn about [revision control](https://en.wikipedia.org/wiki/Revision_control) systems. Even as a sole author of a paper you will profit from learning how to use one, not to mention that you can make [pretty videos](https://vimeo.com/68761218) of how you wrote your paper.

But more importantly, the spirit of collaboration that pervaded our group at the [Institute for Advanced Study](http://www.ias.edu/) was truly amazing. We did not fragment. We talked, shared ideas, [explained things](http://video.ias.edu/taxonomy/term/78) to each other, and completely forgot who did what (so much in fact that we had to put some effort into reconstruction of history lest it be forgotten forever). The result was a substantial increase in productivity. There is a lesson to be learned here (other than the fact that the Institute for Advanced Study is the world&#8217;s premier research institution), namely that mathematicians benefit from being a little less possessive about their ideas and results. I know, I know, academic careers depend on proper credit being given and so on, but really those are just the idiosyncrasies of our time. If we can get mathematicians to share half-baked ideas, not to worry who contributed what to a paper, or even who the authors are, then we will reach a new and unimagined level of productivity. Progress is made by those who dear the break rules.

Truly open research habitats cannot be obstructed by copyright, profit-grabbing publishers, patents, commercial secrets, and funding schemes that are based on faulty achievement metrics. Unfortunately we are all caught up in a system which suffers from all of these evils. But we made a small step in the right direction by making the [book source code freely available](https://github.com/HoTT/book) under a permissive Creative Commons license. Anyone can take the book and modify it, send us improvements and corrections, translate it, or even sell it without giving us any money. (If you twitched a little bit when you read that sentence then the system has gotten to you.)

We decided not to publish the book with an academic publisher at present because we wanted to make it available to everyone fast and at no cost. The book can be freely downloaded, as well as bought cheaply in [hardcover](http://www.lulu.com/shop/univalent-foundations-project/homotopy-type-theory-hardcover/hardcover/product-21076997.html) and [paperback](http://www.lulu.com/shop/univalent-foundations-project/homotopy-type-theory-paperback/paperback/product-21077021.html) versions from [lulu.com](http://lulu.com/). (When was the last time you paid under $30 for a 600 page hardcover academic monograph?) Again, I can feel some people thinking &#8220;oh but a real academic publisher bestows quality&#8221;. This sort of thinking is reminiscent of Wikipedia vs. Britannica arguments, and we all know how that story ended. Yes, good quality of research must be ensured. But once we accept the fact that anyone can publish anything on the Internet for the whole world to see, and make a cheap professionally looking book out of it, we quickly realize that censure is not effective anymore. Instead we need a decentralized system of endorsments which cannot be manipulated by special interest groups. Things are moving in this direction with the recently established [Selected Papers Network](https://selectedpapers.net/) and similar efforts. I hope these will catch on.

However, there is something else we can do. It is more radical, but also more useful. Rather than letting people only evaluate papers, why not give them a chance to participate and improve them as well? Put all your papers on github and let others discuss them, open issues, fork them, improve them, and send you corrections. Does it sound crazy? Of course it does, open source also sounded crazy when [Richard Stallman announced](https://groups.google.com/group/net.unix-wizards/msg/4dadd63a976019d7?dmode=source&hl=en) his manifesto. Let us be honest, who is going to steal your LaTeX source code? There are much more valuable things to be stolen. If you are tenured professor you can afford to lead the way. Have your grad student teach you git and put your stuff somewhere publicly. Do not be afraid, they tenured you to do such things.

So we are inviting everyone to help us improve the book by participating on github. You can leave comments, point out errors, or even better, make corrections yourself! We are not going to worry who you are, how much you are contributing, and who shall take credit. The only thing that matters is whether your contributions are any good.

My last observation is about formalization of mathematics. Mathematicians like to imagine that their papers could in principle be formalized in set theory. This gives them a feeling of security, not unlike the one experienced by a devout man entering a venerable cathedral. It is a form of faith professed by logicians. Homotopy Type Theory is an alternative foundation to set theory. We too claim that ordinary mathematics can in principle be formalized in homotopy type theory. But guess what, you do not have to take our word for it! We have formalized the hardest parts of the HoTT book and verified the proofs with computer proof assistants. Not [once](https://github.com/HoTT/HoTT) but [twice](https://github.com/HoTT/HoTT-Agda). And we formalized _first_, then we wrote the book because it was easier to formalize. We win on all counts (if there is a race).

I hope you like the book, it contains an amazing amount of new mathematics.