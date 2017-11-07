move((Xd,Yd,true),(Xd,Yd,true), Visited, Path) :-
  append(Visited,[(Xd,Yd)], VisitedUpdated), /* Saque el true de los puntos para facilitar la consulta de java */
  length(VisitedUpdated,Length), Path = (VisitedUpdated, Length), !.
move((X,Y,true), (Xd,Yd,true), Visited, Path) :-
  append(Visited,[(X,Y)], VisitedUpdated), /* Saque el true de los puntos para facilitar la consulta de java */
  neighbour((X,Y), (Xn,Yn)),
  accesible_point((Xn,Yn,true)),
  not(member((Xn,Yn), Visited)), /* Saque el true de los puntos para facilitar la consulta de java */
  move((Xn,Yn,true),(Xd,Yd,true), VisitedUpdated, Path).

get_min_path([],_,Path,Path).
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
