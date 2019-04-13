function Gd =gaussianDer(G , sigma)
size = 3 * sigma;
x = -size:size;
Gd = -(x/(sigma*sigma)) .* G;
end