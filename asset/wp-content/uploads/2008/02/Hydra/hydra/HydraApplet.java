package hydra;

import java.awt.BorderLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;

import javax.swing.JApplet;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextField;

public class HydraApplet extends JApplet implements ActionListener, MouseListener {
    Hydra hydra;
    HydraPanel panel;
    JTextField size;
    JButton start, about;
    JLabel stepLabel;
    int step;
    JLabel sizeLabel;
    
    public HydraApplet() {
	hydra = new Hydra(9);
	panel = new HydraPanel(hydra, this);
	panel.addMouseListener(this);
	this.getContentPane().add(new JScrollPane(panel), BorderLayout.CENTER);
	JPanel toolbar = new JPanel();
	toolbar.add(new JLabel("Initial size:"));
	size = new JTextField(3);
	size.setText(Integer.toString(hydra.size()));
	toolbar.add(size);
	start = new JButton("Start");
	start.addActionListener(this);
	toolbar.add(start);
	about = new JButton("About");
	about.addActionListener(this);
	toolbar.add(about);
	this.getContentPane().add(toolbar, BorderLayout.SOUTH);
	JPanel infobar = new JPanel();
	step = 1;
	infobar.add(new JLabel("Step: "));
	stepLabel = new JLabel();
	infobar.add(stepLabel);
	infobar.add(new JLabel("Size: "));
	sizeLabel = new JLabel();
	infobar.add(sizeLabel);
	this.getContentPane().add(infobar, BorderLayout.NORTH);
	refreshInfo();
    }

    public void refreshInfo() {
	stepLabel.setText(Integer.toString(step));
	sizeLabel.setText(Integer.toString(hydra.size()));
    }
    
    public void actionPerformed(ActionEvent e) {
	if (e.getSource() == start) {
	    try {
		int n = Integer.parseInt(size.getText());
		hydra = new Hydra(n);
		step = 1;
		panel.setHydra(hydra);
		refreshInfo();
		repaint();
	    }
	    catch (NumberFormatException exn) { }
	}
	else if (e.getSource() == about) {
	    JOptionPane.showMessageDialog(this,
		    "The Hydra game by Paris and Kirby.\n" +
		    "Chop off the blue heads by clicking on them.\n" +
		    "The hydra will grow new heads at each step.\n" +
		    "Can you win by chopping off all heads?\n\n" +
		    "(c) 2008 Andrej Bauer, http://andrej.com/"
		    );
	}
    }
    
    public void mouseClicked(MouseEvent e) {
	if (panel.hydra.chop(step , e.getX(), e.getY())) {
	    hydra.computeLayout();
	    step++;
	    refreshInfo();
	    repaint();
	}
    }

    public void mouseEntered(MouseEvent arg0) {	
    }

    public void mouseExited(MouseEvent arg0) {	
    }

    public void mousePressed(MouseEvent arg0) {
    }

    public void mouseReleased(MouseEvent arg0) {
    }
}
