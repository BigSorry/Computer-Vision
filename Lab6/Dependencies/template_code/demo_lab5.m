% Demo for assignment 5
% Compute Fundamental Matrix F using the normalized Eight-Point Algorithm

function F = demo_lab5()
    close all; clear all; tic;

    % Read images
    disp('Reading images');
    img1 = im2double(rgb2gray(imread('TeddyBearPNG/obj02_001.png')));
    img2 = im2double(rgb2gray(imread('TeddyBearPNG/obj02_002.png')));

    % Load Features and Descriptors (provided by TAs)
    % you can also extract those features using the Harris/Hessian Affine 
    % implementation which can be downloaded from http://www.robots.ox.ac.uk/~vgg/research/affine/detectors.html.
    [feat1,desc1,~,~] = loadFeatures('TeddyBearPNG/obj02_001.png.haraff.sift');
    [feat2,desc2,~,~] = loadFeatures('TeddyBearPNG/obj02_002.png.haraff.sift');

    % Using vl_ubcmatch to match descriptors
    disp('Matching Descriptors');
    [matches, ~] = vl_ubcmatch(desc1,desc2);
    disp(strcat( int2str(size(matches,2)), ' matches found'));

    % Get X,Y coordinates of matched features
    X1 = feat1(1:2,matches(1,:));
    X2 = feat2(1:2,matches(2,:));

    % Estimate Fundamental Matrix using the 8-point algorithm
    disp('Estimating F');
    [F inliers] = estimateFundamentalMatrix(X1,X2);

    % Display Fundamental matrix
    disp('F =');
    disp(F);

     % Show the images with matched points
    figure(1);
    imshow([img1,img2],'InitialMagnification', 'fit');
    title('Images with matched points'); hold on;

    scatter(X1(1,inliers),X1(2,inliers), 'y');
    scatter(size(img1,2)+X2(1,inliers),X2(2,inliers) ,'r');
    line([X1(1,inliers);size(img1,2)+X2(1,inliers)], [X1(2,inliers);X2(2,inliers)], 'Color', 'b');

    outliers = setdiff(1:size(matches,2),inliers);
    line([X1(1,outliers);size(img1,2)+X2(1,outliers)], [X1(2,outliers);X2(2,outliers)], 'Color', 'r');

    figure(2);
    % Visualize epipolar lines
    subplot(2,2,1);
    imshow(img1,'InitialMagnification', 'fit');
    title('Epipolar line for the yellow point of right image'); hold on;
    subplot(2,2,2);
    imshow(img2,'InitialMagnification', 'fit');
    title('Epipolar line for the yellow point of left image'); hold on;

    % Take random points and visualize
    a  = 1;
    b  = size(matches,2);
    rL = floor(a + (b-a).*rand(1,1));
    rR = floor(a + (b-a).*rand(1,1));
    pointL = [X1(:,rL);1];
    pointR = [X2(:,rR);1];

    subplot(2,2,1);
    scatter(pointL(1),pointL(2),15,'y');
    subplot(2,2,2);
    scatter(pointR(1),pointR(2),15,'y');

    % If the obtained line has coordinates (u1, u2, u3) then we can plot it over the image (X,Y) with:
    % Y = -(u1 * X + u3)/u2
    epiR = F * pointL;
    plot(-(epiR(1)*(1:size(img2,2))+epiR(3))./epiR(2), 'r')

    epiL = F' * pointR;
    subplot(2,2,1);
    plot(-(epiL(1)*(1:size(img1,2))+epiL(3))./epiL(2), 'r')
    
    subplot(2,2,3);
    imshow(img1,'InitialMagnification', 'fit');
    title('Image 1 with the epipolar lines of 20 points in image 2'); hold on;
    subplot(2,2,4);
    imshow(img2,'InitialMagnification', 'fit');
    title('Image 2 with the epipolar lines of 20 points in image 1'); hold on;

    % Take 20 random points and visualize
    perm = randperm(size(matches,2));
    a  = perm(1:20);
    b  = size(matches,2);
    rL = floor(a + (b-a).*rand(1,1));
    rR = floor(a + (b-a).*rand(1,1));
    pointsL = [X1(:,rL);ones(20,1)'];
    pointsR = [X2(:,rR);ones(20,1)'];
    
    for i = 1:20
        subplot(2,2,3);
        scatter(pointsL(1,i),pointsL(2,i),15,'y'); hold on;
        subplot(2,2,4);
        scatter(pointsR(1,i),pointsR(2,i),15,'y'); hold on;
    
        subplot(2,2,3); hold on;
        epiR = F * pointsL(:,i);
        plot(-(epiR(1)*(1:size(img2,2))+epiR(3))./epiR(2), 'r'); hold on;

        epiL = F' * pointsR(:,i);
        subplot(2,2,4); hold on;
        plot(-(epiL(1)*(1:size(img1,2))+epiL(3))./epiL(2), 'r'); hold on;
    end
end





