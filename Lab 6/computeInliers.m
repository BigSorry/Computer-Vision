% function inliers = computeInliers(F,match1,match2,threshold)
% Find inliers by computing perpendicular errors between the points and the epipolar lines in each image
% To be brief, we compute the Sampson distance mentioned in the lab file.
% Input: 
%   -matrix F, matched points from image1 and image 2, and a threshold (e.g. threshold=50)
% Output: 
%   -inliers: indices of inliers
function inliers = computeInliers(F,match1,match2,threshold)

    % Calculate Sampson distance for each point
    % Compute numerator and denominator at first
    values = [];
    for column = 1:size(match1,2)
        Fx = F*match1(:,column);
        Fx2 = F'*match2(:,column);
        numer = (match2(:,column)'*F*match1(:,column)).^2;
        denom = Fx(1).^2 + Fx(2).^2 + Fx2(1).^2 + Fx2(2).^2;
        sd    = numer./denom;
        values = [values, sd];
    end

    % Return inliers for which sd is smaller than threshold
    inliers = find(values<threshold);

end
