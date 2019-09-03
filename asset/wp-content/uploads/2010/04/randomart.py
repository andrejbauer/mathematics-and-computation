#!/usr/bin/python

# Copyright (c) 2010, Andrej Bauer, http://andrej.com/
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#     * Redistributions of source code must retain the above copyright notice,
#       this list of conditions and the following disclaimer.
#
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

######################################################################
# SIMPLE RANDOM ART IN PYTHON
#
# Version 2010-04-21
#
# I get asked every so often to release the source code for my random art
# project at http://www.random-art.org/. The original source is written in Ocaml
# and is not publicly available, but here is a simple example of how you can get
# random art going in python in 250 lines of code.
#
# The idea is to generate expression trees that describe an image. For each
# point (x,y) of the image we evaluate the expression and get a color. A color
# is represented as a triple (r,g,b) where the red, green, blue components are
# numbers between -1 and 1. In computer graphics it is more usual to use the
# range [0,1], but since many operations are symmetric with respect to the
# origin it is more convenient to use the interval [-1,1].
#
# I kept the program as simple as possible, and independent of any non-standard
# Python libraries. Consequently, a number of improvements and further
# experiments are possible:
#
#   * The most pressing problem right now is that the image is displayed as a
#     large number of rectangles of size 1x1 on the tkinter Canvas, which
#     consumes a great deal of memory. You will not be able to draw large images
#     this way. An improved version would use the Python imagining library (PIL)
#     instead.
#
#   * The program uses a simple RGB (Red Green Blue) color model. We could also
#     use the HSV model (Hue Saturation Value), and others. One possibility is
#     to generate a palette of colors and use only colors that are combinations
#     of those from the palette.
#
#   * Of course, you can experiment by introducing new operators. If you are going
#     to play with the source, your first exercise should be a new operator.
#
#   * The program uses cartesian coordinates. You could experiment with polar
#     coordinates.
#
# For more information and further discussion, see http://math.andrej.com/category/random-art/

import math
import random
from Tkinter import * # Change "Tkinter" to "tkinter" in Python 3

# Utility functions

def average(c1, c2, w=0.5):
    '''Compute the weighted average of two colors. With w = 0.5 we get the average.'''
    (r1,g1,b1) = c1
    (r2,g2,b2) = c2
    r3 = w * r1 + (1 - w) * r2
    g3 = w * g1 + (1 - w) * g2
    b3 = w * b1 + (1 - w) * b2
    return (r3, g3, b3)

def rgb(r,g,b):
    '''Convert a color represented by (r,g,b) to a string understood by tkinter.'''
    u = max(0, min(255, int(128 * (r + 1))))
    v = max(0, min(255, int(128 * (g + 1))))
    w = max(0, min(255, int(128 * (b + 1))))
    return '#%02x%02x%02x' % (u, v, w)

def well(x):
    '''A function which looks a bit like a well.'''
    return 1 - 2 / (1 + x*x) ** 8

def tent(x):
    '''A function that looks a bit like a tent.'''
    return 1 - 2 * abs(x)

# We next define classes that represent expression trees.

# Each object that reprents and expression should have an eval(self,x,y) method
# which computes the value of the expression at (x,y). The __init__ should
# accept the objects representing its subexpressions. The class definition
# should contain the arity attribute which tells how many subexpressions should
# be passed to the __init__ constructor.

class VariableX():
    arity = 0
    def __init__(self): pass
    def __repr__(self): return "x"

    def eval(self,x,y): return (x,x,x)

class VariableY():
    arity = 0
    def __init__(self): pass
    def __repr__(self): return "y"
    def eval(self,x,y): return (y,y,y)

class Constant():
    arity = 0
    def __init__(self):
        self.c = (random.uniform(0,1), random.uniform(0,1), random.uniform(0,1))
    def __repr__(self):
        return 'Constant(%g,%g,%g)' % self.c
    def eval(self,x,y): return self.c

class Sum():
    arity = 2
    def __init__(self, e1, e2):
        self.e1 = e1
        self.e2 = e2
    def __repr__(self):
        return 'Sum(%s, %s)' % (self.e1, self.e2)
    def eval(self,x,y):
        return average(self.e1.eval(x,y), self.e2.eval(x,y))

class Product():
    arity = 2
    def __init__(self, e1, e2):
        self.e1 = e1
        self.e2 = e2
    def __repr__(self):
        return 'Product(%s, %s)' % (self.e1, self.e2)
    def eval(self,x,y):
        (r1,g1,b1) = self.e1.eval(x,y)
        (r2,g2,b2) = self.e2.eval(x,y)
        r3 = r1 * r2
        g3 = g1 * g2
        b3 = b1 * b2
        return (r3, g3, b3)

class Mod():
    arity = 2
    def __init__(self, e1, e2):
        self.e1 = e1
        self.e2 = e2
    def __repr__(self):
        return 'Mod(%s, %s)' % (self.e1, self.e2)
    def eval(self,x,y):
        (r1,g1,b1) = self.e1.eval(x,y)
        (r2,g2,b2) = self.e2.eval(x,y)
        try:
            r3 = r1 % r2
            g3 = g1 % g2
            b3 = b1 % b2
            return (r3, g3, b3)
        except:
            return (0,0,0)

class Well():
    arity = 1
    def __init__(self, e):
        self.e = e
    def __repr__(self):
        return 'Well(%s)' % self.e
    def eval(self,x,y):
        (r,g,b) = self.e.eval(x,y)
        return (well(r), well(g), well(b))

class Tent():
    arity = 1
    def __init__(self, e):
        self.e = e
    def __repr__(self):
        return 'Tent(%s)' % self.e
    def eval(self,x,y):
        (r,g,b) = self.e.eval(x,y)
        return (tent(r), tent(g), tent(b))

class Sin():
    arity = 1
    def __init__(self, e):
        self.e = e
        self.phase = random.uniform(0, math.pi)
        self.freq = random.uniform(1.0, 6.0)
    def __repr__(self):
        return 'Sin(%g + %g * %s)' % (self.phase, self.freq, self.e)
    def eval(self,x,y):
        (r1,g1,b1) = self.e.eval(x,y)
        r2 = math.sin(self.phase + self.freq * r1)
        g2 = math.sin(self.phase + self.freq * g1)
        b2 = math.sin(self.phase + self.freq * b1)
        return (r2,g2,b2)

class Level():
    arity = 3
    def __init__(self, level, e1, e2):
        self.treshold = random.uniform(-1.0,1.0)
        self.level = level
        self.e1 = e1
        self.e2 = e2
    def __repr__(self):
        return 'Level(%g, %s, %s, %s)' % (self.treshold, self.level, self.e1, self.e2)
    def eval(self,x,y):
        (r1, g1, b1) = self.level.eval(x,y)
        (r2, g2, b2) = self.e1.eval(x,y)
        (r3, g3, b3) = self.e2.eval(x,y)
        r4 = r2 if r1 < self.treshold else r3
        g4 = g2 if g1 < self.treshold else g3
        b4 = b2 if b1 < self.treshold else b3
        return (r4,g4,b4)

class Mix():
    arity = 3
    def __init__(self, w, e1, e2):
        self.w = w
        self.e1 = e1
        self.e2 = e2
    def __repr__(self):
        return 'Mix(%s, %s, %s)' % (self.w, self.e1, self.e2)
    def eval(self,x,y):
        w = 0.5 * (self.w.eval(x,y)[0] + 1.0)
        c1 = self.e1.eval(x,y)
        c2 = self.e2.eval(x,y)
        return average(c1,c2,)

# The following list of all classes that are used for generation of expressions is
# used by the generate function below.

operators = (VariableX, VariableY, Constant, Sum, Product, Mod, Sin, Tent, Well, Level, Mix)

# We precompute those operators that have arity 0 and arity > 0

operators0 = [op for op in operators if op.arity == 0]
operators1 = [op for op in operators if op.arity > 0]

def generate(k = 50):
    '''Randonly generate an expession of a given size.'''
    if k <= 0: 
        # We used up available size, generate a leaf of the expression tree
        op = random.choice(operators0)
        return op()
    else:
        # randomly pick an operator whose arity > 0
        op = random.choice(operators1)
        # generate subexpressions
        i = 0 # the amount of available size used up so far
        args = [] # the list of generated subexpression
        for j in sorted([random.randrange(k) for l in range(op.arity-1)]):
            args.append(generate(j - i))
            i = j
        args.append(generate(k - 1 - i))
        return op(*args)

class Art():
    """A simple graphical user interface for random art. It displays the image,
       and the 'Again!' button."""

    def __init__(self, master, size=256):
        master.title('Random art')
        self.size=size
        self.canvas = Canvas(master, width=size, height=size)
        self.canvas.grid(row=0,column=0)
        b = Button(master, text='Again!', command=self.redraw)
        b.grid(row=1,column=0)
        self.draw_alarm = None
        self.redraw()

    def redraw(self):
        if self.draw_alarm: self.canvas.after_cancel(self.draw_alarm)
        self.canvas.delete(ALL)
        self.art = generate(random.randrange(20,150))
        self.d = 64   # current square size
        self.y = 0    # current row
        self.draw()

    def draw(self):
        if self.y >= self.size:
            self.y = 0
            self.d = self.d // 4
        if self.d >= 1:
            for x in range(0, self.size, self.d):
                    u = 2 * float(x + self.d/2)/self.size - 1.0
                    v = 2 * float(self.y + self.d/2)/self.size - 1.0
                    (r,g,b) = self.art.eval(u, v)
                    self.canvas.create_rectangle(x,
                                                 self.y,
                                                 x+self.d,
                                                 self.y+self.d,
                                                 width=0, fill=rgb(r,g,b))
            self.y += self.d
            self.draw_alarm = self.canvas.after(1, self.draw)
        else:
            self.draw_alarm = None

# Main program
win = Tk()
arg = Art(win)
win.mainloop()
