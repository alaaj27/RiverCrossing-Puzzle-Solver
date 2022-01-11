
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



%%%%%%%%%%%%%%%%%%%% queue operations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

empty_queue([]).

member_queue(E, S) :- member(E, S).

add_to_queue(E, [], [E]).
add_to_queue(E, [H|T], [H|Tnew]) :- add_to_queue(E, T, Tnew).


remove_from_queue(E, [E|T], T).

append_queue(First, Second, Concatenation) :-
    append(First, Second, Concatenation).

%%%%%%%%%%%%%%%%%%%% set operations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

empty_set([]).

member_set(E, S) :- member(E, S).

    % add_to_set adds a new member to a set, allowing each element
    % to appear only once

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


%%%%%%%%%%%%%%%%%%%% BFS operations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


state_record(State, Parent, [State, Parent]).

go(Start, Goal) :-
    empty_queue(Empty_open),
    state_record(Start, nil, State),
    add_to_queue(State, Empty_open, Open),
    empty_set(Closed),
    path(Open, Closed, Goal).

path(Open,_,_) :- empty_queue(Open),
                  write('graph searched, no solution found').

path(Open, Closed, Goal) :-
    remove_from_queue(Next_record, Open, _),
    state_record(State, _, Next_record),
    State = Goal,
    write('Solution path is: '), nl,
    printsolution(Next_record, Closed).

path(Open, Closed, Goal) :-
    remove_from_queue(Next_record, Open, Rest_of_open),
    (bagof(Child, moves(Next_record, Open, Closed, Child), Children);Children = []),
    add_list_to_queue(Children, Rest_of_open, New_open),
    add_to_set(Next_record, Closed, New_closed),
    path(New_open, New_closed, Goal),!.

moves(State_record, Open, Closed, Child_record) :-
    state_record(State, _, State_record),
    move(State, Next), %write
    % not (unsafe(Next)),
    state_record(Next, _, Test),
    not(member_queue(Test, Open)),
    not(member_set(Test, Closed)),
    state_record(Next, State, Child_record).

printsolution(State_record, _):-
    state_record(State,nil, State_record),
    write(State), nl.
printsolution(State_record, Closed) :-
    state_record(State, Parent, State_record),
    state_record(Parent, _, Parent_record),
    member(Parent_record, Closed),
    printsolution(Parent_record, Closed),
    write(State), nl.

add_list_to_queue([], Queue, Queue).
add_list_to_queue([H|T], Queue, New_queue) :-
    add_to_queue(H, Queue, Temp_queue),
    add_list_to_queue(T, Temp_queue, New_queue).
