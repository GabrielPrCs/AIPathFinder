/*
* Incluye los procedimientos en dichos archivos
*/
:- consult(partials/asserts).
:- consult(partials/validations).
:- consult(partials/movement).

/*
* La consulta se va a realizar sobre este procedimiento
* get_path(+Origin, +Destination, +Board, -FinalPath)
*/
get_path(Origin,Destination,Board,FinalPath) :-
  check_board(Board),
  generate_facts(Board),
  accesible_point(Origin), accesible_point(Destination),
  generate_neighbours(Board),
  findall(Path,move(Origin, Destination,[], Path),Paths),
  Paths = [H|T], H = (Path, Length),
  get_min_path(T,Length,Path,FinalPath),
  retractall(neighbour(_,_)), retractall(accesible_point(_)), !.
