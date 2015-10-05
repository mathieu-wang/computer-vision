% Inspired by Peter Kovesi's findendsjunctions.m
% http://www.peterkovesi.com/matlabfns/LineSegments/findendsjunctions.m
function [row_vector, col_vector] = findendsjunctions(I)

lut = makelut(@ending, 3); % make lookup table
endpoints = bwlookup(I, lut);
[row_vector,col_vector] = find(endpoints);

%----------------------------------------------------------------------
% Function to test whether the centre pixel within a 3x3 neighbourhood is an
% ending. The centre pixel must be set and the number of transitions/crossings
% between 0 and 1 as one traverses the perimeter of the 3x3 region must be 2.
%
% Pixels in the 3x3 region are numbered as follows
%
%       1 4 7
%       2 5 8
%       3 6 9

function b = ending(x)
    a = [x(1) x(2) x(3) x(6) x(9) x(8) x(7) x(4)]';
    b = [x(2) x(3) x(6) x(9) x(8) x(7) x(4) x(1)]';    
    crossings = sum(abs(a-b));
    
    b = x(5) && crossings == 2;
    