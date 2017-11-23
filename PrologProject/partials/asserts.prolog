/*
* Genera asertos de los puntos que son accesibles en una fila.
* Utiliza recursividad sobre cada elemento de la fila.
* generate_row_facts(+R)
*/
generate_row_facts([]).
generate_row_facts([P|T]) :-
  P = (_,_,true),
  assert(accesible_point(P)),
  generate_row_facts(T).
generate_row_facts([P|T]) :-
  P = (_,_,false),
  generate_row_facts(T).

/*
* Recibe el tablero completo y crea los hechos por fila.
* Utiliza el procedimiento anterior para resolver los asertos
* por fila.
* Utiliza recursividad sobre cada fila del tablero.
* generate_facts(+B)
*/
generate_facts([]).
generate_facts(Board) :-
  Board = [Row|Tail],
  generate_row_facts(Row),
  generate_facts(Tail).

/*
* Por cada punto de la fila genera los asertos de los vecinos
* que puede tener.
* generate_row_neighbours(+R)
*/
generate_row_neighbours([]).
generate_row_neighbours([P|T]) :-
  P = (X,Y,_),
  X1 is X+1,
  X2 is X-1,
  Y1 is Y+1,
  Y2 is Y-1,
  assert(neighbour((X,Y),(X1,Y))),
  assert(neighbour((X,Y),(X2,Y))),
  assert(neighbour((X,Y),(X,Y1))),
  assert(neighbour((X,Y),(X,Y2))),
  generate_row_neighbours(T).

/*
* Idem a generate_facts pero con los vecinos.
* generate_neighbours(+B)
*/
generate_neighbours([]).
generate_neighbours(Board) :-
  Board = [Row|Tail],
  generate_row_neighbours(Row),
  generate_neighbours(Tail).
