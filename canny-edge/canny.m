sigma = 6;
x = floor(-4*sig):ceil(4*sig);
y = floor(-4*sig):ceil(4*sig);
[x, y] = meshgrid(x, y);

G = 1/(2*pi*sigma^2) * exp(-(x.^2+y.^2)/(2*sigma));
sum(G(:))
G = G./sum(G(:));

I = imread('resources/city.pgm');
I = im2double(I);
imshow(I);
figure;
filtered = conv2(I, G,'same');
imshow(filtered);