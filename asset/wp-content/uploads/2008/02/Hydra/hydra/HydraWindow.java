package hydra;

import java.awt.BorderLayout;

import javax.swing.JFrame;

public class HydraWindow extends JFrame {
    public HydraWindow() {
	this.getContentPane().add(new HydraApplet(), BorderLayout.CENTER);
	this.setTitle("The hydra game");
	this.setDefaultCloseOperation(EXIT_ON_CLOSE);
    }
    
    public static void main(String[] args) {
	JFrame w = new HydraWindow();
	w.pack();
	w.setVisible(true);
    }
}
