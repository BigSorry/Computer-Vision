function F=ImageDerivatives(img , sigma , type)
size = 3 * sigma;
x = -size:size;
G = gaussian(sigma); 

switch type
    case {'x', 'y', 'xy','yx'}
        Gd = gaussianDer(G, sigma);     
    case {'xx', 'yy'}
        % Scale invariant harris points
        Gdd = ( ( -(sigma^2) + (x.^2) ) ./ (sigma^4) ) .* G;
        Gdd = Gdd * sigma.^2;
end

switch type
    case 'x'
        F = conv2(img, Gd, 'same');
    case 'y'
        F = conv2(img, Gd', 'same');
    case 'xx'
        F = conv2(img, Gdd, 'same');
    case {'xy', 'yx'}
        F = conv2(Gd, Gd, img, 'same');
    case 'yy'
        F = conv2(img, Gdd', 'same');
    otherwise
        error('Unknown type: type must be in {x, y, xx, xy, yx, yy}');
end
end