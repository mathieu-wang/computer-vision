function G = gaussian(sigma)
% Get a 2D Gaussian filter
x = floor(-4*sigma):ceil(4*sigma);
y = floor(-4*sigma):ceil(4*sigma);
[x, y] = meshgrid(x, y);

G = 1/(2*pi*sigma^2) * exp(-(x.^2+y.^2)/(2*sigma));
G = G./sum(G(:));
