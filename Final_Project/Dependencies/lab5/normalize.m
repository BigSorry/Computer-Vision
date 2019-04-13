% Function [Xout, T] = normalize( X )
% Normalize all the points in each image
% Input
%     -X: a matriX with 2D inhomogeneous X in each column.
% Output: 
%     -Xout: a matriX with (2+1)D homogeneous X in each column;
%     -matrix T: normalization matrix

function [Xout, T] = normalize( X )

    % Compute xMean: normalize all X in each image to have 0-mean
    xMean =  mean(X(1,:));
    yMean = mean(X(2,:));
    % Compute d: scale all X so that the average distance to the mean is sqrt(2).
    % Check the lab file for details.
    d = mean(sqrt((X(1,:) - xMean).^2 + (X(2,:) - yMean).^2));

    % Compose matrix T
    T = [sqrt(2)/d, 0, (-xMean*sqrt(2))/d;
        0, sqrt(2)/d, (-yMean*sqrt(2)) / d;
        0, 0, 1];

    % Compute Xout using X^ = TX with one extra dimension (We are using homogenous coordinates)
    % Is already homogenous
    Xout = T * X;%[X; ones(1,size(X,2))];

end
