:- consult('display.pl').


%play/0
%main predicate for game start, presents the main menu
play :-
    clear,
  %  talpa_logo,
    menu.




try_move(GameState,Move,NewGameState) :-
    write('try move\n'),
    write('Move:'),
    write(Move),
    (move(GameState, Move, NewGameState)-> ! ; (write('Invalid move! Try again\n'), fail)).
    



%make_a_move(+GameState,-NewGameState)
% retrieves a move from the current player
%
%
%@param GameState the current game state
%@param NewGameState the new game state after the move
make_a_move([Board,PlayerTurn],NewGameState) :-
    write('Make a move like this: a1-b3\n!'),
    player(PlayerTurn,'Human'),
    repeat,
    catch((read_move([Board,PlayerTurn],Move)),_,(write('Invalid input. Try again\n!'),fail)),
    try_move([Board,PlayerTurn],Move,NewGameState),
    skip_line,!.

make_a_move([Board,PlayerTurn],NewGameState) :-
    player(PlayerTurn,'Computer'),
    %TODO
    computer_move(GameState,NewGameState).


% start_game(+GameState,+Player1Type,+Player2Type)
%starts a game with Player1Type vs Player2Type
start_game(GameState) :-
    clear,
    display_game(GameState),

    make_a_move(GameState,NewGameState).


teste12:- 

    initial(1,GameState),
    try_move(GameState,9-4-9-3,NewGameState).