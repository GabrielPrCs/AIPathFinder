/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package components;

import boards.BasicBoard;
import boards.Cell;

/**
 *
 * @author gabpc
 */
public class MazeBoard extends BasicBoard {
    
    private final int column_count;
    private Cell initial_point = null, final_point = null;

    public MazeBoard(int maxX, int maxY) {
        super(maxX, maxY);
        this.column_count = maxX;
        for (int i = 0; i < this.getRowCount(); i++) {
            Cell[] row = this.getRow(i);
            for (Cell cell : row) {
                cell.setProperty("accessible", true);
            }
        }
    }
    
    public int getColumnCount() {
        return this.column_count;
    }

    public void setInitialPoint(Cell initial_point) {
        this.initial_point = initial_point;
    }

    public void setFinalPoint(Cell final_point) {
        this.final_point = final_point;
    }
    
    public Cell getInitialPoint() {
        return initial_point;
    }

    public Cell getFinalPoint() {
        return final_point;
    }
    
}
