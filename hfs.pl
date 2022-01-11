
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
%%%%%%%%%%%%%%%%%%%% set operations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

empty_set([]).
member_set(E, S) :- member(E, S).
add_to_set(X, S, S) :- member(X, S), !.
add_to_set(X, S, [X|S]).

remove_from_set(_, [], []).
remove_from_set(E, [E|T], T) :- !.
remove_from_set(E, [H|T], [H|T_new]) :-
    remove_from_set(E, T, T_new), !.

union([], S, S).
union([H|T], S, S_new) :-
    union(T, S, S2),
    add_to_set(H, S2, S_new).

intersection([], _, []).
intersection([H|T], S, [H|S_new]) :-
    member_set(H, S),
    intersection(T, S, S_new),!.
intersection([_|T], S, S_new) :-
    intersection(T, S, S_new),!.

set_diff([], _, []).
set_diff([H|T], S, T_new) :-
    member_set(H, S),
    set_diff(T, S, T_new),!.
set_diff([H|T], S, [H|T_new]) :-
    set_diff(T, S, T_new), !.

subset([], _).
subset([H|T], S) :-
    member_set(H, S),
    subset(T, S).

equal_set(S1, S2) :-
    subset(S1, S2), subset(S2, S1).

%%%%%%%%%%%%%%%%%%%%%%% priority queue operations %%%%%%%%%%%%%%%%%%%

empty_sort_queue([]).

member_sort_queue(E, S) :- member(E, S).

insert_sort_queue(State, [], [State]).
insert_sort_queue(State, [H | T], [State, H | T]) :-
    precedes(State, H).
insert_sort_queue(State, [H|T], [H | T_new]) :-
    insert_sort_queue(State, T, T_new).

remove_sort_queue(First, [First|Rest], Rest).


%%%%%%%%%%%%%%%%%%%% HFS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


state_record(State, Parent, G, H, F, [State, Parent, G, H, F]).
precedes([_,_,_,_,F1], [_,_,_,_,F2]) :- F1 =< F2.

    % go initializes Open and CLosed and calls path
go(Start, Goal) :-
    empty_set(Closed),
    empty_sort_queue(Empty_open),
    heuristic(Start, Goal, H),
    state_record(Start, nil, 0, H, H, First_record),
    insert_sort_queue(First_record, Empty_open, Open),
    path(Open,Closed, Goal).

    % Open is empty; no solution found
path(Open,_,_) :-
    empty_sort_queue(Open),
    write("graph searched, no solution found").

    % The next record is a goal
    % Print out the list of visited states
path(Open, Closed, Goal) :-
    remove_sort_queue(First_record, Open, _),
    state_record(State, _, _, _, _, First_record),
    State = Goal,
    write('Solution path is: '), nl,
    printsolution(First_record, Closed).

    % The next record is not equal to the goal
    % Generate its children, add to open and continue
    % Note that bagof in AAIS prolog fails if its goal fails,
    % I needed to use the or to make it return an empty list in this case
path(Open, Closed, Goal) :-
    remove_sort_queue(First_record, Open, Rest_of_open),
    (bagof(Child, moves(First_record, Open, Closed, Child, Goal), Children);Children = []),
    insert_list(Children, Rest_of_open, New_open),
    add_to_set(First_record, Closed, New_closed),
    path(New_open, New_closed, Goal),!.

    % moves generates all children of a state that are not already on
    % open or closed.  The only wierd thing here is the construction
    % of a state record, test, that has unbound variables in all positions
    % except the state.  It is used to see if the next state matches
    % something already on open or closed, irrespective of that states parent
    % or other attributes
    % Also, I've commented out unsafe since the way I've coded the water jugs
    % problem I don't really need it.
moves(State_record, Open, Closed,Child, Goal) :-
    state_record(State, _, G, _,_, State_record),
    move(State, Next),
    % not(unsafe(Next)),
    state_record(Next, _, _, _, _, Test),
    not(member_sort_queue(Test, Open)),
    not(member_set(Test, Closed)),
    G_new is G + 1,
    heuristic(Next, Goal, H),
    F is G_new + H,
    state_record(Next, State, G_new, H, F, Child).

    %insert_list inserts a list of states obtained from a  call to
    % bagof and  inserts them in a priotrity queue, one at a time
insert_list([], L, L).
insert_list([State | Tail], L, New_L) :-
    insert_sort_queue(State, L, L2),
    insert_list(Tail, L2, New_L).

    % Printsolution prints out the solution path by tracing
    % back through the states on closed using parent links.
printsolution(Next_record, _):-
    state_record(State, nil, _, _,_, Next_record),
    write(State), nl.
printsolution(Next_record, Closed) :-
    state_record(State, Parent, _, _,_, Next_record),
    state_record(Parent, _, _, _, _, Parent_record),
    member_set(Parent_record, Closed),
    printsolution(Parent_record, Closed),
    write(State), nl.
