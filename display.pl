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
code(0," "). % space
code(1,"E1"). % elephant player 1
code(-1,"E2"). % elephant player 2
code(2,"R1"). % rat player 1
code(-2,"R2"). % rat player 2
code(3,"L1"). % lion player 1
code(-3,"L2"). % lion player 2
code(4,"G"). % goal 

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


