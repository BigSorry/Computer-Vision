image = imread('landscape-a.jpg');
imageGray = double(rgb2gray(image));
image2 = imread('landscape-b.jpg');
imageGray2 = double(rgb2gray(image2));

loc = DoG(image,0.01);
loc2 = DoG(image2,0.01);

[row, column, sigma, pointImage] = harris(imageGray, loc);
rotations = zeros(1, size(sigma,1)) * 2*pi;
[coord1, descriptor1] = vl_sift(single(imageGray), 'Frames', [row.';column.';sigma.';rotations]);

[row2, column2, sigma2, pointImage2] = harris(imageGray2, loc2);
rotations2 = zeros(1, size(sigma2,1)) *2*pi;
[coord2, descriptor2] = vl_sift(single(imageGray2), 'Frames', [row2.';column2.';sigma2.';rotations2]);

imshow([image, image2]);
hold on;
plot(column,row,'b.');
plot(column2+720, row2,'b.');
threshold =  10^2;
% Loop over the descriptors of the first image
matches = [-1,-1];
for index1 = 1:size(descriptor1, 2)
    bestDist = Inf;
    secondBestDist = Inf;
    bestmatch = [0 0];
    % Loop over the descriptors of the second image
    for index2=1:size(descriptor2, 2)
        if sum(matches(:,2) == index2) > 0
            continue
        end
        desc1 = double(descriptor1(:,index1));
        desc2 = double(descriptor2(:,index2));
        
        % Compute the Euclidian distance of desc1 and desc2
        dist = sqrt(sum((desc1 - desc2).^ 2));
        
        % Threshold the distances
        if dist < threshold
            if secondBestDist > dist
                if bestDist > dist
                    secondBestDist = bestDist;
                    bestDist = dist;
                    bestmatch = [index1 index2];
                else % if not smaller than both best and second best dist
                    secondBestDist = dist;
                end
            end
        end
    end
    % Keep the best match and draw.
    if (bestDist / secondBestDist) < 0.8
    % You can use the 'line' function in matlab to draw the matches.
        matches = [matches;bestmatch];
        coordX1 = coord1(1, bestmatch(1));
        coordX2 = coord2(1, bestmatch(2));
        coordY1 = coord1(2, bestmatch(1));
        coordY2 = coord2(2, bestmatch(2));% + size(imageGray, 2);
        % X and Y axis are swapped for drawing
        plot([coordY1, coordY2 + 720], [coordX1, coordX2],'Color','r');
    end
end
% Return matches between the images
disp('done');