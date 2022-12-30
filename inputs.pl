:- consult('display.pl').

%Ascii code for the hifen
code_number_hifen(45, "-").
% ASCII code and respective decimal number
code_number(48, "0").
code_number(49, "1").
code_number(50, "2").
code_number(51, "3").
code_number(52, "4").
code_number(53, "5").
code_number(54, "6").
code_number(55, "7").
code_number(56, "8").
code_number(57, "9").


%ASCII code and respective lower-case letter
code_letter(65, "a").
code_letter(66, "b").
code_letter(67, "c").
code_letter(68, "d").
code_letter(69, "e").
code_letter(70, "f").
code_letter(71, "g").
code_letter(72, "h").
code_letter(73, "i").
code_letter(74, "j").
%ASCII code and respective upper-case letter
code_letter(97, "A").
code_letter(98, "B").
code_letter(99, "C").
code_letter(100, "D").
code_letter(101, "E").
code_letter(102, "F").
code_letter(103, "G").
code_letter(104, "H").
code_letter(105, "I").
code_letter(106, "J").


% read_number(+LowerBound,+UpperBound,-Number)
%used in menus to read inputs between the Lower and Upper Bounds
read_number(LowerBound,UpperBound,Number) :-
    format('| Choose an Option (~d-~d) - ', [LowerBound, UpperBound]),
    get_code(NumberASCII),
    peek_char(Char),
    Char == '\n',
    code_number(NumberASCII, Number),
    Number =< UpperBound, Number >= LowerBound, skip_line.
% If the input is invalid
read_number(LowerBound, UpperBound, Number):-
    write('Not a valid number, try again\n'), skip_line,
    read_number(LowerBound, UpperBound, Number).


% read_move(+GameState,-Move)
%
% Reads a Move with valid notation input and parses it. 
%
% @param GameState The current game state
% @param Move with valid notation
read_move([Board,PlayerTurn],Move):-
    read_move_aux(X),
    (parse_move(X,Board,Move)->!;write('Invalid move, try again\n'),read_move([Board,PlayerTurn],Move)).

% check_code(+Code,+Len,-Char)
% Checks if the code is valid and returns the respective char
check_code(X,0,Char):-
    code_letter(X,Char).
check_code(X,2,Char):-
    code_number_hifen(X,Char).
check_code(X,3,Char):-
    code_letter(X,Char).
check_code(X,Len,Char):-
    Len \=0,
    Len \=2,
    Len \=3,
    code_number(X,Char).

% read_move_aux(-MoveString)
read_move_aux(X):-
    read_move_aux2("",false,X).

% read_move_aux2(+Acc,+Flag,-MoveString)
% Flag is true if we have a valid move
% Moves are valid if they are like: a2-b2
read_move_aux2(Acc,_,X):-
    length(Acc,Len),
    Len <5,
    get_code(C),   % queremos testar se o C tem um código ASCII para um digito
    check_code(C,Len,Char),
    !,
    append(Acc,Char,Acc1),
    read_move_aux2(Acc1,true,X). % Se chegar aqui é porque temos um digito
read_move_aux2(X,true,X).


% column(+Column,+CharCode)
% Checks if the column is valid
check_row(Row,CharCode):-
    row(Row,CharCode).
check_row(Row,CharCode):-
    row_lower(Row,CharCode).
    
%parse_move(+MoveString,+Board,?Move)
%
% Parses the move string to a game move
% Where SR-SC-ER-EC are the start and end row and column
parse_move(X,Board,SR-SC-ER-EC):-
    length(X,Len),
    Len =:= 5,
    nth0(0,X,Srr),
    char_code(R,Srr),
    check_row(SR,R),
    nth0(1,X,Scc),
    char_code(C,Scc),
    column(SC,C),
    nth0(3,X,Err),
    char_code(Re,Err),
    check_row(ER,Re),
    nth0(4,X,ECc),
    char_code(D,ECc),
    column(EC,D).
 
    
    
   
