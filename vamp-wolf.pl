goal([0,0,3,3]).

stateDef(VamEast,WereEast,VamWest,WereWest,Place).

%%%%%%%%%%%%%%%%%%%%%%%% validState %%%%%%%%%%%%%%%%%%%%%%%%
validState([VamEast,WereEast,VamWest,WereWest,Place]):-
	(VamEast >= WereEast; VamEast = 0),
	(VamWest >= WereWest; VamWest = 0),
%	(Place = east; Place = west).
	VamEast >= 0,
	VamEast =< 3,

	VamWest >= 0,
	VamWest =< 3,

	WereEast >= 0,
	WereEast =< 3,

	WereWest >= 0,
	WereWest =< 3.


%%%%%%%%%%%%%%%%%%%%%%%%%%% from east to west: %%%%%%%%%%%%%%%%%%%%%%%%%%%

move([VamEast,WereEast,VamWest,WereWest,east], [VamEastN,WereEastN,VamWestN,WereWestN,west]):-
	%1 V
	VamEastN is VamEast - 1,
	WereEastN is WereEast,
	VamWestN is VamWest + 1,
	WereWestN is WereWest,
	validState([VamEastN,WereEastN,VamWestN,WereWestN,west]).


move([VamEast,WereEast,VamWest,WereWest,east], [VamEastN,WereEastN,VamWestN,WereWestN,west]):-
	%2 V
	VamEastN is VamEast - 2,
	WereEastN is WereEast,
	VamWestN is VamWest + 2,
	WereWestN is WereWest,
	validState([VamEastN,WereEastN,VamWestN,WereWestN,west]).


move([VamEast,WereEast,VamWest,WereWest,east], [VamEastN,WereEastN,VamWestN,WereWestN,west]):-
	%1 W
	VamEastN is VamEast,
	WereEastN is WereEast-1,
	VamWestN is VamWest,
	WereWestN is WereWest+1,
	validState([VamEastN,WereEastN,VamWestN,WereWestN,west]).


move([VamEast,WereEast,VamWest,WereWest,east], [VamEastN,WereEastN,VamWestN,WereWestN,west]):-
	%2 W
	VamEastN is VamEast,
	WereEastN is WereEast-2,
	VamWestN is VamWest,
	WereWestN is WereWest+2,
	validState([VamEastN,WereEastN,VamWestN,WereWestN,west]).

move([VamEast,WereEast,VamWest,WereWest,east], [VamEastN,WereEastN,VamWestN,WereWestN,west]):-
	%1 W and 1 V
	VamEastN is VamEast-1,
	WereEastN is WereEast-1,
	VamWestN is VamWest+1,
	WereWestN is WereWest+1,
	validState([VamEastN,WereEastN,VamWestN,WereWestN,west]).



%%%%%%%%%%%%%%%%%%%%%%%%%%% from West to East: %%%%%%%%%%%%%%%%%%%%%%%%%%%

move([VamEast,WereEast,VamWest,WereWest,west], [VamEastN,WereEastN,VamWestN,WereWestN,east]):-
	%1 V
	VamEastN is VamEast + 1,
	WereEastN is WereEast,
	VamWestN is VamWest - 1,
	WereWestN is WereWest,
	validState([VamEastN,WereEastN,VamWestN,WereWestN,east]).

move([VamEast,WereEast,VamWest,WereWest,west], [VamEastN,WereEastN,VamWestN,WereWestN,east]):-
	%2 V
	VamEastN is VamEast + 2,
	WereEastN is WereEast,
	VamWestN is VamWest - 2,
	WereWestN is WereWest,
	validState([VamEastN,WereEastN,VamWestN,WereWestN,east]).


move([VamEast,WereEast,VamWest,WereWest,west], [VamEastN,WereEastN,VamWestN,WereWestN,east]):-
	%1 W
	VamEastN is VamEast,
	WereEastN is WereEast+1,
	VamWestN is VamWest,
	WereWestN is WereWest -1,
	validState([VamEastN,WereEastN,VamWestN,WereWestN,east]).


move([VamEast,WereEast,VamWest,WereWest,west], [VamEastN,WereEastN,VamWestN,WereWestN,east]):-
	%2 W
	VamEastN is VamEast,
	WereEastN is WereEast+2,
	VamWestN is VamWest,
	WereWestN is WereWest-2,
	validState([VamEastN,WereEastN,VamWestN,WereWestN,east]).


move([VamEast,WereEast,VamWest,WereWest,west], [VamEastN,WereEastN,VamWestN,WereWestN,east]):-
	%1 W and 1 V
	VamEastN is VamEast+1,
	WereEastN is WereEast+1,
	VamWestN is VamWest-1,
	WereWestN is WereWest -1,
	validState([VamEastN,WereEastN,VamWestN,WereWestN,east]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
listNextStates(State, Neighbors) :-
	findall(Neighbor, move(State, Neighbor), Neighbors).

listGoals(G):-
	goal(G).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% heuristic: Distance from goal %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

heuristic([WE,VE,WW,VW,Place],Goal,H):- H is (6-WW-VW).

heuristic1([VamEast1,WereEast1,VamWest1,WereWest1,Place1],[VamEast2,WereEast2,VamWest2,WereWest2,Place2],C):-
	helper([VamEast1,WereEast1,VamWest1,WereWest1],[VamEast2,WereEast2,VamWest2,WereWest2],C).

helper([], [] , 0).
helper([H1|T1], [H2|T2] , N):-
	(
			H1 >= H2 -> helper(T1, T2 , N1), N is (N1 + H1 - H2)
			;
			H1 < H2 -> helper(T1, T2 , N1),  N is (N1 + H2 - H1)
	).


	% [3,3,0,0] -> [0,0,3,3] :3+3+3+3= 12

	% [2, 2, 1, 1] -> [0,0,3,3] :  2+2+2+2 = 8

	%[[1, 1, 2, 2], [3, 3, 0, 0]]
	%	[1, 1, 2, 2] -> [0,0,3,3]:  1+1+1+1 = 4
	%	[3, 3, 0, 0] -> [0,0,3,3]: 3+3+3+3=12


	% [[0, 0, 3, 3], [2, 2, 1, 1]]
	%	[0, 0, 3, 3] -> [0,0,3,3] : 0+0+0+0 = 0  -> goal (STOP)
	%	[2, 2, 1, 1] -> [0,0,3,3] : 2+2+2+2 = 8
