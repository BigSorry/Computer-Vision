im1 = rgb2gray( imread('left.jpg') );
im2 = rgb2gray( imread('right.jpg') );
[frames1, desc1] = vl_sift(single(im1));
[frames2, desc2] = vl_sift(single(im2));
[matches] = vl_ubcmatch(desc1, desc2);
match1 = frames1(:,matches(1,:));
match2 = frames2(:,matches(2,:));

N = 50;
maxnuminliers = 0;
for i = 1:N
    perm = randperm(length(match1(1,:)));
    P = 3;
    seed = perm(1:P);
    m1 = match1([1,2],seed);
    m2 = match2([1,2],seed);
    A = [m1(1,1) m1(2,1) 0 0 1 0;
        0 0 m1(1,1) m1(2,1) 0 1;
        m1(1,2) m1(2,2) 0 0 1 0;
        0 0 m1(1,2) m1(2,2) 0 1;
        m1(1,3) m1(2,3) 0 0 1 0;
        0 0 m1(1,3) m1(2,3) 0 1];
    b = [m2(1,1) m2(2,1) m2(1,2) m2(2,2) m2(1,3) m2(2,3)];
    h = pinv(A) * b';
    bprim = A * h;
    frames2New = frames2;
    for j = 1:length(matches)
        frames2New(1:2,matches(2,j)) = [[h(1) h(2)]; [h(3) h(4)]] * [frames1(1,matches(1,j)); frames1(2,matches(1,j))] + [h(5); h(6)];
    end
    threshold = 10; % #pixels
    inliers = find(sqrt(sum((frames2New(1:2,:) - frames2(1:2,:)).^2)) < threshold);
    numinliers = length(inliers);
    if numinliers > maxnuminliers
        maxnuminliers = numinliers;
        besth = h;
    end
end

affine_transform = [h(1) h(2) h(5); h(3) h(4) h(6); 0 0 1 ];
tform = affine2d(affine_transform');
[image1_transformed, RBim1]= imwarp(im1, tform, 'bicubic');
tform = affine2d(inv(affine_transform)');
[image2_transformed, RBim2] = imwarp(im2, tform, 'bicubic');

figure;
subplot(2,2,1); imshow(im1); title('Image1');
subplot(2,2,2); imshow(im2); title('Image2');
subplot(2,2,4); imshow(image1_transformed); title('Image1 transformed');
subplot(2,2,3); imshow(image2_transformed); title('Image2 transformed');

xLim = RBim2.XWorldLimits;
yLim = RBim2.YWorldLimits;
xMin = floor(min([0 xLim(1)]));
yMin = floor(min([0 yLim(1)]));
xMax = ceil(max([size(im1,1), xLim(2)]));
yMax = ceil(max([size(im1,2), yLim(2)]));

newImage = zeros(yMax - yMin, xMax - xMin, 'uint8');

xOffset = round(yLim(1) - xMin);
yOffset = round(xLim(1) - yMin);

newImage(xOffset+1:xOffset+RBim2.ImageSize(1),yOffset+1:yOffset+RBim2.ImageSize(2)) = image2_transformed;
newImage(1:size(im1,1), 1:size(im1,2)) = im1;
figure;
imshow(newImage); title('Image2 stitched to Image1');