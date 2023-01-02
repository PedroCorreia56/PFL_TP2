:- consult('display.pl').
:-use_module(library(lists)).

free_space(0).
free_space(9).



write_scared_piece(SR-SC):-
        row(SR,Row),
        column(SC,Column),
        write(Row),
        write(Column).

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
        can_move([Board,PlayerTurn],SR-SC-ER-EC,ScaredPiece),
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
can_move(GameState,SR-SC-ER-EC,ScaredPiece):-
        check_scared_board(GameState,ScaredPiece),
        nonvar(ScaredPiece),
        write('Need to move Piece in: '),
        write_scared_piece(ScaredPiece),nl,
        fail.

can_move([Board,PlayerTurn],SR-SC-ER-EC,ScaredPiece):-
        check_scared_board([Board,PlayerTurn],ScaredPiece),
        var(ScaredPiece),
        nth0(SR,Board,Line),
        nth0(SC,Line,StartElem),
        StartElem\=0,
        check_elem(StartElem,PlayerTurn),
        nth0(ER,Board,EndLine),
        nth0(EC,Line,EndElem),
        StartElem\=EndElem,
        free_space(EndElem).

 
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


check_scared_line(C,L,[Board,PlayerTurn],ScaredPiece):-
        C=<9,
        L=<9,
        var(ScaredPiece),
        \+check_not_scared_elem(C,L,Board,PlayerTurn),
        nth0(L,Board,Line),
        nth0(C,Line,Elem),
        Elem\=0,
        check_elem(Elem,PlayerTurn),
        ScaredPiece=L-C.






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
        move([Board,PlayerTurn],9-4-9-3,NewGameState).

teste6:-
        initial(1,[Board,PlayerTurn]),
        can_move([Board,PlayerTurn],9-4-9-4,ScaredPiece),
        write(ScaredPiece),nl.
        
teste7:-
        initial(1,[Board,PlayerTurn]),
        write(Board),nl,
        replace_m_n(Board, 9, 9, -3, N), write('depois de substituir'), nl, write(N).

