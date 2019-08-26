---
id: 1777
title: 'TEDx &#8220;Zeroes&#8221;'
date: 2014-10-16T09:01:03+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=1777
permalink: /2014/10/16/tedx-zeroes/
categories:
  - Programming
  - Software
  - Talks
---
I spoke at [TEDx University of Ljubljana](http://tedxul.si). The topic was how programming influences various aspects of life. I showed the audence how a bit of simple programming can reveal the beauty of mathematics. Taking John Baez&#8217;s [The Bauty of Roots](http://www.math.ucr.edu/home/baez/roots/) as an inspiration, I drew a very large image (20000 by 17500 pixels) of all roots of all polynomials of degree at most 26 whose coefficients are $-1$ or $1$. That&#8217;s 268.435.452 polynomials and 6.979.321.752 roots. It is two degrees more than Sam Derbyshire&#8217;s image,  so consider the race to be on! Who can give me 30 degrees?

<!--more-->

### The code

The [zeroes](https://github.com/andrejbauer/zeroes) GitHub repository contains the code.

There really is not much to show. The C program which computes the zeroes uses the GNU Scientific Library routines for zero finding and is just 105 lines long. It generates a PPM image which I then processed with ImageMagick and ffmpeg. The real work was in the image processing and the composition of movies. I wrote a helper Python program that lets me create floyovers the big image, and I became somewhat of an expert in the use of ImageMagick.

The code also contains a Python program for generating a variation of the picture in which roots of lower degrees are represented by big circles. I did not show any of this in the TEDx talk but it is available on Github.

Oh, and a piece of Mathematica code that generates the zeroes [fits into a tweet](https://twitter.com/wolframtap/status/515526464650084352/).

### The videos

The &#8220;[Zeroes](https://vimeo.com/album/3086303)&#8221; Vimeo album contains the animations. The ones I showed in the TEDx talk are in Full HD (1920 by 1080). There is also a lower resolution animation of how zeroes move around when we change the coefficients. Here is one of the movies, but you really should watch it in Full HD to see all the details.



### The pictures

  * The computed image [zeroes.ppm.gz](/wp-content/uploads/2014/10/zeroes26.ppm.gz) (125 MB) at 20000 by 17500 pixels is stored in the PPM format. The picture is dull gray, and is not meant to be viewed directly.
  * The official image [zeroes26.png](/wp-content/uploads/2014/10/zeroes26.png) (287 MB) at 20000 by 175000 pixels in orange tones. Beware,  it can bring an image viewing program to its knees.
  * I computed tons of closeups to generate the movies. Here are the beginnings of each animation available at Vimeo, and measly 1920 by 1080 pixels each (click on them). 
      * The whole image: [<img class="aligncenter size-medium wp-image-1783" alt="zoom" src="http://math.andrej.com/wp-content/uploads/2014/10/zoom1-300x168.png" width="300" height="168" srcset="http://math.andrej.com/wp-content/uploads/2014/10/zoom1-300x168.png 300w, http://math.andrej.com/wp-content/uploads/2014/10/zoom1-1024x576.png 1024w" sizes="(max-width: 300px) 100vw, 300px" />](http://math.andrej.com/wp-content/uploads/2014/10/zoom1.png)
      * Zoom at $i$: [<img class="aligncenter size-medium wp-image-1784" alt="arc" src="http://math.andrej.com/wp-content/uploads/2014/10/arc1-300x168.png" width="300" height="168" srcset="http://math.andrej.com/wp-content/uploads/2014/10/arc1-300x168.png 300w, http://math.andrej.com/wp-content/uploads/2014/10/arc1-1024x576.png 1024w" sizes="(max-width: 300px) 100vw, 300px" />](http://math.andrej.com/wp-content/uploads/2014/10/arc1.png)
      * Zoom at $(1 + \sqrt{3} i)/2$:[<img class="aligncenter size-medium wp-image-1785" alt="tofringe" src="http://math.andrej.com/wp-content/uploads/2014/10/tofringe1-300x168.png" width="300" height="168" srcset="http://math.andrej.com/wp-content/uploads/2014/10/tofringe1-300x168.png 300w, http://math.andrej.com/wp-content/uploads/2014/10/tofringe1-1024x576.png 1024w" sizes="(max-width: 300px) 100vw, 300px" />](http://math.andrej.com/wp-content/uploads/2014/10/tofringe1.png)
      * Zoom at $1.4 i$:[<img class="aligncenter size-medium wp-image-1779" alt="fringe" src="http://math.andrej.com/wp-content/uploads/2014/10/fringe-300x168.png" width="300" height="168" srcset="http://math.andrej.com/wp-content/uploads/2014/10/fringe-300x168.png 300w, http://math.andrej.com/wp-content/uploads/2014/10/fringe-1024x576.png 1024w" sizes="(max-width: 300px) 100vw, 300px" />](http://math.andrej.com/wp-content/uploads/2014/10/fringe.png)
      * Zoom at $3 e^{7 i \pi/24}/2$:[<img class="aligncenter size-medium wp-image-1786" alt="tozero" src="http://math.andrej.com/wp-content/uploads/2014/10/tozero1-300x168.png" width="300" height="168" srcset="http://math.andrej.com/wp-content/uploads/2014/10/tozero1-300x168.png 300w, http://math.andrej.com/wp-content/uploads/2014/10/tozero1-1024x576.png 1024w" sizes="(max-width: 300px) 100vw, 300px" />](http://math.andrej.com/wp-content/uploads/2014/10/tozero1.png)
      * Zoom at $1$:[<img class="aligncenter size-medium wp-image-1787" alt="unzoom" src="http://math.andrej.com/wp-content/uploads/2014/10/unzoom-300x168.png" width="300" height="168" srcset="http://math.andrej.com/wp-content/uploads/2014/10/unzoom-300x168.png 300w, http://math.andrej.com/wp-content/uploads/2014/10/unzoom-1024x576.png 1024w" sizes="(max-width: 300px) 100vw, 300px" />](http://math.andrej.com/wp-content/uploads/2014/10/unzoom.png)