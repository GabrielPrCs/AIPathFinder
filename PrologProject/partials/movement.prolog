/*
* Este procedimiento busca un camino entre el origen y
* el destino.
* Si es accesible se mueve a ese punto, sino va para atras
* y busca otro punto adyacente.
* move(+Origin, +Destination, +[], -Path)
*/
move((Xd,Yd,true),(Xd,Yd,true), Visited, Path) :-
  append(Visited,[(Xd,Yd)], VisitedUpdated),
  length(VisitedUpdated,Length), Path = (VisitedUpdated, Length), !.
move((X,Y,true), (Xd,Yd,true), Visited, Path) :-
  append(Visited,[(X,Y)], VisitedUpdated),
  neighbour((X,Y), (Xn,Yn)),
  accesible_point((Xn,Yn,true)),
  not(member((Xn,Yn), Visited)),
  move((Xn,Yn,true),(Xd,Yd,true), VisitedUpdated, Path).


/*
* Entre todos los caminos encontrados se busca el que tiene
* menor longitud.
* Si hay más de un camino con la misma longitud se selecciona
* el primero que
* se encuentra.
* get_min_path(+T,+Length,+Path,-FinalPath)
* siendo Length la longitud del primer camino y Path el camino,
* T es la cola con el resto de los caminos,
* FinalPath es el camino de menor longitud encontrado.
*/
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
