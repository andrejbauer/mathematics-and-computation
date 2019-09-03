package hydra;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;

import javax.swing.JPanel;

public class HydraPanel extends JPanel {
    Hydra hydra;
    
    public HydraPanel(Hydra h, HydraApplet window) {
	super();
	hydra = h;
    }

    public void setHydra(Hydra h) {
	hydra = h;
	repaint();
    }
    
    public Dimension getPreferredSize() {
	hydra.computeLayout();
	return new Dimension(
		Math.max(300, hydra.dimension.width),
		Math.max(200, hydra.dimension.height));
    }
    
    @Override
    public void paintComponent(Graphics g) {
	hydra.computeLayout();
	g.setColor(Color.white);
	g.fillRect(0, 0, getWidth(), getHeight());
	g.setColor(Color.black);
	hydra.paint(g);
	revalidate();
    }
}
