:- consult('display.pl').
:-use_module(library(lists)).

free_space(0).
free_space(9).



% abs(+X,-AX)
% returns the absolute value of X
% had to make one because the one in the library was not working.
abs(X,X):-X>0.
abs(X,AX):- X=<0, AX is 0-X.


write_scared_piece(SR-SC):-
        row(SR,Row),
        column(SC,Column),
        write(Row),
        write(Column).

compare_scare_piece(X-Y,SR,SC):-
        write('X: '),
        write(X),nl,
        write('Y: '),
        write(Y),nl,
        write('SR: '),
        write(SR),nl,
        write('SC: '),
        write(SC),nl,
        X=:=SR,
        Y=:=SC.


piece_original_value(1,1).
piece_original_value(2,2).
piece_original_value(3,3).
piece_original_value(-1,-1).
piece_original_value(-2,-2).
piece_original_value(-3,-3).
piece_original_value(10,1).
piece_original_value(11,2).
piece_original_value(12,3).
piece_original_value(8,-1).
piece_original_value(7,-2).
piece_original_value(6,-3).

% Used to help checking the piece movement ignoring the player turn
piece_value_helper(1,1).
piece_value_helper(2,2).
piece_value_helper(3,3).
piece_value_helper(-1,1).
piece_value_helper(-2,2).
piece_value_helper(-3,3).
piece_value_helper(10,1).
piece_value_helper(11,2).
piece_value_helper(12,3).
piece_value_helper(8,1).
piece_value_helper(7,2).
piece_value_helper(6,3).

% check_elem(+Elem,+PlayerTurn)
% check if the element is the same as the player turn
check_elem(Elem,1):-
        Elem\=9,
        Elem\=9+(-1),
        Elem\=9+(-2),
        Elem\=9+(-3),
        Elem\=(-1),
        Elem\=(-2),
        Elem\=(-3).

check_elem(Elem,2):-
        Elem\=9,
        Elem\=9+1,
        Elem\=9+2,
        Elem\=9+3,
        Elem\=1,
        Elem\=2,
        Elem\=3.

change_turn(2,1).
change_turn(1,2).
/**
 * replace_m_n(+Board, +L, +C, +Player, -NewBoard)
 * 
 * put a new piece in line L and Colunm C of Board
 */
replace_m_n(Board, L, C, Player, NewBoard) :-
    replace_nth(L, Old1, New1, Board, NewBoard),
    replace_nth(C, _OldElem2, Player, Old1, New1).

/**
 * replace_nth(+N, -OldElem, +Player, +List, -List2)
 *
 * replaces an element of a list. Will be auxiliar to function replace_m_n
 */
replace_nth(N, OldElem, Player, List, List2) :-
    length(L1, N),
    append(L1, [OldElem|Rest], List),
    append(L1, [Player|Rest], List2). 




% move(+GameState,?Move,?NewGameState)
%
% Executes a move using a game state and returning a new state.
% A move has the form CurrentPosition-NewPosition
% A positon has the form Column-Row.
move([Board,PlayerTurn],SR-SC-ER-EC,[NewBoard,NewPlayerTurn]):-
        write('Befre can move'),nl,
        can_move([Board,PlayerTurn],SR-SC-ER-EC),
        nth0(SR,Board,Line),
        nth0(SC,Line,StartElem),
        nth0(ER,Board,EndLine),
        nth0(EC,Line,EndElem),
        piece_original_value(StartElem,Temp),
        NewEndElem is EndElem +Temp,
        NewStartElem is StartElem-Temp,
        replace_m_n(Board,SR,SC,NewStartElem,TempBoard),
        replace_m_n(TempBoard,ER,EC,NewEndElem,NewBoard), 
        change_turn(PlayerTurn,NewPlayerTurn).

% can_move(+GameState,?Move)
%
% Checks if a move is valid in the current game state.
can_move(GameState,SR-SC-ER-EC):-
        write('Before check scared board'),nl,
        check_scared_board(GameState,ScaredPiece),
        write('After check scared board'),nl,
        write('ScaredPiece: '),
        write_scared_piece(ScaredPiece),nl,
        nonvar(ScaredPiece),
        \+compare_scare_piece(ScaredPiece,SR,SC),
        write('Need to move Piece in: '),
        write_scared_piece(ScaredPiece),nl,
        fail.



% ScR-ScC is the position of the scared piece
can_move([Board,PlayerTurn],SR-SC-ER-EC):-
        check_scared_board([Board,PlayerTurn],ScaredPiece),
        (nonvar(ScaredPiece)->compare_scare_piece(ScaredPiece,SR,SC);true),
        nth0(SR,Board,Line),
        nth0(SC,Line,StartElem),
        StartElem\=0,
        check_elem(StartElem,PlayerTurn),
        nth0(ER,Board,EndLine),
        nth0(EC,EndLine,EndElem),
        StartElem\=EndElem,
        free_space(EndElem),
        piece_value_helper(StartElem,Temp),
        piece_movement(Temp,Board,SR-SC-ER-EC).

% Direita-> RowInd =:= 0, ColInd =< -1
% Esquerda-> RowInd =:= 0, ColInd >= 1
% Cima-> RowInd =< -1, ColInd =:= 0
% Baixo-> RowInd >= 1, ColInd =:= 0

% check_clear_path(+Piece,+Board,+RowInd,+ColInd,+StartRow-StartCol-EndRow-EndCol)
% check if therer aren't any pieces in the path of the piece
% This one is left  horizontal movement
check_clear_path(2,Board,RowInd,ColInd,SR-SC-ER-EC):-
        RowInd =:= 0,
        ColInd >=  1,
        nth0(SR,Board,Line),
        NextCol is SC+(-1),
        nth0(NextCol,Line,Elem),
        free_space(Elem),
        NewColInd is ColInd+(-1),
        check_clear_path(2,Board,RowInd,NewColInd,SR-NextCol-ER-EC).
        
% This one is right horizontal movement
check_clear_path(2,Board,RowInd,ColInd,SR-SC-ER-EC):-
        RowInd =:= 0,
        ColInd =< -1,
        nth0(SR,Board,Line),
        NextCol is SC+1,
        nth0(NextCol,Line,Elem),
        free_space(Elem),
        NewColInd is ColInd+1,
        check_clear_path(2,Board,RowInd,NewColInd,SR-NextCol-ER-EC).

% This one is up vertical movement
check_clear_path(2,Board,RowInd,ColInd,SR-SC-ER-EC):-
        RowInd =< -1,
        ColInd =:=0,
        NextLine is SR+(-1),
        nth0(NextLine,Board,Line),
        nth0(SC,Line,Elem),
        free_space(Elem),
        NewRowInd is RowInd+1,
        check_clear_path(2,Board,NewRowInd,ColInd,NextLine-SC-ER-EC).
        

% This one is down vertical movement
check_clear_path(2,Board,RowInd,ColInd,SR-SC-ER-EC):-
        RowInd >= 1,
        ColInd =:=0,
        NextLine is SR+1,
        nth0(NextLine,Board,Line),
        nth0(SC,Line,Elem),
        free_space(Elem),
        NewRowInd is RowInd-1,
        check_clear_path(2,Board,NewRowInd,ColInd,NextLine-SC-ER-EC).


% Diagonal cima direita: 9-8 -> 8-9: RowInd >= 1, ColInd =< -1
% Diagonal cima esquerda: 9-9-> 8-8: RowInd >= 1, ColInd >= 1
% Diagonal baixo direita: 8-8 -> 9-9: RowInd =< -1, ColInd =< -1
% Diagonal baixo esquerda: 8-8 -> 9-7: RowInd =< -1, ColInd >= 1


% This one is diagonal down right movement, ex: 8-8 -> 9-9
check_clear_path(3,Board,RowInd,ColInd,SR-SC-ER-EC):-
        RowInd =< -1,
        ColInd =< -1,
        NextLine is SR+1,
        NextCol is SC+1,
        nth0(NextLine,Board,Line),
        nth0(NextCol,Line,Elem),
        free_space(Elem),
        NewRowInd is RowInd+1,
        NewColInd is ColInd+1,
        check_clear_path(3,Board,NewRowInd,NewColInd,NextLine-NextCol-ER-EC).

% This one is diagonal down left movement, ex: 8-8 -> 9-7
check_clear_path(3,Board,RowInd,ColInd,SR-SC-ER-EC):-
        RowInd =< -1,
        ColInd >= 1,
        NextLine is SR+1,
        NextCol is SC+(-1),
        nth0(NextLine,Board,Line),
        nth0(NextCol,Line,Elem),
        free_space(Elem),
        NewRowInd is RowInd+1,
        NewColInd is ColInd-1,
        check_clear_path(3,Board,NewRowInd,NewColInd,NextLine-NextCol-ER-EC).

% This one is diagonal up right movement,, ex: 9-8 -> 8-9
check_clear_path(3,Board,RowInd,ColInd,SR-SC-ER-EC):-
        RowInd >= 1,
        ColInd =< -1,
        NewtLine is SR+(-1),
        NextCol is SC+1,
        nth0(NewtLine,Board,Line),
        nth0(NextCol,Line,Elem),
        free_space(Elem),
        NewRowInd is RowInd-1,
        NewColInd is ColInd+1,
        check_clear_path(3,Board,NewRowInd,NewColInd,NewtLine-NextCol-ER-EC).

% This one is diagonal up left movement, ex: 9-9 -> 8-8
check_clear_path(3,Board,RowInd,ColInd,SR-SC-ER-EC):-
        RowInd >= 1,
        ColInd >= 1,
        NextLine is SR+(-1),
        NextCol is SC+(-1),
        nth0(NextLine,Board,Line),
        nth0(NextCol,Line,Elem),
        free_space(Elem),
        NewRowInd is RowInd-1,
        NewColInd is ColInd-1,
        check_clear_path(3,Board,NewRowInd,NewColInd,NextLine-NextCol-ER-EC).

% This one is the base case
check_clear_path(_,_,0,0,_).

% piece_movement(+Type,+Board,+StartRow-StartColumn-EndRow-EndColumn)
% checks if the piece can move to the desired position
% This is the case for the lion that can only move diagonally
piece_movement(3,Board,SR-SC-ER-EC):-
        ColumnDiff is SC-EC,
        RowDiff is SR-ER,
        abs(ColumnDiff,AColumnDiff),
        abs(RowDiff,ARowDiff),
        AColumnDiff=:=ARowDiff,
        check_clear_path(3,Board,RowDiff,ColumnDiff,SR-SC-ER-EC).

% This is the case for the rat that can only move vertically or horizontally
piece_movement(2,Board,SR-SC-ER-EC):-
        RowInd is SR-ER,
        ColInd is SC-EC,
        SR=:=ER;SC=:=EC,
        check_clear_path(2,Board,RowInd,ColInd,SR-SC-ER-EC).
        

% This is the case for the elephant that can move in any direction
piece_movement(1,Board,SR-SC-ER-EC):-
        ColumnDiff is SC-EC,
        RowDiff is SR-ER,
        abs(ColumnDiff,AColumnDiff),
        abs(RowDiff,ARowDiff),
        AColumnDiff=:=ARowDiff;SR=:=ER;SC=:=EC,
        check_clear_path(2,Board,RowDiff,ColumnDiff,SR-SC-ER-EC); 
        check_clear_path(3,Board,RowDiff,ColumnDiff,SR-SC-ER-EC).

% check_scared_board(+GameState,+LineToCheck,-ScaredPiece)
% check if any piece is near a piec they are scared of
check_scared_board(GameState,ScaredPiece):-
        check_scared_line(0,0,GameState,ScaredPiece).




% check_not_scared_elem(+ColumnNumber,+LineN,+PlayerTurn,-ScaredPiece)
% check if any piece is near a piec they are scared of and returns the piece if it is
% Case for the first element of the first line
check_not_scared_elem(0,0,Board,PlayerTurn):-
        nth0(0,Board,Line),
        nth0(0,Line,Elem),
        check_elem(Elem,PlayerTurn),
        scared_of(Elem,Scared), 
        ElemRightNumber is 0+1,
        nth0(ElemRightNumber,Line,Elemright),
        Elemright\=Scared,
        Elemright\=9+Scared,
       
        nth0(ElemRightNumber,Board,Linebellow),
        nth0(0,Linebellow,Elembellow),
        Elembellow\=Scared,
        Elembellow\=9+Scared,
        nth0(ElemRightNumber,Linebellow,Elemrightdiagonal),
        Elemrightdiagonal\=Scared,
        Elemrightdiagonal\=9+Scared.
        %Next_Elem is 0+1,
        %check_not_scared_elem(Next_Elem,0,Board,PlredPiece).

% Case for the last element of the first line
check_not_scared_elem(9,0,Board,PlayerTurn):-
        nth0(0,Board,Line),
        nth0(9,Line,Elem),
        check_elem(Elem,PlayerTurn),
        scared_of(Elem,Scared), 
        ElemLeftNumber is 9-1,
        LinebellowNumber is 0+1,
        nth0(ElemLeftNumber,Line,Elemleft),
        Elemleft\=Scared,
        Elemleft\=9+Scared,
        nth0(LinebellowNumber,Board,Linebellow),
        nth0(9,Linebellow,Elembellow),
        Elembellow\=Scared,
        Elembellow\=9+Scared,
        nth0(ElemLeftNumber,Linebellow,Elemleftdiagonal),
        Elemleftdiagonal\=Scared,
        Elemleftdiagonal\=9+Scared.
      %  check_not_scared_elem(0,1,Board,PlayerTurn).

%  Case for elements between the first and the last of the first line
check_not_scared_elem(ColumnNumber,0,Board,PlayerTurn):-
        nonvar(ColumnNumber),
        ColumnNumber\=0,
        ColumnNumber\=9,
        nth0(0,Board,Line),
        nth0(ColumnNumber,Line,Elem),
        check_elem(Elem,PlayerTurn),
        scared_of(Elem,Scared),
        ElemRightNumber is ColumnNumber+1,
        ElemLeftNumber is ColumnNumber-1,
        nth0(ElemRightNumber,Line,Elemright),
        Elemright\=Scared,
        Elemright\=9+Scared,
        nth0(ElemLeftNumber,Line,Elemleft),
        Elemleft\=Scared,
        Elemleft\=9+Scared,
        nth0(1,Board,Linebellow),
        nth0(ColumnNumber,Linebellow,Elembellow),
        Elembellow\=Scared,
        Elembellow\=9+Scared,
        nth0(ElemRightNumber,Linebellow,Elemrightdiagonal),
        Elemrightdiagonal\=Scared,
        Elemrightdiagonal\=9+Scared,
        nth0(ElemLeftNumber,Linebellow,Elemleftdiagonal),
        Elemleftdiagonal\=Scared,
        Elemleftdiagonal\=9+Scared.
       % Next_Elem is 0+1,
        %check_not_scared_elem(Next_Elem,0,Board,PlredPiece).

% Case for the first element of the last line
check_not_scared_elem(0,9,Board,PlayerTurn):-
        nth0(9,Board,Line),
        nth0(0,Line,Elem),
        check_elem(Elem,PlayerTurn),
        scared_of(Elem,Scared),
        ElemRightNumber is 0+1,
        LineaboveNumber is 9-1,
        nth0(ElemRightNumber,Line,Elemright),
        Elemright\=Scared,
        Elemright\=9+Scared,
        nth0(LineaboveNumber,Board,Lineabove),
        nth0(0,Lineabove,Elemabove),
        Elemabove\=Scared,
        Elemabove\=9+Scared,
        nth0(ElemRightNumber,Lineabove,Elemrightdiagonal),
        Elemrightdiagonal\=Scared,
        Elemrightdiagonal\=9+Scared.
       % Next_Elem is 0+1,
       % check_not_scared_elem(Next_Elem,9,Board,PlredPiece).

% Case for elements between the first and the last of the last line
check_not_scared_elem(ColumnNumber,9,Board,PlayerTurn):-
        nonvar(ColumnNumber),
        ColumnNumber\=0,
        ColumnNumber\=9,
        nth0(9,Board,Line),
        nth0(ColumnNumber,Line,Elem),
    
        check_elem(Elem,PlayerTurn),
      
        scared_of(Elem,Scared), 
        ElemRightNumber is ColumnNumber+1,      
        ElemLeftNumber is ColumnNumber-1,
        LineaboveNumber is 9-1,
     

        nth0(ElemRightNumber,Line,Elemright),

        Elemright\=Scared,
        Elemright\=9+Scared,
        nth0(ElemLeftNumber,Line,Elemleft),
       
        Elemleft\=Scared,
        Elemleft\=9+Scared,
        nth0(LineaboveNumber,Board,Lineabove),
        nth0(ColumnNumber,Lineabove,Elemabove),
     
        Elemabove\=Scared,
        Elemabove\=9+Scared,
        nth0(ElemRightNumber,Lineabove,Elemrightdiagonal),

        Elemrightdiagonal\=Scared,
        Elemrightdiagonal\=9+Scared,
        nth0(ElemLeftNumber,Lineabove,Elemleftdiagonal),

        Elemleftdiagonal\=Scared,
        Elemleftdiagonal\=9+Scared.
      
        
% Case for the last element of the last line
check_not_scared_elem(9,9,Board,PlayerTurn):-

        nth0(9,Board,Line),
        nth0(9,Line,Elem),
 
        check_elem(Elem,PlayerTurn),
 
        scared_of(Elem,Scared), 
        ElemLeftNumber is 9-1,
        nth0(ElemLeftNumber,Line,Elemleft),

        Elemleft\=Scared,
        Elemleft\=9+Scared,
        nth0(8,Board,Lineabove),
        nth0(9,Lineabove,Elemabove),

        Elemabove\=Scared,
        Elemabove\=9+Scared,
        nth0(ElemLeftNumber,Lineabove,Elemleftdiagonal),
         
        Elemleftdiagonal\=Scared,
        Elemleftdiagonal\=9+Scared.

    
% Case for the first element of the other lines
check_not_scared_elem(0,LineNumber,Board,PlayerTurn):-
        nonvar(LineNumber),
        LineNumber\=0,
        LineNumber\=9,
        nth0(LineNumber,Board,Line),
        nth0(0,Line,Elem),
        check_elem(Elem,PlayerTurn),
        scared_of(Elem,Scared),
        ElemRightNumber is 0+1,
        LineaboveNumber is LineNumber-1,
        LinebellowNumber is LineNumber+1,
        nth0(ElemRightNumber,Line,Elemright),
        Elemright\=Scared,
        Elemright\=9+Scared,
        nth0(LinebellowNumber,Board,Linebellow),
        nth0(0,Linebellow,Elembellow),
        Elembellow\=Scared,
        Elembellow\=9+Scared,
        nth0(ElemRightNumber,Linebellow,Elemrightdiagonalbellow),
        Elemrightdiagonalbellow\=Scared,
        Elemrightdiagonalbellow\=9+Scared,
        nth0(LineaboveNumber,Board,Lineabove),
        nth0(0,Lineabove,Elemabove),
        Elemabove\=Scared,
        Elemabove\=9+Scared,
        nth0(ElemRightNumber,Lineabove,Elemrightdiagonalabove),
        Elemrightdiagonalabove\=Scared,
        Elemrightdiagonalabove\=9+Scared.
      %  Next_Elem is 0+1,
      %  check_not_scared_elem(Next_Elem,LineNumberrTurn,ScaredPiece).

% Case for the last element of the other lines
check_not_scared_elem(9,LineNumber,Board,PlayerTurn):-
        nonvar(LineNumber),
        LineNumber\=0,
        LineNumber\=9,
        nth0(LineNumber,Board,Line),
        nth0(9,Line,Elem),
        check_elem(Elem,PlayerTurn),
        scared_of(Elem,Scared),
        ElemLeftNumber is 9-1,
        LineaboveNumber is LineNumber-1,
        LinebellowNumber is LineNumber+1,
        nth0(ElemLeftNumber,Line,Elemleft),
        Elemleft\=Scared,
        Elemleft\=9+Scared,
        nth0(LinebellowNumber,Board,Linebellow),
        nth0(9,Linebellow,Elembellow),
        Elembellow\=Scared,
        Elembellow\=9+Scared,
        nth0(ElemLeftNumber,Linebellow,Elemleftdiagonalbellow),
        Elemleftdiagonalbellow\=Scared,
        Elemleftdiagonalbellow\=9+Scared,
        nth0(LineaboveNumber,Board,Lineabove),
        nth0(9,Lineabove,Elemabove),
        Elemabove\=Scared,
        Elemabove\=9+Scared,
        nth0(ElemLeftNumber,Lineabove,Elemleftdiagonalabove),
        Elemleftdiagonalabove\=Scared,
        Elemleftdiagonalabove\=9+Scared.
       % check_not_scared_elem(0,LinebellowNumber,Burn,ScaredPiece).

% Case for elements between the first and the last of the other lines
check_not_scared_elem(ColumnNumber,LineNumber,Board,PlayerTurn):-
        nonvar(LineNumber),
        nonvar(ColumnNumber),
        ColumnNumber\=0,
        ColumnNumber\=9,
        LineNumber\=0,
        LineNumber\=9,
        nth0(LineNumber,Board,Line),
        nth0(ColumnNumber,Line,Elem),
        check_elem(Elem,PlayerTurn),
        scared_of(Elem,Scared),

        ElemRightNumber is ColumnNumber+1,
        ElemLeftNumber is ColumnNumber-1,
        LineaboveNumber is LineNumber-1,
        LinebellowNumber is LineNumber+1,
        nth0(ElemRightNumber,Line,Elemright),

        Elemright\=Scared,
        Elemright\=9+Scared,
        nth0(ElemLeftNumber,Line,Elemleft),
 
        Elemleft\=Scared,
        Elemleft\=9+Scared,
        nth0(LinebellowNumber,Board,Linebellow),
        nth0(ColumnNumber,Linebellow,Elembellow),
 
        Elembellow\=Scared,
        Elembellow\=9+Scared,
        nth0(ElemRightNumber,Linebellow,Elemrightdiagonalbellow),
   
        Elemrightdiagonalbellow\=Scared,
        Elemrightdiagonalbellow\=9+Scared,
        nth0(ElemLeftNumber,Linebellow,Elemleftdiagonalbellow),
  
        Elemleftdiagonalbellow\=Scared,
        Elemleftdiagonalbellow\=9+Scared,
        nth0(LineaboveNumber,Board,Lineabove),
        nth0(ColumnNumber,Lineabove,Elemabove),
  
        Elemabove\=Scared,
        Elemabove\=9+Scared,
        nth0(ElemRightNumber,Lineabove,Elemrightdiagonalabove),
 
        Elemrightdiagonalabove\=Scared,
        Elemrightdiagonalabove\=9+Scared,
        nth0(ElemLeftNumber,Lineabove,Elemleftdiagonalabove),
    
        Elemleftdiagonalabove\=Scared,
        Elemleftdiagonalabove\=9+Scared.
     %   Next_Elem is ColumnNumber+1,
      %  check_not_scared_elem(Next_Elem,LineNumberrTurn,ScaredPiece).




check_scared_line(9,9,[Board,PlayerTurn],ScaredPiece):-
        check_not_scared_elem(9,9,Board,PlayerTurn),
        var(ScaredPiece).

check_scared_line(ElemNumber,LineNumber,[Board,PlayerTurn],ScaredPiece):-
     %   write('1 ElemNumber: '),write(ElemNumber),nl,
      %  write('1 LineNumber: '),write(LineNumber),nl,
        LineNumber\=10,
        \+check_not_scared_elem(ElemNumber,LineNumber,Board,PlayerTurn),
        var(ScaredPiece),   
        (ElemNumber =:= 9 -> 
        Next_Elem is 0,Next_Line is LineNumber+1;
        Next_Elem is ElemNumber+1,Next_Line is LineNumber),
        check_scared_line(Next_Elem,Next_Line,[Board,PlayerTurn],ScaredPiece).

check_scared_line(ElemNumber,LineNumber,[Board,PlayerTurn],ScaredPiece):-
        %write('2 ElemNumber: '),write(ElemNumber),nl,
       % write('2 LineNumber: '),write(LineNumber),nl,
        LineNumber\=10,
        check_not_scared_elem(ElemNumber,LineNumber,Board,PlayerTurn),
        var(ScaredPiece),   
        (ElemNumber =:= 9 -> 
        Next_Elem is 0,Next_Line is LineNumber+1;
        Next_Elem is ElemNumber+1,Next_Line is LineNumber),
        check_scared_line(Next_Elem,Next_Line,[Board,PlayerTurn],ScaredPiece).


check_scared_line(C,L,[Board,PlayerTurn],ScR-ScC):-
        C=<9,
        L=<9,
        var(ScaredPiece),
        \+check_not_scared_elem(C,L,Board,PlayerTurn),
        nth0(L,Board,Line),
        nth0(C,Line,Elem),
        Elem\=0,
        check_elem(Elem,PlayerTurn),
        ScR is L,
        ScC is C.






testee:-
        initial(1,[Board,PlayerTurn]),
        \+check_scared_line(0,9,[Board,PlayerTurn],0),
        nl,
        write(ScaredPiece).

teste2:-   
        initial(1,[Board,PlayerTurn]),
        check_scared_line(0,0,[Board,1],ScaredPiece),
        var(ScaredPiece).

teste3:-
        initial(1,[Board,PlayerTurn]),
        check_scared_line(0,0,[Board,1],ScaredPiece),
        nonvar(ScaredPiece),nl,write(ScaredPiece),nl.



teste4:-
        initial(1,[Board,PlayerTurn]),
        findall(ScaredPiece,(\+check_scared_line(_,_,[Board,PlayerTurn],ScaredPiece)),List),
        write(ScaredPiece),
        write(List).
teste5:-
        initial(1,[Board,PlayerTurn]),
        move([Board,PlayerTurn],9-9-9-7,NewGameState).

teste6:-
        initial(1,[Board,PlayerTurn]),
        can_move([Board,PlayerTurn],9-4-9-4,ScaredPiece),
        write(ScaredPiece),nl.
        
teste7:-
        initial(1,[Board,PlayerTurn]),
        write(Board),nl,
        replace_m_n(Board, 9, 9, -3, N), write('depois de substituir'), nl, write(N).


testemove:-
        initial(1,[Board,PlayerTurn]),
        piece_movement(2,Board,8-4-7-4).

testetrymove:-
        initial(1,[Board,PlayerTurn]),
        try_move([Board,PlayerTurn],8-5-7-5,NewGameState).
        
        % piece_movement(3,Board,SR-SC-ER-EC):-
testecheck1:-
        initial(1,[Board,PlayerTurn]),
        %can only move left from 9-4
        write('Left movement'),nl,
        piece_movement(1,Board,9-4-9-2),
        write('Passed Left movement'),nl,
        % cant move right from 9-4
        write('Right movement'),nl,
        \+piece_movement(1,Board,9-4-9-8),
        write('Passed Right movement'),nl,
        % cant move up from 9-4
        write('Denied Up movement'),nl,
        \+piece_movement(1,Board,9-4-7-4),
        write('Passed Denied Up movement'),nl,
        % cant move diagonally from 9-4
        write('Denied Diagonal movement'),nl,
        \+piece_movement(1,Board,9-4-7-2),
        write('Passed Denied Diagonal movement up left'),nl,
        \+piece_movement(1,Board,9-4-7-6),
        write('Passed Denied Diagonal movement up right'),nl.

testecheck2:-
        initial(1,[Board,PlayerTurn]),
        % can only move up from 8-4
        write('Up movemnt'),nl,
        piece_movement(2,Board,8-4-6-4).
        write(' PASSED Up movemnt'),nl,
        % cant move down from 8-4
        write('Denied Down movemnt'),nl,
        \+piece_movement(2,Board,8-4-9-4).
        write(' PASSED Denied Down movemnt'),nl.
        write('Denied Left movement'),nl,
        \+piece_movement(2,Board,8-4-8-2).
        write(' PASSED Denied Left movement'),nl.
        write('Denied Right movement'),nl,
        \+piece_movement(2,Board,8-4-8-6).
        write(' PASSED Denied Right movement'),nl,
        write('Denied Diagonal up left movement'),nl,
        \+piece_movement(2,Board,8-4-6-2).
        write(' PASSED Denied Diagonal up left movement'),nl,
        write('Denied Diagonal up right movement'),nl,
        \+piece_movement(2,Board,8-4-6-6).
        write(' PASSED Denied Diagonal up right movement'),nl.
        write('Denied Diagonal down left movement'),nl,
        \+piece_movement(2,Board,8-4-9-3).
        write(' PASSED Denied Diagonal down left movement'),nl,

testecheck22:-
        initial(1,[Board,PlayerTurn]),
        % can only move up from 8-4
        write('Up movemnt'),nl,
        piece_movement(2,Board,8-4-6-4).
        write(' PASSED Up movemnt'),nl,
        write('down movement'),nl,
        piece_movement(2,Board,2-4-4-4),
        write(' PASSED down movement'),nl,
        write('Right movement'),nl,
        piece_movement(2,Board,4-4-4-6),
        write(' PASSED Right movement'),nl,
        write('Left movement'),nl,
        piece_movement(2,Board,4-6-4-4),
        write(' PASSED Left movement'),nl.  

testecheck3:-
        initial(1,[Board,PlayerTurn]),
        write('Diag down right'),nl,
        \+piece_movement(3,Board,0-2-2-4),
        write('PASSED denied Diag down right'),nl,
        write('Diag down left'),nl,
        \+piece_movement(3,Board,0-7-2-5),
        write('PASSED denied Diag down left'),nl,
        write('Diag up left'),nl,
        \+piece_movement(3,Board,2-4-0-2),
        write('PASSED denied Diag up left'),nl,
        write('Diag up right'),nl,
        \+piece_movement(3,Board,2-5-0-7),
        write('PASSED denied Diag up right'),nl.

testecheck4:-
        initial(1,[Board,PlayerTurn]),
        write('Diag down left'),nl,
        piece_movement(3,Board,0-8-4-4),
        write('PASSED Diag down left'),nl,
        write('Diag down right'),nl,
        piece_movement(3,Board,0-1-4-5),
        write('PASSED Diag down right'),nl,
        write('Diag up left'),nl,
        piece_movement(3,Board,4-5-0-1),
        write('PASSED Diag up left'),nl,
        write('Diag up right'),nl,
        piece_movement(3,Board,0-8-4-4),
        write('PASSED Diag up right'),nl.