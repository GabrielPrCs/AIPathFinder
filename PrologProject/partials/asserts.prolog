/*
* Una vez que el tablero ha sido validado, se pueden considerar a sus puntos compuesto
* hechos. Por lo tanto, se agrega cada punto como un hecho a la base de datos.
*/
generate_row_facts([]).
generate_row_facts([P|T]) :-
  P = (_,_,true),
  assert(accesible_point(P)),
  generate_row_facts(T).
generate_row_facts([P|T]) :-
  P = (_,_,false),
  generate_row_facts(T).

generate_facts([]).
generate_facts(Board) :-
  Board = [Row|Tail],
  generate_row_facts(Row),
  generate_facts(Tail).

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

generate_neighbours([]).
generate_neighbours(Board) :-
  Board = [Row|Tail],
  generate_row_neighbours(Row),
  generate_neighbours(Tail).
