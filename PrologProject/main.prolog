:- consult(partials/asserts).
:- consult(partials/validations).
:- consult(partials/movement).

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
  get_min_path(T,Length,Path,FinalPath),
  retractall(neighbour(_,_)), retractall(accesible_point(_)), !.

/*----------------------------------------------------------------------------*/
% run(Path) :-
  % Board = [
  % [(1,1,true),(1,2,true),(1,3,true),(1,4,true),(1,5,true)],
  % [(2,1,true),(2,2,true),(2,3,true),(2,4,true),(2,5,true)],
  % [(4,1,true),(4,2,true),(4,3,true),(4,4,true),(4,5,true)],
  % [(5,1,true),(5,2,true),(5,3,true),(5,4,true),(5,5,true)]
  % [(3,1,true),(3,2,true),(3,3,true),(3,4,true),(3,5,true)],
  % ],
  % get_path((1,1,true),(3,3,true), Board, Path).
