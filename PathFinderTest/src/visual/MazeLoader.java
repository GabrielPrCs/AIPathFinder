/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package visual;

import boards.Cell;
import components.MazeBoard;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author gabpc
 */
public abstract class MazeLoader {

    public static final MazeBoard load(String file_name) {

        FileReader fr;
        MazeBoard board = null;
        try {
            File f = new File("maps/" + file_name);
            fr = new FileReader(f);
            BufferedReader br = new BufferedReader(fr);

            int maxX = 0, maxY = 0;

            String actual_line, previous_line = null;
            while ((actual_line = br.readLine()) != null) {
                maxY++;
                previous_line = actual_line;
            }

            maxX = previous_line.length();

            board = new MazeBoard(maxX, maxY);

            fr.close();

            fr = new FileReader(f);
            br = new BufferedReader(fr);

            int y = 0;
            while ((actual_line = br.readLine()) != null) {
                for (int x = 0; x < actual_line.length(); x++) {
                    if (actual_line.charAt(x) == '#') {
                        board.setCellProperty(x, y, "accessible", false);
                    } else {
                        board.setCellProperty(x, y, "accessible", true);
                    }

                    if (actual_line.charAt(x) == 'I') {
                        board.setCellProperty(x, y, "initial_point", true);
                        board.setInitialPoint(new Cell(x, y));
                    }

                    if (actual_line.charAt(x) == 'F') {
                        board.setCellProperty(x, y, "final_point", true);
                        board.setFinalPoint(new Cell(x, y));
                    }
                }
                y++;
            }

            fr.close();

        } catch (FileNotFoundException ex) {
            Logger.getLogger(MazeLoader.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
            Logger.getLogger(MazeLoader.class.getName()).log(Level.SEVERE, null, ex);
        }

        return board;

    }

}
