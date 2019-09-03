ABOUT THE GAME

The Hydra is a rooted tree. The object of the game is to chop off all of its heads (blue circles).
At step n, when you cut a head, Hydra will grow n new copies of the tree growing from the neck at
which the head was cut.

A theorem by Paris and Kirby [1] states that YOU CANNOT LOSE but it takes a rather long
time to chop down a hydra. Paris and Kirby also showed that Peano arithmetic does not prove
that hydra always loses.

References:

[1] Accessible Independence Results for Peano Arithmetic by Kirby and Paris.
    Bull. London Math. Soc..1982; 14: 285-293.

ABOUT THE PROGRAM

The Hydra game is implemented in Java. The source code is freely available
at http://math.andrej.com/the-hydra-game/. Please send me any enhancements you
implement on top of my code.

The source code is packaged as an Eclipse project which you can import directly
into Eclipse.

You may run the main program HydraWindow from Eclipse or directly from command
line with

  java hydra.HydraWindow

Alternatively, you can download the JAR file and run it with

  java -jar hydra.jar
  
The game can be embedded into a web page as a Java applet, for which you should
use hydra.JavaApplet. See also the file hydraApplet.html.

Andrej Bauer

Andrej.Bauer@andrej.com
http://andrej.com
