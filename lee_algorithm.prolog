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


move(Destination, Destination, _, _):- write(llegaste).
move(Actual, Destination, X, Y):-
  Actual = (Xa,Ya,_),
  X1 is Xa + X,
  Y1 is Ya + Y,
  accesible_point((X1,Y1,true)),
  write(X1), write(Y1), nl,
  move((X1,Y1,true),Destination,X,Y), !.
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
*
generate_facts(Board) :-
  contains(Point,Board),
  Point = (X,Y,B), B = true,
  assert(accesible_point(Point)).
*/
generate_row_facts([]).
generate_row_facts([P|T]) :-
  P = (X,Y,B), B = true,
  assert(accesible_point(P)),
  generate_row_facts(T).

generate_facts([]).
generate_facts(Board) :-
  Board = [Row|Tail],
  generate_row_facts(Row),
  generate_facts(Tail).


/*
*
*/
get_path(Origin,Destination,Board,Path) :-
  point(Origin),
  point(Destination),
  check_board(Board),
  contains(Origin,Board),
  contains(Destination,Board),
  generate_facts(Board),
  get_direction(Origin, Destination, X, Y),
  move(Origin, Destination, X, Y).

/*----------------------------------------------------------------------------*/
get_default_board(Board) :-
  Board = [
  [(1,1,true),(1,2,true),(1,3,true), (1,4,true), (1,5,true)],
  [(2,1,true),(2,2,true),(2,2,true), (2,4,true), (2,5,true)],
  [(3,1,true),(3,2,true),(3,3,true), (3,4,true), (3,5,true)],
  [(4,1,true),(4,2,true),(4,3,true), (4,4,true), (4,5,true)],
  [(5,1,true),(5,2,true),(5,3,true), (5,4,true), (5,5,true)]
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

assert :-
  get_default_board(Board),
  generate_facts(Board).

test_get_path :-
  get_default_board(Board),
  get_path((1,1,true),(5,5,true), Board, Path).
