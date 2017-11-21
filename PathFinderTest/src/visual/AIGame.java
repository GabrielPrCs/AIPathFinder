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
import org.newdawn.slick.Input;
import org.newdawn.slick.SlickException;
import org.newdawn.slick.geom.Rectangle;

/**
 *
 * @author gabpc
 */
public class AIGame extends BasicGame {

    private int column_count, row_count;
    private int cellHeight, cellWidth;
    private int topOffset, leftOffset;
    private int actual_maze_index = 0;
    private String[] mazes = {"5x5", "10x10", "20x20", "20x50", "30x30", "40x40", "50x20", "50x20(v2)", "50x50"};
    private MazeBoard actual_maze = null;

    public AIGame(String title) {
        super(title);
    }

    private void loadMaze(int screenHeight, int screenWidth, String file_name) {
        this.actual_maze = MazeLoader.load(file_name);

        this.column_count = actual_maze.getColumnCount();
        this.row_count = actual_maze.getRowCount();

        this.cellHeight = screenHeight / this.row_count;
        this.cellWidth = screenWidth / this.column_count;

        if (this.cellHeight < this.cellWidth) {
            this.cellWidth = this.cellHeight;
        } else {
            this.cellHeight = this.cellWidth;
        }

        this.topOffset = (screenHeight - this.row_count * this.cellHeight) / 2;
        this.leftOffset = (screenWidth - this.column_count * this.cellWidth) / 2;

        Cell initial_point = actual_maze.getInitialPoint();
        Cell final_point = actual_maze.getFinalPoint();

        new Thread(
                new MazeResolver(
                        initial_point.getXPosition(),
                        initial_point.getYPosition(),
                        final_point.getXPosition(),
                        final_point.getYPosition(),
                        this.actual_maze
                )
        ).start();
    }

    @Override
    public void init(GameContainer gc) throws SlickException {
        this.loadMaze(gc.getHeight(), gc.getWidth(), this.mazes[actual_maze_index]);
    }

    @Override
    public void update(GameContainer gc, int i) throws SlickException {
        if (gc.getInput().isKeyPressed(Input.KEY_RIGHT)) {
            this.actual_maze_index++;
            if(this.actual_maze_index > this.mazes.length - 1) {
                this.actual_maze_index = 0;
            } 
            this.loadMaze(gc.getHeight(), gc.getWidth(), this.mazes[actual_maze_index]);
            System.out.println(this.actual_maze_index);
        } else if (gc.getInput().isKeyPressed(Input.KEY_LEFT)) {
            this.actual_maze_index--;
            if (this.actual_maze_index < 0) {
                this.actual_maze_index = this.mazes.length - 1;
            }
            this.loadMaze(gc.getHeight(), gc.getWidth(), this.mazes[actual_maze_index]);
        } else if (gc.getInput().isKeyPressed(Input.KEY_ESCAPE)) {
            System.exit(0);
        }
    }

    @Override
    public void render(GameContainer gc, Graphics g) throws SlickException {

        for (int i = 0; i < this.actual_maze.getRowCount(); i++) {
            Cell[] row = this.actual_maze.getRow(i);
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
            // app.setDisplayMode(600, 600, false);
            app.setTargetFrameRate(30);
            app.setShowFPS(false);
            app.start();
        } catch (SlickException ex) {
            Logger.getLogger(AIGame.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

}
