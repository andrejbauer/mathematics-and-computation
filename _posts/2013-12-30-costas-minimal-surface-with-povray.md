---
title: "Costa's minimal surface with PovRay"
author: Andrej Bauer
layout: post
categories:
  - Software
---

A student of mine worked on a project to produce beautiful pictures of Costa's minimal surface with the PovRay ray tracer. For this purpose she needed to triangulate the and compute normals to it at the vertices. It is not too hard to do the latter part, and the Internet offers several ways of doing it, but the normals are a bit tricky. If anyone can calculate them with paper and pencil I'd like to hear about it.

I went back to my undergraduate days when I actually did differential geometry and churned out the normals with Mathematica. It took a bit of work, kind advice from my colleague [Pavle Saksida](http://www.fmf.uni-lj.si/~saksida/index.html), and a pinch of black magic (to extract the Delaunay triangulation from Mathematica), so I thought I might as well publish the result at my [GitHub costa-surface repository](https://github.com/andrejbauer/costa-surface). The code is released into public domain. Have fun making pictures of Costa's surface! Here is mine (deliberately non-fancy):

[<img class="aligncenter size-medium wp-image-1578" alt="Costa's minimal surface" src="http://math.andrej.com/wp-content/uploads/2013/12/costa-300x300.png" width="300" height="300" srcset="http://math.andrej.com/wp-content/uploads/2013/12/costa-300x300.png 300w, http://math.andrej.com/wp-content/uploads/2013/12/costa-150x150.png 150w, http://math.andrej.com/wp-content/uploads/2013/12/costa.png 1024w" sizes="(max-width: 300px) 100vw, 300px" />](http://math.andrej.com/wp-content/uploads/2013/12/costa.png)
