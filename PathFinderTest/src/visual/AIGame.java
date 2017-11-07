/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package visual;

import boards.BasicBoard;
import boards.Cell;
import components.GameBoard;
import components.GameCharacter;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.newdawn.slick.AppGameContainer;
import org.newdawn.slick.BasicGame;
import org.newdawn.slick.Color;
import org.newdawn.slick.GameContainer;
import org.newdawn.slick.Graphics;
import org.newdawn.slick.SlickException;
import org.newdawn.slick.geom.Rectangle;

/**
 *
 * @author gabpc
 */
public class AIGame extends BasicGame {

    private BasicBoard board = null;
    private GameCharacter character = null;
    private int maxX, maxY;
    private int cellHeight, cellWidth;

    public AIGame(String title) {
        super(title);
    }

    @Override
    public void init(GameContainer gc) throws SlickException {
        this.maxX = 9;
        this.maxY = 9;
        this.cellHeight = gc.getHeight() / this.maxY;
        this.cellWidth = gc.getWidth() / this.maxX;
        this.board = new GameBoard(this.maxX, this.maxY);
        /*
010000000
010111110
010100010
010101010
010101010
010111010
010000010
011111110
000000000
         */
        this.board.setCellProperty(5, 3, "accessible", false);
        this.board.setCellProperty(5, 4, "accessible", true);
        this.board.setCellProperty(5, 5, "accessible", false);

        this.board.setCellProperty(4, 5, "accessible", false);
        for (int i = 1; i < 6; i++) {
            this.board.setCellProperty(3, i, "accessible", false);
        }
        for (int i = 0; i < 8; i++) {
            this.board.setCellProperty(1, i, "accessible", false);
        }
        for (int i = 1; i < 8; i++) {
            this.board.setCellProperty(i, 7, "accessible", false);
        }
        for (int i = 1; i < 7; i++) {
            this.board.setCellProperty(7, i, "accessible", false);
        }
        for (int i = 3; i < 7; i++) {
            this.board.setCellProperty(i, 1, "accessible", false);
        }
        this.board.setCellProperty(1, 4, "accessible", true);
        this.board.setCellProperty(1, 0, "accessible", true);

        this.character = new GameCharacter(0, 0, this.board);
        this.character.setDestination(4, 4);
        (new Thread(this.character)).start();
    }

    @Override
    public void update(GameContainer gc, int i) throws SlickException {

    }

    @Override
    public void render(GameContainer gc, Graphics g) throws SlickException {

        for (int i = 0; i < this.board.getRowCount(); i++) {
            Cell[] row = this.board.getRow(i);
            for (Cell point : row) {
                Rectangle rect = new Rectangle(point.getXPosition() * this.cellWidth, point.getYPosition() * this.cellHeight, this.cellWidth, this.cellHeight);

                if (point.getProperty("accessible") == Boolean.TRUE) {
                    g.setColor(Color.green);
                } else {
                    g.setColor(Color.red);
                }

                g.fill(rect);
            }
        }

        g.setColor(Color.white);
        g.fillOval(this.character.getXPosition() * this.cellWidth, this.character.getYPosition() * this.cellHeight, cellWidth, cellHeight);
    }

    public static void main(String[] args) {
        try {
            AppGameContainer appgc;
            appgc = new AppGameContainer(new AIGame("Simple Slick Game"));
            appgc.setDisplayMode(640, 640, false);
            appgc.setTargetFrameRate(30);
            appgc.setShowFPS(false);
            appgc.start();
        } catch (SlickException ex) {
            Logger.getLogger(AIGame.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

}
