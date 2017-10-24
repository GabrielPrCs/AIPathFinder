lee_route(A,B,Obstables,Path) :-
  waves(B,[[A],[]],Obstacles,Waves),
  path(A,B,Waves,Path).

waves(B,[Wave|Waves],Obstacles,Waves) :- member(B,Wave), !.
waves(B,[Wave,LastWave|LastWaves],Obstacles,Waves) :-
  next_wave(Wave,LastWave,Obstacles,NextWave),
  waves(B,[NextWave,Wave,LastWave|LastWaves],Obstacles,Waves).

next_wave(Wave,LastWave,Obstacles,NextWave) :-
  findall(X,admissible(X,Wave,LastWave,Obstacles),NextWave).

admissible(X,Wave,LastWave,Obstacles) :-
  adjacent(X,Wave,Obstacles),
  not(member(X,LastWave)),
  not(member(X,Wave)).

adjacent(X,Wave,Obstacles) :-
  member(X1,Wave),
  neighbor(X1,X),
  not(obstructed(X,Obstacles)).

neighbor(X1-Y,X2-Y) :- next_to(X1,X2).
neighbor(X-Y1,X-Y2) :- next_to(Y1,Y2).

next_to(X,X1) :- X1 is X+1.
next_to(X,X1) :- X > 0, X1 is X-1.

obstructed(Point,Obstacles) :-
  member(Obstacle,Obstacles), obstructs(Point,Obstacle).

obstructs(X-Y,obstacle(X-Y1,X2-Y2)) :- Y1 =< Y, Y =< Y2.
obstructs(X-Y,obstacle(X1-Y1,X-Y2)) :- Y1 =< Y, Y =< Y2.
obstructs(X-Y,obstacle(X1-Y,X2-Y2)) :- X1 =< X, X =< X2.
obstructs(X-Y,obstacle(X1-Y1,X2-Y)) :- X1 =< X, X =< X2.

path(A,A,Waves,[A]) :- !.
path(A,B,[Wave|Waves],[B|Path]) :-
  member(B1,Wave),
  neighbor(B,B1),
  !, path(A,B1,Waves,Path).

test_lee(Name,Path) :-
  data(Name,A,B,Obstacles),
  lee_route(A,B,Obstacles,Path).

data(test,1-1,5-5,[obstacle(2-3,4-5),obstacle(6-6,8-8)]).
