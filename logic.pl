


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
        Elem\=0,
        Elem\=9,
        Elem\=9+(-1),
        Elem\=9+(-2),
        Elem\=9+(-3),
        Elem\=(-1),
        Elem\=(-2),
        Elem\=(-3).
check_elem(Elem,2):-
        Elem\=0,
        Elem\=9,
        Elem\=9+1,
        Elem\=9+2,
        Elem\=9+3,
        Elem\=1,
        Elem\=2,
        Elem\=3.

% check_scared_elem(+ColumnNumber,+LineNumber,+Board,+PlayerTurn,-ScaredPiece)
% check if any piece is near a piec they are scared of and returns the piece if it is
% Case for the first element of the first line
check_scared_elem(0,0,Board,PlayerTurn,ScaredPiece):-
        nth0(0,Board,Line),
        nth0(0,Line,Elem),
        check_elem(Elem,PlayerTurn),
        scared_of(Elem,Scared). 
        nth0(0+1,Line,Elemright),
        Elemright\=Scared,
        Elemright\=9+Scared,
        nth0(0+1,Board,Linebellow),
        nth0(0,Linebellow,Elembellow),
        Elembellow\=Scared,
        Elembellow\=9+Scared,
        nth0(1,Linebellow,Elemrightdiagonal),
        Elemrightdiagonal\=Scared,
        Elemrightdiagonal\=9+Scared,
        Next_Elem is 0+1,
        check_scared_elem(Next_Elem,0,Board,PlayerTurn,ScaredPiece).

% Case for the last element of the first line
check_scared_elem(9,0,Board,PlayerTurn,ScaredPiece):-
        nth0(0,Board,Line),
        nth0(9,Line,Elem),
        check_elem(Elem,PlayerTurn),
        scared_of(Elem,Scared). 
        nth0(9-1,Line,Elemleft),
        Elemleft\=Scared,
        Elemleft\=9+Scared,
        nth0(0+1,Board,Linebellow),
        nth0(9,Linebellow,Elembellow),
        Elembellow\=Scared,
        Elembellow\=9+Scared,
        nth0(9-1,Linebellow,Elemleftdiagonal),
        Elemleftdiagonal\=Scared,
        Elemleftdiagonal\=9+Scared,,
        check_scared_elem(0,1,Board,PlayerTurn,ScaredPiece).

%  Case for elements between the first and the last of the first line
check_scared_elem(ColumnNumber,0,Board,PlayerTurn,ScaredPiece):-
        ColumnNumber>0,
        ColumnNumber<9,
        nth0(0,Board,Line),
        nth0(ColumnNumber,Line,Elem),
        check_elem(Elem,PlayerTurn),
        scared_of(Elem,Scared). 
        nth0(ColumnNumber+1,Line,Elemright),
        Elemright\=Scared,
        Elemright\=9+Scared,
        nth0(ColumnNumber-1,Line,Elemleft),
        Elemleft\=Scared,
        Elemleft\=9+Scared,
        nth0(0+1,Board,Linebellow),
        nth0(ColumnNumber,Linebellow,Elembellow),
        Elembellow\=Scared,
        Elembellow\=9+Scared,
        nth0(ColumnNumber+1,Linebellow,Elemrightdiagonal),
        Elemrightdiagonal\=Scared,
        Elemrightdiagonal\=9+Scared,
        nth0(ColumnNumber-1,Linebellow,Elemleftdiagonal),
        Elemleftdiagonal\=Scared,
        Elemleftdiagonal\=9+Scared,
        Next_Elem is 0+1,
        check_scared_elem(Next_Elem,0,Board,PlayerTurn,ScaredPiece).

% Case for the first element of the last line
check_scared_elem(0,9,Board,1,ScaredPiece):-
        nth0(9,Board,Line),
        nth0(0,Line,Elem),
        check_elem(Elem,PlayerTurn),
        scared_of(Elem,Scared). 
        nth0(0+1,Line,Elemright),
        Elemright\=Scared,
        Elemright\=9+Scared,
        nth0(9-1,Board,Lineabove),
        nth0(0,Lineabove,Elemabove),
        Elemabove\=Scared,
        Elemabove\=9+Scared,
        nth0(0+1,Lineabove,Elemrightdiagonal),
        Elemrightdiagonal\=Scared,
        Elemrightdiagonal\=9+Scared,
        Next_Elem is 0+1,
        check_scared_elem(Next_Elem,9,Board,PlayerTurn,ScaredPiece).

% Case for the last element of the last line
check_scared_elem(9,9,Board,PlayerTurn,ScaredPiece):-
        nth0(9,Board,Line),
        nth0(9,Line,Elem),
        check_elem(Elem,PlayerTurn),
        scared_of(Elem,Scared). 
        nth0(9-1,Line,Elemleft),
        Elemleft\=Scared,
        Elemleft\=9+Scared,
        nth0(9-1,Board,Lineabove),
        nth0(9,Lineabove,Elemabove),
        Elemabove\=Scared,
        Elemabove\=9+Scared,
        nth0(9-1,Lineabove,Elemleftdiagonal),
        Elemleftdiagonal\=Scared,
        Elemleftdiagonal\=9+Scared.
     %   ScaredPiece is 9.

% Case for elements between the first and the last of the last line
check_scared_elem(ColumnNumber,9,Board,PlayerTurn,ScaredPiece):-
        ColumnNumber>0,
        ColumnNumber<9,
        nth0(9,Board,Line),
        nth0(ColumnNumber,Line,Elem),
        check_elem(Elem,PlayerTurn),
        scared_of(Elem,Scared). 
        nth0(ColumnNumber+1,Line,Elemright),
        Elemright\=Scared,
        Elemright\=9+Scared,
        nth0(ColumnNumber-1,Line,Elemleft),
        Elemleft\=Scared,
        Elemleft\=9+Scared,
        nth0(9-1,Board,Lineabove),
        nth0(ColumnNumber,Lineabove,Elemabove),
        Elemabove\=Scared,
        Elemabove\=9+Scared,
        nth0(ColumnNumber+1,Lineabove,Elemrightdiagonal),
        Elemrightdiagonal\=Scared,
        Elemrightdiagonal\=9+Scared,
        nth0(ColumnNumber-1,Lineabove,Elemleftdiagonal),
        Elemleftdiagonal\=Scared,
        Elemleftdiagonal\=9+Scared,
        Next_Elem is 0+1,
        check_scared_elem(Next_Elem,9,Board,PlayerTurn,ScaredPiece).
    
% Case for the first element of the other lines
check_scared_elem(0,LineNumber,Board,PlayerTurn,ScaredPiece):-
        LineNumber>0,
        LineNumber<9,
        nth0(LineNumber,Board,Line),
        nth0(0,Line,Elem),
        check_elem(Elem,PlayerTurn),
        scared_of(Elem,Scared). 
        nth0(0+1,Line,Elemright),
        Elemright\=Scared,
        Elemright\=9+Scared,
        nth0(LineNumber+1,Board,Linebellow),
        nth0(0,Linebellow,Elembellow),
        Elembellow\=Scared,
        Elembellow\=9+Scared,
        nth0(0+1,Linebellow,Elemrightdiagonalbellow),
        Elemrightdiagonalbellow\=Scared,
        Elemrightdiagonalbellow\=9+Scared,
        nth0(LineNumber-1,Board,Lineabove),
        nth0(0,Lineabove,Elemabove),
        Elemabove\=Scared,
        Elemabove\=9+Scared,
        nth0(0+1,Lineabove,Elemrightdiagonalabove),
        Elemrightdiagonalabove\=Scared,
        Elemrightdiagonalabove\=9+Scared,
        Next_Elem is 0+1,
        check_scared_elem(Next_Elem,LineNumber,Board,PlayerTurn,ScaredPiece).

% Case for the last element of the other lines
check_scared_elem(9,LineNumber,Board,PlayerTurn,ScaredPiece):-
        LineNumber>0,
        LineNumber<9,
        nth0(LineNumber,Board,Line),
        nth0(9,Line,Elem),
        check_elem(Elem,PlayerTurn),
        scared_of(Elem,Scared). 
        nth0(9-1,Line,Elemleft),
        Elemleft\=Scared,
        Elemleft\=9+Scared,
        nth0(LineNumber+1,Board,Linebellow),
        nth0(9,Linebellow,Elembellow),
        Elembellow\=Scared,
        Elembellow\=9+Scared,
        nth0(9-1,Linebellow,Elemleftdiagonalbellow),
        Elemleftdiagonalbellow\=Scared,
        Elemleftdiagonalbellow\=9+Scared,
        nth0(LineNumber-1,Board,Lineabove),
        nth0(9,Lineabove,Elemabove),
        Elemabove\=Scared,
        Elemabove\=9+Scared,
        nth0(9-1,Lineabove,Elemleftdiagonalabove),
        Elemleftdiagonalabove\=Scared,
        Elemleftdiagonalabove\=9+Scared,
        check_scared_elem(0,LineNumber+1,Board,PlayerTurn,ScaredPiece).

% Case for elements between the first and the last of the other lines
check_scared_elem(ColumnNumber,LineNumber,Board,PlayerTurn,ScaredPiece):-
      ColumnNumber>0,
        ColumnNumber<9,
        LineNumber>0,
        LineNumber<9,
        nth0(LineNumber,Board,Line),
        nth0(ColumnNumber,Line,Elem),
        check_elem(Elem,PlayerTurn),
        scared_of(Elem,Scared). 
        nth0(ColumnNumber+1,Line,Elemright),
        Elemright\=Scared,
        Elemright\=9+Scared,
        nth0(ColumnNumber-1,Line,Elemleft),
        Elemleft\=Scared,
        Elemleft\=9+Scared,
        nth0(LineNumber+1,Board,Linebellow),
        nth0(ColumnNumber,Linebellow,Elembellow),
        Elembellow\=Scared,
        Elembellow\=9+Scared,
        nth0(ColumnNumber+1,Linebellow,Elemrightdiagonalbellow),
        Elemrightdiagonalbellow\=Scared,
        Elemrightdiagonalbellow\=9+Scared,
        nth0(ColumnNumber-1,Linebellow,Elemleftdiagonalbellow),
        Elemleftdiagonalbellow\=Scared,
        Elemleftdiagonalbellow\=9+Scared,
        nth0(LineNumber-1,Board,Lineabove),
        nth0(ColumnNumber,Lineabove,Elemabove),
        Elemabove\=Scared,
        Elemabove\=9+Scared,
        nth0(ColumnNumber+1,Lineabove,Elemrightdiagonalabove),
        Elemrightdiagonalabove\=Scared,
        Elemrightdiagonalabove\=9+Scared,
        nth0(ColumnNumber-1,Lineabove,Elemleftdiagonalabove),
        Elemleftdiagonalabove\=Scared,
        Elemleftdiagonalabove\=9+Scared,
        Next_Elem is ColumnNumber+1,
        check_scared_elem(Next_Elem,LineNumber,Board,PlayerTurn,ScaredPiece).


% VER CASO HAJA UMA PEÇA PERTO DUMA QUE NÃO DEVE
check_scared_elem(ColumnNumber,LineNumber,Board,PlayerTurn,ScaredPiece):-
      nth0(LineNumber,Board,Line),
      nth0(ColumnNumber,Line,ScaredPiece)
      check_elem(ScaredPiece,PlayerTurn).




check_scared_line(0,Board,PlayerTurn,ScaredPiece),:-
      check_scared_elem(0,0,Board,PlayerTurn,ScaredPiece).


% check_scared(+GameState,+LineToCheck,-ScaredPiece)
% check if any piece is near a piec they are scared of
check_scared([Board,PlayerTurn],LineNumber,ScaredPiece):-
      LineNumber>=0,
      LineNumber=<9,
      %CHECK THIS 
      \+check_scared_line(LineNumber,Board,PlayerTurn,ScaredPiece),
      L1 is LineNumber +1,
      check_scared([Board,PlayerTurn],L1,ScaredPiece).
