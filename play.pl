:- consult('display.pl').


%play/0
%main predicate for game start, presents the main menu
play :-
    clear,
  %  talpa_logo,
    menu.

winner(1,2).
winner(2,1). 

% start_game(+GameState)
%starts a game with the given initial state
start_game(GameState) :-
    clear,
    display_game(GameState), 
    game_loop(GameState).

   

% game_loop(+GameState)
% main game loop, loops until the game is over
game_loop(GameState):-
    make_a_move(GameState,NewGameState),
    game_over(NewGameState,Result),
    process_result(NewGameState,Result).

% process_result(+GameState,+Result)
% processes the result of the game, 
% if the game is over, Result='Player', displays the winner
process_result([NewBoard,NewPlayerTurn],'Player'):-
    clear,
    display_game([NewBoard,NewPlayerTurn]),
    winner(NewPlayerTurn,Winner),
    format('~n~`*t Winner - Player ~d ~`*t~48|~n', [Winner]),
    sleep(5),clear.
% Case if the game is not over
process_result(NewGameState,'none'):-
    clear, 
    display_game(NewGameState),
    game_loop(NewGameState).

%% try_move(+GameState, +Move, -NewGameState)
%
% Tries to execute the desired move. If successful outputs a new sate, fails otherwise
try_move(GameState,Move,NewGameState) :-
    (move(GameState, Move, NewGameState)-> ! ; (write('Invalid move! Try again\n'), fail)).
    


%make_a_move(+GameState,-NewGameState)
% retrieves a move from the current player and tries to execute it
make_a_move([Board,PlayerTurn],NewGameState) :-
    format('~n~`*t Player ~d turn ~`*t~47|~n', [PlayerTurn]),
    write('           Make a move like this: a1-b3\n!'),
    player(PlayerTurn,'Human'),
    repeat,
    catch((read_move([Board,PlayerTurn],Move)),_,(write('Invalid input. Try again\n!'),fail)),
    try_move([Board,PlayerTurn],Move,NewGameState),
    skip_line,!.

% computer move
/*
make_a_move([Board,PlayerTurn],NewGameState) :-
    player(PlayerTurn,'Computer'),
    %TODO
    computer_move(GameState,NewGameState).
*/

% game_over(+GameState, -Result)
% checks if the game is over, if so sends the result
game_over([Board,PlayerTurn],Result) :-
    write('In game over'),nl,
    count_pieces_in_goal(Board,Result).


result(3,'Player').
result(4,'Player').
result(8,'Player').
result(15,'Player').
result(16,'Player').
result(20,'Player').
result(_,'none').

% count_pieces(+Board,+Count,-Result)
% counts the number of pieces in goal for each player
% if the number of pieces is >=3, or <=-3 then the game is over
count_pieces_in_goal(Board,Result) :-
    check_line(0,0,Board,0,Count),
    result(Count,Result).



check_line(_,10,_,Count,Count).
check_line(C,L,Board,Count,FinalCount):-
    L=<9,
    check_column(C,L,Board,TmpCount),
    Next_Count is Count + TmpCount,
    (C =:= 9 -> 
        Next_C is 0,Next_L is L+1;
        Next_C is C+1,Next_L is L),
    check_line(Next_C,Next_L,Board,Next_Count,FinalCount).


return_count(6,1).
return_count(7,1).
return_count(8,1).
return_count(10,5).
return_count(11,5).
return_count(12,5).
return_count(_,0).
check_column(C,L,Board,TmpCount):-
    nth0(L,Board,Line),
    nth0(C,Line,Elem),
    return_count(Elem,TmpCount).



teste12:- 

    initial(1,GameState),
    try_move(GameState,9-4-9-3,NewGameState).

teste13:-
    initial(1,GameState),
    process_result(GameState,'Player').

teste14:-
    initial(1,[Board,Player]),
    write('Board:'),write(Board),nl,
    count_pieces_in_goal(Board,Result).
    %write(Count).

teste15:-
    return_count(10,Count),
    write(Count).
teste16:-
    initial(1,[Board,Player]),
    Count is 0,
    check_line(0,0,Board,Count),
    write(Count),nl.

testegameover:-
    initial(1,[Board,Player]),
    game_over([Board,Player],Result),
    write(Result).