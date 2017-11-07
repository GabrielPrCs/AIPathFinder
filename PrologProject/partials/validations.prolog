/*
* Procedimiento que verifica que un punto este compuesto por una posición en el
* eje X, una posición en el eje Y y un valor boolean que indica si dicho punto
* es accesible o no.
*/
point((_,_,_)).

/*
* Procedimiento que verifica que una fila de un tablero este conformada de la
* manera que s espera para su correcto funcionamiento.
*/
check_row([]).
check_row(Row) :- Row = [H|T], point(H), check_row(T).

/*
* Procedimiento que verifica si una tablero dado esta conformado de la manera que se
* espera para su correcto funcionamiento.
*/
check_board([]).
check_board(Board) :- Board = [Row|T], check_row(Row), check_board(T).
