/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package components;

import boards.BasicBoard;
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
public class GameCharacter extends MobileEntity implements Runnable {

    private Cell destination = null;
    private BasicBoard myBoard = null;

    public GameCharacter(int initialX, int initialY, BasicBoard board) {
        super(initialX, initialY);
        this.myBoard = board;
    }

    public void setDestination(int x, int y) {
        this.destination = new Cell(x, y);
    }

    @Override
    protected boolean validateMovement(Cell origin, Cell delta) throws InvalidMovementException {
        int x = origin.getXPosition() + delta.getXPosition();
        int y = origin.getYPosition() + delta.getYPosition();
        if (this.myBoard.getCellProperty(x, y, "accessible") == Boolean.TRUE) {
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
                System.out.println(this.getXPosition() + " " + this.getYPosition());
                Thread.sleep(250);
            }
        } catch (NullPointerException | InvalidMovementException | InterruptedException e) {
            Logger.getLogger(GameCharacter.class.getName()).log(Level.SEVERE, null, e);
        }

    }

}
