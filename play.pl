%play/0
%main predicate for game start, presents the main menu
play :-
    clear,
  %  talpa_logo,
    menu.

% start_game(+GameState,+Player1Type,+Player2Type)
%starts a game with Player1Type vs Player2Type
start_game(GameState,Player1Type,Player2Type) :-
    clear,
    display_game(GameState),
    