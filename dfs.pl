
%%%
%%% This is one of the example programs from the textbook:
%%%
%%% Artificial Intelligence:
%%% Structures and strategies for complex problem solving
%%%
%%% by George F. Luger and William A. Stubblefield
%%%
%%% Corrections by Christopher E. Davis (chris2d@cs.unm.edu)
%%%
%%% These programs are copyrighted by Benjamin/Cummings Publishers.
%%%
%%% We offer them for use, free of charge, for educational purposes only.
%%%
%%% Disclaimer: These programs are provided with no warranty whatsoever as to
%%% their correctness, reliability, or any other property.  We have written
%%% them for specific educational purposes, and have made no effort
%%% to produce commercial quality computer programs.  Please do not expect
%%% more of them then we have intended.
%%%
%%% This code has been tested with SWI-Prolog (Multi-threaded, Version 5.2.13)
%%% and appears to function as intended.

%%%%%%%%%%%%%%%%%%%% stack operations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

member(X,[X|_]).
member(X,[_|T]):-member(X,T).

empty_stack([]).

member_stack(E, S) :- member(E, S).
stack(E, S, [E|S]).

%%%%%%%%%%%%%%%%%%%% DFS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

go(Start, Goal) :-
	empty_stack(Empty_been_list),
	stack(Start, Empty_been_list, Been_list),
	path(Start, Goal, Been_list).

path(Goal, Goal, Been_list) :-
	reverse_print_stack(Been_list).

path(State, Goal, Been_list) :-
	move(State, Next),
	% not(unsafe(Next)),
	not(member_stack(Next, Been_list)),
	stack(Next, Been_list, New_been_list),
	path(Next, Goal, New_been_list), !.

reverse_print_stack(S) :-
	empty_stack(S).
reverse_print_stack(S) :-
	stack(E, Rest, S),
	reverse_print_stack(Rest),
	write(E), nl.
