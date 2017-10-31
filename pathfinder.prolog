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
check_row(Row) :- Row = [H|T], point(H), check_row(T).

/*
* Procedimiento que verifica si una tablero dado esta conformado de la manera que se
* espera para su correcto funcionamiento.
*/
check_board([]).
check_board(Board) :- Board = [Row|T], check_row(Row), check_board(T).

/*
* Procedimiento que verifica que un punto dado este contenido en un tablero dado.
*/
contains(Point,Board) :- member(Row,Board), member(Point,Row).

/*
* Una vez que el tablero ha sido validado, se pueden considerar a sus puntos compuesto
* hechos. Por lo tanto, se agrega cada punto como un hecho a la base de datos.
*/
generate_row_facts([]).
generate_row_facts([P|T]) :-
  P = (X,Y,B), B = true,
  assert(accesible_point(P)),
  generate_row_facts(T).
generate_row_facts([P|T]) :-
  P = (X,Y,B), B = false,
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

move((Xd,Yd,true),(Xd,Yd,true), Visited, Path) :-
  append(Visited,[(Xd,Yd,true)], VisitedUpdated),
  length(VisitedUpdated,Length), Path = (VisitedUpdated, Length), !.
move((X,Y,true), (Xd,Yd,true), Visited, Path) :-
  append(Visited,[(X,Y,true)], VisitedUpdated),
  neighbour((X,Y), (Xn,Yn)),
  accesible_point((Xn,Yn,true)),
  not(member((Xn,Yn,true), Visited)),
  move((Xn,Yn,true),(Xd,Yd,true), VisitedUpdated, Path).

get_min_path([],MinLength,Path,Path).
get_min_path(Paths,MinLength,_,MinPath):-
  Paths = [H|T],
  H = (Path,Length),
  Length < MinLength,
  get_min_path(T, Length,Path,MinPath).
get_min_path(Paths,MinLength,Path,MinPath):-
  Paths = [H|T],
  H = (_,Length),
  Length >= MinLength,
  get_min_path(T, MinLength,Path,MinPath).

/*
*
*/
get_path(Origin,Destination,Board,FinalPath) :-
  check_board(Board),
  generate_facts(Board),
  accesible_point(Origin), accesible_point(Destination),
  generate_neighbours(Board),
  findall(Path,move(Origin, Destination,[], Path),Paths),
  Paths = [H|T], H = (Path, Length),
  get_min_path(T,Length,Path,FinalPath).



/*----------------------------------------------------------------------------*/
get_default_board(Board) :-
  Board = [
  [(1,1,true),(1,2,true),(1,3,true),(1,4,true),(1,5,true)],
  [(2,1,true),(2,2,true),(2,3,true),(2,4,true),(2,5,true)],
  [(3,1,true),(3,2,true),(3,3,true),(3,4,true),(3,5,true)],
  [(4,1,true),(4,2,true),(4,3,true),(4,4,true),(4,5,true)],
  [(5,1,true),(5,2,true),(5,3,true),(5,4,true),(5,5,true)]
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

test_generate_neighbours :-
  get_default_board(Board),
  generate_neighbours(Board).

test_get_path :-
  get_default_board(Board),
  get_path((1,1,true),(5,5,true), Board, Path),write(Path).
