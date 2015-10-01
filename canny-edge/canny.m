sigma = 2;

I = imread('resources/city.pgm');
I = im2double(I);
imshow(I);
figure;
G = gaussian(sigma);
filtered = conv2(I, G,'same');
imshow(filtered);
