package hydra;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.util.Random;
import java.util.Vector;

public class Hydra {
    Hydra parent;
    Vector<Hydra> children;
    Dimension dimension;
    int x0, y0; // bounding box lower left corner
    
    private static final int radius = 10;
    private static final int extraHeight = 2 * radius;
    private static final int extraWidth = 3;
    
    // Empty hydra
    public Hydra() {
	children = new Vector<Hydra>();
	dimension = new Dimension();
	parent = null;
    }
    
    public Hydra(Vector<Hydra> children) {
	this.children = children;
	for (Hydra h : children) { h.parent = this; }
	dimension = new Dimension();
	parent = null;
    }
    
    public Hydra(Hydra parent) {
	this();
	this.parent = parent;
    }

    public Hydra(int n) {
	this();
	grow(n-1, new Random());
    }

    public void grow(int n, Random r) {
	if (n > 0) {
	    int k = 1 + r.nextInt(Math.min(4, n));
	    int[] s = new int[k];
	    for (int i = 0; i < n - k; i++) { s[r.nextInt(s.length)]++; }
	    for (int i = 0; i < s.length; i++) {
		Hydra h = new Hydra();
		h.grow(s[i], r);
		attachChild(h);
	    }
	}
    }
    
    public Hydra(Vector<Hydra> children, Hydra parent) {
	this(children);
	this.parent = parent;
    }
    
    public void attachChild(Hydra child) {
	children.add(child);
	child.parent = this;
    }

    public void attachChild(Hydra child, int k) {
	children.insertElementAt(child, k);
	child.parent = this;
    }

    public Hydra copy() {
	Vector<Hydra> c = new Vector<Hydra>(children.size());
	for (Hydra h : children) {
	    c.add(h.copy());
	}
	return new Hydra(c);
    }

    public int size() {
	int s = 1;
	for (Hydra h : children) {
	    s = s + h.size();
	}
	return s;
    }
    
    public void chop(int n) {
	if (children.isEmpty() && parent != null) {
	    parent.children.remove(this);
	    if (parent.parent != null) {
		int k = parent.parent.children.indexOf(parent);
		for (int i = 0; i < n; i++) { parent.parent.attachChild(parent.copy(), k); }
	    }
	}
    }
    
    public boolean chop(int n, int x, int y) {
	if (x0 <= x && x <= x0 + dimension.width && y0 <= y && y <= y0 + dimension.height) {
	    if (children.isEmpty() && parent != null) {
		int dx = x - vertexX();
		int dy = y - vertexY();
		if (dx * dx + dy * dy <= radius * radius) {
		    chop(n);
		    return true;
		}
	    }
	    else {
		for (Hydra h : children) {
		    if (h.chop(n, x, y)) { return true; }
		}
	    }
	}
	return false;
    }

    public void computeLayout() {
	computeLayout(0,0);
    }

    public void move(int dx, int dy) {
	x0 += dx; y0 += dy;
	for (Hydra h : children) { h.move(dx, dy); }
    }

    public void moveTo(int x, int y) {
	move(x - x0, y - y0);
    }
    
    public void computeLayout(int x0, int y0) {
	this.x0 = x0;
	this.y0 = y0;
	if (children.isEmpty()) {
	    dimension.width = 2 * (radius + extraWidth);
	    dimension.height = 2 * radius;
	}
	else {
	    int u = x0;
	    int v = 0;
	    for (Hydra h : children) {
		h.computeLayout(u, y0);
		u = u + h.dimension.width;
		v = Math.max(v, h.dimension.height);
	    }
	    for (Hydra h : children) { h.move(0, v - h.dimension.height); }
	    dimension.width = u - x0;
	    dimension.height = extraHeight + v + Math.min(100 * radius, dimension.width/7);
	}    
    }

    public int vertexX() { return x0 + dimension.width/2; }
    public int vertexY() { return y0 + dimension.height - radius; }
    
    public void paint(Graphics g) {
	// assume layout haas been computed
	int x = vertexX();
	int y = vertexY();
	if (children.isEmpty()) { g.setColor(Color.blue); }
	else { g.setColor(Color.black); }
	g.fillOval(x-radius, y-radius, 2*radius, 2*radius);
	g.setColor(Color.black);
	for (Hydra h : children) {
	    g.drawLine(x, y, h.vertexX(), h.vertexY());
	    h.paint(g);
	}
    }
}
