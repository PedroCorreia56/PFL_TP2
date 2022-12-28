% initial(+Identifier,-Board)
% Initail board with pieces in their starting positions
initial(1,[[
    [0,0,0,0,-1,-1,0,0,0,0],
    [0,0,0,-3,-2,-2,-3,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,4,0,0,4,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,4,0,0,4,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,3,2,2,3,0,0,0],
    [0,0,0,0,1,1,0,0,0,0]],1]).

% Pieces codes for board representation
code(0,"  "). % space
code(1,"E1"). % elephant player 1
code(-1,"E2"). % elephant player 2
code(2,"R1"). % rat player 1
code(-2,"R2"). % rat player 2
code(3,"L1"). % lion player 1
code(-3,"L2"). % lion player 2
code(4,"GO"). % goal 

% Codes for board rows
row(0, 'A').
row(1, 'B').
row(2, 'C').
row(3, 'D').
row(4, 'E').
row(5, 'F').
row(6, 'G').
row(7, 'H').
row(8, 'I').
row(9, 'J').

% Lowercase letter Codes to be able to read from input in lowercase
row_lower(0, 'a').
row_lower(1, 'b').
row_lower(2, 'c').
row_lower(3, 'd').
row_lower(4, 'e').
row_lower(5, 'f').
row_lower(6, 'g').
row_lower(7, 'h').
row_lower(8, 'i').
row_lower(9, 'j').

print_code([H]):- put_code(H).
print_code([H|T]):- length([H|T],2),put_code(H), print_code(T).

/*print_line([H]):- write(H).
print_line([H|T]):- write(H), print_line(T).

% prints a board in the correct format
print_board([H]):- print_line(H), nl.
print_board([H|T]):- print_line(H), nl, print_board(T).
*/
print_board_middle_separator(1):-
  write('|\n').
print_board_middle_separator(X):-
  write('+ - '), X1 is X-1, print_board_middle_separator(X1).

% When the counter reaches 0, it ends
print_matrix([], 8, _).
print_matrix([L|T], N, X) :-
  row(N, R), code(1,P), write(' '), write(R), write(' | '),
  write('  |'),
  N1 is N + 1,
  print_line(L), nl,
  N < X - 1, write('---+   | - '), print_board_middle_separator(X),
  print_matrix(T, N1, X).
print_matrix(_, _, X):-
  write('---+   *---'),
  print_board_separator(X).

% Prints a line of the board
print_line([]).
print_line([C|L]) :-
  code(C, P),print_code(P), write(' |'),
  print_line(L).

print_header_numbers(Inicial, Inicial):-
  write('\n').
print_header_numbers(Inicial, Final):-
  write(' '), write(Inicial), write(' |'), N1 is Inicial + 1, print_header_numbers(N1, Final).

print_separator(0):-
  write('|\n').
print_separator(X):-    
  write('+---'), X1 is X-1, print_separator(X1).
  
print_line_codes(0, _):-
  write('\n').
print_line_codes(X, P):- 
    write('   '), X1 is X-1, print_line_codes(X1, P).

print_board_separator(1):-
  write('*\n').
print_board_separator(X):-
  write('+---'), X1 is X-1, print_board_separator(X1).

print_header(P, X):-
  write('       |'),
  print_header_numbers(0, X),
  write('       '),
  print_separator(X),
  write('         '), 
  print_line_codes(X, P),
  write('---+   *---'),
  print_board_separator(X).




display_game(GameState):-
    nth0(0,GameState,Board),
     nl, code(-1, P), print_header(P, 10),
    print_matrix(Board, 0, 10),
    write('       ').
   % print_board(Board).,
    %print_line_codes(10, P).
    %nth0(0,GameState,Board),

test:-
    initial(1,GameState),
    display_game(GameState).