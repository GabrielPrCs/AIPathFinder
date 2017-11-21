/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package prolog;

import boards.Cell;
import components.MazeBoard;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Map;
import org.jpl7.Query;
import org.jpl7.Term;
import org.jpl7.Util;

/**
 *
 * @author gabpc
 */
public class MovementQuerier {

    private Query consult_file = null;

    public MovementQuerier() {
        this.consult_file = new Query("consult('../PrologProject/main.prolog')");
        System.out.println(consult_file.hasSolution() ? "Success" : "Error");
    }

    private String formatCell(Cell cell) {
        return MessageFormat.format("({0},{1},{2})", cell.getXPosition(), cell.getYPosition(), cell.getProperty("accessible"));
    }

    public Iterator<Cell> getPath(Cell ori, Cell dest, MazeBoard board) throws NullPointerException {

       
        ori.setProperty("accessible", board.getCellProperty(ori.getXPosition(), ori.getYPosition(), "accessible"));
        dest.setProperty("accessible", board.getCellProperty(dest.getXPosition(), dest.getYPosition(), "accessible"));

        /* Formats the input to the prolog standar */
        String origin = this.formatCell(ori);
        String destination = this.formatCell(dest);

        String board_formated = "[";
        for (int i = 0; i < board.getRowCount(); i++) {
            Cell[] row = board.getRow(i);

            String row_points = "";

            for (int j = 0; j < row.length ; j++) {
                Cell cell = row[j];
                row_points += this.formatCell(cell);
                if (j < row.length - 1) {
                    row_points += ",";
                }
            }
            

            String row_formated = MessageFormat.format("[{0}]", row_points);
            if (i < board.getRowCount() - 1) {
                row_formated += ",";
            }
            board_formated += row_formated;
        }
        board_formated += "]";
        

        String query = MessageFormat.format("get_path({0},{1},{2},FinalPath).", origin, destination, board_formated);
        System.out.println(query);

        Query get_path = new Query(query);

        Map<String, Term> finalPath = get_path.oneSolution();

        Term list = finalPath.get("FinalPath");

        Term[] points = Util.listToTermArray(list);

        ArrayList<Cell> ar = new ArrayList<>();

        for (Term point : points) {
            int x = point.arg(1).intValue();
            int y = point.arg(2).intValue();
            ar.add(new Cell(x, y));
        }
        
        // (new Query("retractall()")).allSolutions();

        return ar.iterator();

    }
}
