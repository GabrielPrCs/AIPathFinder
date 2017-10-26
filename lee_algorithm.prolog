/******************NUEVO***********************/

/*
* Procedimiento que busca el vector unitario (X,Y) que indica la dirección
* en la cual se encuentra el destino.
*/
get_direction(Origin, Destination, X, Y):-
  Origin = (XO,YO,_), Destination = (XD,YD,_),
  X1 is XD - XO, X1 \== 0, X is X1 / abs(X1),
  Y1 is YD - YO, Y1 \== 0, Y is Y1 / abs(Y1).
get_direction(Origin, Destination, X, Y):-
  Origin = (XO,YO,_), Destination = (XD,YD,_),
  X1 is XD - XO, X1 == 0, X is 0,
  Y1 is YD - YO, Y1 \== 0, Y is Y1 / abs(Y1).
get_direction(Origin, Destination, X, Y):-
  Origin = (XO,YO,_), Destination = (XD,YD,_),
  X1 is XD - XO, X1 \== 0, X is X1 / abs(X1),
  Y1 is YD - YO, Y1 == 0, Y is 0.
get_direction(Origin, Destination, X, Y):-
  Origin = (XO,YO,_), Destination = (XD,YD,_),
  X1 is XD - XO, X1 == 0, X is 0,
  Y1 is YD - YO, Y1 == 0, Y is 0.




/**************fin*NUEVO***********************/

/*
* Procedimiento que verifica que un punto este compuesto por una posición en el
* eje X, una posición en el eje Y y un valor boolean que indica si dicho punto
* es accesible o no.
*/
point(P) :- P = (X,Y,B).

/*
* Procedimiento que verifica que una fila de un tablero este conformada de la
* manera que s espera para su correcto funcionamiento.
*/
check_row([]).
check_row(Row) :-
  Row = [H|T],
  point(H),
  check_row(T).

/*
* Procedimiento que verifica si una tablero dado esta conformado de la manera que se
* espera para su correcto funcionamiento.
*/
check_board([]).
check_board(Board) :-
  Board = [Row|T],
  check_row(Row),
  check_board(T).

/*
* Procedimiento que verifica que un punto dado este contenido en un tablero dado.
*/
contains(Point,Board) :-
  member(Row,Board),
  member(Point,Row).

/*
* Una vez que el tablero ha sido validado, se pueden considerar a sus puntos compuesto
* hechos. Por lo tanto, se agrega cada punto como un hecho a la base de datos.
*/
generate_facts(Board) :-
  contains(Point,Board),
  Point = (X,Y,B), B = true,
  assert(accesible_point(Point)).

/*
* Borra los puntos que estan en un hecho pero son innaccesibles ya que TODOS
* sus vecinos son innaccesibles.
*/

generate_path(Destination,Destination,[]).
generate_path(ActualPoint,Destination,Path) :-


/*
*
*/
get_path(Origin,Destination,Board,Path) :-
  point(Origin),
  point(Destination),
  check_board(Board),
  contains(Origin,Board),
  contains(Destination,Board),
  generate_facts(Board).

/*----------------------------------------------------------------------------*/
get_default_board(Board) :-
  Board = [
  [(1,1,true),(1,2,true),(1,3,false)],
  [(2,1,false),(2,2,true),(2,2,false)],
  [(3,1,true),(3,2,false),(3,3,true)]
  ].

test_check_board :-
  get_default_board(Board),
  check_board(Board),!.

test_contains :-
  get_default_board(Board),
  Point = (2,2,true),
  contains(Point,Board),!.

test_generate_facts :-
  get_default_board(Board),
  generate_facts(Board).
