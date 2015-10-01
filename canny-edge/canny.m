%% Read the image and convert to double
I = imread('resources/city.pgm');
I = im2double(I);
imshow(I);
figure;

%% Blur the image using Gaussian filter
sigma = 2;
G = gaussian(sigma);
filtered = conv2(I, G,'same');
imshow(filtered);
