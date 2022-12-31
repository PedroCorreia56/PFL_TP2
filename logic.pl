:- consult('display.pl').



% move(+GameState,?Move,?NewGameState)
%
% Executes a move using a game state and returning a new state.
% A move has the form CurrentPosition-NewPosition
% A positon has the form Column-Row.
move([Board,PlayerTurn],SR-SC-ER-EC,[NewBoard,NewPlayerTurn]):-
    can_move([Board,PlayerTurn],SR-SC-ER-EC).

% can_move(+GameState,?Move)
%
% Checks if a move is valid in the current game state.
can_move([Board,PlayerTurn],SR-SC-ER-EC):-
    nth0_nested(SC,SR,Board,Player).
  %  nth0_nested(ER,EC,Board,Player),
    

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

% check_not_scared_elem(+ColumnNumber,+LineN,+PlayerTurn,-ScaredPiece)
% check if any piece is near a piec they are scared of and returns the piece if it is
% Case for the first element of the first line
check_not_scared_elem(0,0,Board,PlayerTurn):-
        nth0(0,Board,Line),
        nth0(0,Line,Elem),
        check_elem(Elem,PlayerTurn),
        scared_of(Elem,Scared), 
        ElemRightNumber=0+1,
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
        write('Outros numeor'),nl,
        write('ColumnNumber:'),
        write(ColumnNumber),nl,
        ColumnNumber\=0,
        ColumnNumber\=9,
        nth0(9,Board,Line),
        nth0(ColumnNumber,Line,Elem),
        write('Before check elem'),nl,
        check_elem(Elem,PlayerTurn),
        write('After check elem'),nl,
        scared_of(Elem,Scared), 
        ElemRightNumber is ColumnNumber+1,      
        ElemLeftNumber is ColumnNumber-1,
        LineaboveNumber is 9-1,
        write('In function check scared elem'),nl,
        write('Elem:'),write(Elem),nl,
        nth0(ElemRightNumber,Line,Elemright),
        write('Elem righht:'),write(Elemright),nl,
        Elemright\=Scared,
        Elemright\=9+Scared,
        nth0(ElemLeftNumber,Line,Elemleft),
         write('Elem left:'),write(Elemleft),nl,
        Elemleft\=Scared,
        Elemleft\=9+Scared,
        nth0(LineaboveNumber,Board,Lineabove),
        nth0(ColumnNumber,Lineabove,Elemabove),
         write('Elem above:'),write(Elemabove),nl,
        Elemabove\=Scared,
        Elemabove\=9+Scared,
        nth0(ElemRightNumber,Lineabove,Elemrightdiagonal),
         write('Elem right above:'),write(Elemrightdiagonal),nl,
        Elemrightdiagonal\=Scared,
        Elemrightdiagonal\=9+Scared,
        nth0(ElemLeftNumber,Lineabove,Elemleftdiagonal),
            write('Elem left above:'),write(Elemleftdiagonal),nl,
        Elemleftdiagonal\=Scared,
        Elemleftdiagonal\=9+Scared,
        write('End of function check scared elem'),nl.
        
% Case for the last element of the last line
check_not_scared_elem(9,9,Board,PlayerTurn):-
        write('Ultimo numero(9)'),nl,
        nth0(9,Board,Line),
        nth0(9,Line,Elem),
         write('Before check elem'),nl,
        check_elem(Elem,PlayerTurn),
          write('After check elem'),nl,
        scared_of(Elem,Scared), 
        ElemLeftNumber is 9-1,
        nth0(ElemLeftNumber,Line,Elemleft),
         write('Elem left:'),write(Elemleft),nl,
        Elemleft\=Scared,
        Elemleft\=9+Scared,
        nth0(8,Board,Lineabove),
        nth0(9,Lineabove,Elemabove),
        write('Elem above:'),write(Elemabove),nl,
        Elemabove\=Scared,
        Elemabove\=9+Scared,
        nth0(ElemLeftNumber,Lineabove,Elemleftdiagonal),
               write('Elem left above:'),write(Elemleftdiagonal),nl,
        Elemleftdiagonal\=Scared,
        Elemleftdiagonal\=9+Scared,
        write('Final').


       % Next_Elem is 0+1,
    %    check_not_scared_elem(Next_Elem,9,Board,PlredPiece).
    
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
check_not_scared_elem(ColumnNumber,LineNumayerTurn,Board,PlayerTurn):-
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


% VER CASO HAJA UMA PEÇA PERTO DUMA QUE NÃO DEVE
/*check_not_scared_elem(ColumnNumber,LineNumayerTurnx,ScaredPiece):-
      nth0(LineNumber,Board,Line),
      nth0(ColumnNumber,Line,Elem),
      write('Ulimto check:'),
      write('ColumnNumber:'),
        write(ColumnNumber),
        write('LineNumber:'),
        write(LineNumber),
        write('Elem:'),
        write(Elem),
        write('PlayerTurn:'),
        write(PlayerTurn),
        nl,
        !,
        check_elem(Elem,PlayerTurn),
        ScaredPiece=LineNumber-ColumnNumber,
        write(ScaredPiece).
*/

/*
check_scared_line(9,9,[Board,PlayerTurn],ScaredPiece):-
        \+check_not_scared_elem(9,9,Board,PlayerTurn), write('Depois de 99'),
        var(ScaredPiece).
*/
/*check_scared_line(9,9,[Board,PlayerTurn],ScaredPiece):-
        check_not_scared_elem(9,9,Board,PlayerTurn),
        ScaredPiece=9-9,
        write('Depois de 99'),
        nonvar(ScaredPiece).
*/
check_scared_line(9,LineNumber,[Board,PlayerTurn],ScaredPiece):-
        LineNumber\=9,
        check_not_scared_elem(ElemNumber,LineNumber,Board,PlayerTurn),
        var(ScaredPiece),
        NextLie is LineNumber+1,
        check_scared_line(0,NextLine,[Board,PlayerTurn],ScaredPiece).



check_scared_line(ElemNumber,LineNumber,[Board,PlayerTurn],ScaredPiece):-
        ElemNumber\=9,
        LineNumber\=9,
        write('Elem:'),write(ElemNumber),write('Line:'),write(LineNumber),nl,
        check_not_scared_elem(ElemNumber,LineNumbeerTurn),
        write('After func'),nl,
        var(ScaredPiece),
        Next_Elem is ElemNumber+1,
        check_scared_line(Next_Elem,LineNumber,[Board,PlayerTurn],ScaredPiece).

check_scared_line(9,9,[Board,PlayerTurn],ScaredPiece):-
        check_not_scared_elem(9,9,Board,PlayerTurn).

check_scared_line(C,L,[Board,PlayerTurn],ScaredPiece):-
        \+check_not_scared_elem(C,L,Board,PlayerTurn),
        ScaredPiece=L-C.

% check_scared(+GameState,+LineToCheck,-ScaredPiece)
% check if any piece is near a piec they are scared of
check_scared(GameState,ScaredPiece):-
      \+check_scared_line(0,0,GameState,ScaredPiece).


testee:-
        initial(1,[Board,PlayerTurn]),
        \+check_scared_line(0,9,[Board,PlayerTurn],0),
        nl,
        write(ScaredPiece).

teste2:-   
        initial(1,[Board,PlayerTurn]),
        check_scared_line(9,9,[Board,PlayerTurn],ScaredPiece),write(ScaredPiece),nl.