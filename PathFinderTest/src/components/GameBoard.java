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
public class GameBoard extends BasicBoard {

    public GameBoard(int maxX, int maxY) {
        super(maxX, maxY);
        for (int i = 0; i < this.getRowCount(); i++) {
            Cell[] row = this.getRow(i);
            for (Cell cell : row) {
                cell.setProperty("accessible", true);
            }
        }
    }

}
