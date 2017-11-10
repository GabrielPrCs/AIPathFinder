/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package components;

import boards.Cell;
import entities.MobileEntity;
import exceptions.InvalidMovementException;
import java.util.Iterator;
import java.util.logging.Level;
import java.util.logging.Logger;
import prolog.MovementQuerier;

/**
 *
 * @author gabpc
 */
public class MazeResolver extends MobileEntity implements Runnable {

    private Cell destination = null;
    private MazeBoard myBoard = null;

    public MazeResolver(int initialX, int initialY, int finalX, int finalY, MazeBoard board) {
        super(initialX, initialY);
        this.myBoard = board;
        this.destination = new Cell(finalX, finalY);
    }

    @Override
    protected boolean validateMovement(Cell origin, Cell delta) throws InvalidMovementException {
        int x = origin.getXPosition() + delta.getXPosition();
        int y = origin.getYPosition() + delta.getYPosition();
        if (this.myBoard.getCellProperty(x, y, "accessible") == Boolean.TRUE) {
            this.myBoard.setCellProperty(x, y, "visited", true);
            return true;
        }
        throw new InvalidMovementException();
    }

    @Override
    protected void calculateRotation(Cell origint, Cell delta) {
        // TODO
    }

    @Override
    public void run() {
        try {
            MovementQuerier mq = new MovementQuerier();
            Iterator<Cell> it = mq.getPath(this.getPosition(), this.destination, this.myBoard);

            while (it.hasNext()) {
                Cell next_point = it.next();
                Cell delta = new Cell(next_point.getXPosition() - this.getXPosition(), next_point.getYPosition() - this.getYPosition());
                this.move(delta);
                Thread.sleep(10);
            }
        } catch (NullPointerException | InvalidMovementException | InterruptedException e) {
            Logger.getLogger(MazeResolver.class.getName()).log(Level.SEVERE, null, e);
        }

    }

}
