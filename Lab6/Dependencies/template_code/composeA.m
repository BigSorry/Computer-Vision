% function A = composeA(x1, x2)
% Compose matrix A, given matched points (X1,X2) from two images
% Input: 
%   -normalized points: X1 and X2 
% Output: 
%   -matrix A
function A = composeA(x1, x2) 
     firstColumn = (x1(1,:).*x2(1,:))';
     secondColumn = (x1(1,:).*x2(2,:))';
     thirdColumn = x1(1,:)';
     fourthColumn = (x1(2,:).*x2(1,:))';
     
     fifthColumn = (x1(2,:).*x2(2,:))';
     sixthColumn = x1(2,:)';
     seventhColumn = x2(1,:)';
     eightColumn = x2(2,:)';
     ninthColumn = ones(size(x1,2),1);
     A = [firstColumn,secondColumn,thirdColumn, fourthColumn,fifthColumn, sixthColumn, seventhColumn, eightColumn, ninthColumn];
end
