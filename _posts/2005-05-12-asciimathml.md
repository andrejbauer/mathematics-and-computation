---
id: 10
title: ASCIIMathML
date: 2005-05-12T14:30:35+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=10
permalink: /2005/05/12/asciimathml/
categories:
  - General
---
I have found a good way to write math in web pages. [ASCIIMathML](http://www1.chapman.edu/~jipsen/mathml/asciimath.html) is a piece of javascript that translates simple-minded Latex-like ASCII math to MathML, but only if the browser supports MathML. Since the input syntax is very simple, the expressions are quite readable in the raw form, as well.

For example, if I type 

<pre>`forall x in RR exists y in CC. (1-x^2 )/sqrt(1+y^4)=1`</pre>

it is seen as \`forall x in RR exists y in CC. (1-x^2 )/sqrt(1+y^4)=1\`. If you are going to post to the blog, you may be interested in [the ASCIIMathML syntax reference page](http://www1.chapman.edu/~jipsen/mathml/asciimathsyntax.html). 

To enable MathML on your computer, install [mathplayer](http://www.dessci.com/en/products/mathplayer/welcome.asp) plugin  
if you are using Internet Explorer. For Firefox and Mozilla, you have to install [math fonts](http://www.mozilla.org/projects/mathml/fonts/).