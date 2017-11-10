/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package visual;

import boards.Cell;
import components.MazeBoard;
import components.MazeResolver;
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

    private MazeBoard maze = null;
    private int column_count, row_count;
    private int cellHeight, cellWidth;
    private int topOffset, leftOffset;

    public AIGame(String title) {
        super(title);
    }

    @Override
    public void init(GameContainer gc) throws SlickException {
        this.maze = MazeLoader.load("20x50");

        this.column_count = maze.getColumnCount();
        this.row_count = maze.getRowCount();

        this.cellHeight = gc.getHeight() / this.row_count;
        this.cellWidth = gc.getWidth() / this.column_count;

        if (this.cellHeight < this.cellWidth) {
            this.cellWidth = this.cellHeight;
        } else {
            this.cellHeight = this.cellWidth;
        }

        this.topOffset = (gc.getHeight() - this.row_count * this.cellHeight) / 2;
        this.leftOffset = (gc.getWidth() - this.column_count * this.cellWidth) / 2;

        Cell initial_point = maze.getInitialPoint();
        Cell final_point = maze.getFinalPoint();

        new Thread(
                new MazeResolver(
                        initial_point.getXPosition(),
                        initial_point.getYPosition(),
                        final_point.getXPosition(),
                        final_point.getYPosition(),
                        this.maze
                )
        ).start();
    }

    @Override
    public void update(GameContainer gc, int i) throws SlickException {

    }

    @Override
    public void render(GameContainer gc, Graphics g) throws SlickException {

        for (int i = 0; i < this.maze.getRowCount(); i++) {
            Cell[] row = this.maze.getRow(i);
            for (Cell cell : row) {

                if (cell.getProperty("accessible") == Boolean.TRUE) {
                    if (cell.getProperty("visited") == Boolean.TRUE) {
                        g.setColor(Color.blue);
                    } else if (cell.getProperty("initial_point") == Boolean.TRUE) {
                        g.setColor(Color.green);
                    } else if (cell.getProperty("final_point") == Boolean.TRUE) {
                        g.setColor(Color.red);
                    } else {
                        g.setColor(Color.white);
                    }
                } else {
                    g.setColor(Color.black);
                }

                int x = this.leftOffset + cell.getXPosition() * this.cellWidth;
                int y = this.topOffset + cell.getYPosition() * this.cellHeight;
                g.fill(new Rectangle(x, y, this.cellWidth, this.cellHeight));

            }
        }

    }

    public static void main(String[] args) {
        try {
            AppGameContainer app = new AppGameContainer(new AIGame("Maze Resolver"));
            app.setDisplayMode(app.getScreenWidth(), app.getScreenHeight(), true);
            //app.setDisplayMode(600, 600, false);
            app.setTargetFrameRate(30);
            app.setShowFPS(false);
            app.start();
        } catch (SlickException ex) {
            Logger.getLogger(AIGame.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

}
