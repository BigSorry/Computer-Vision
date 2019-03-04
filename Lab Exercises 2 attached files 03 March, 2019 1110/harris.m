function [r, c, sigmas, pointImage] = harris(im, loc)
    % inputs: 
    % im: double grayscale image
    % loc: list of interest points from the Laplacian approximation
    % outputs:
    % [r,c,sigmas]: The row and column of each point is returned in r and c
    %              and the sigmas 'scale' at which they were found
    
    % Calculate Gaussian Derivatives at derivative-scale. 
    % NOTE: The sigma is independent of the window size (which dependes on the Laplacian responses).
    % Hint: use your previously implemented function in assignment 1 
    Ix =  ImageDerivatives(im, 1, 'x');
    Iy =  ImageDerivatives(im, 1, 'y');

    % Allocate an 3-channel image to hold the 3 parameters for each pixel
    init_M = zeros(size(Ix,1), size(Ix,2), 3);

    % Calculate M for each pixel
    init_M(:,:,1) = Ix.^2;
    init_M(:,:,2) = Ix.*Iy;
    init_M(:,:,3) = Iy.^2;

    % Allocate R 
    R = zeros(size(Ix,1), size(Ix,2), 2);

    % Smooth M with a gaussian at the integration scale sigma.
    % Keep only points from the list 'loc' that are coreners.
    for l = 1 : size(loc,1)
        sigma = loc(l,3); % The sigma at which we found this point	
	if ((l>1) && sigma~=loc(l-1,3)) || (l==1)
		M = imfilter(init_M, fspecial('gaussian', ceil(sigma*6+1), sigma), 'replicate', 'same');
	end
	
        % Compute the cornerness R at the current location location
        k = 0.05;
        trace_l = M(loc(l,2), loc(l,1), 1) + M(loc(l,2), loc(l,1),3);
        det_l = (M(loc(l,2), loc(l,1), 1).*M(loc(l,2), loc(l,1), 3)) - (M(loc(l,2), loc(l,1), 2).^2);
        R(loc(l,2), loc(l,1), 1) = det_l - k*(trace_l.^2);

	% Store current sigma as well
        R(loc(l,2), loc(l,1), 2) = sigma;

    end
    % Display corners
    %imshow(im); hold on;
      
    % Set the threshold 
    threshold =  10^3;

    % Find local maxima
    % Dilation will alter every pixel except local maxima in a 3x3 square area.
    % Also checks if R is above threshold

    % Non max supression	
    R(:,:,1) = ((R(:,:,1)>threshold) & ((imdilate(R(:,:,1), strel('square', 3))==R(:,:,1)))) ; 
    
    pointImage = R(:,:,1);  
    % Return the coordinates and sigmas
    [r, c] = find(R(:,:,1));
    sigmas = zeros(size(r,1), 1);
    for i = 1:size(r,1)
        sigmas(i, 1) = R(r(i,1),c(i,1),2);
    end
end
