% Produce the RGB histograms for a color image

image = imread('Lena_stasjon.jpg');

%Split into RGB Channels
Red = image(:,:,1);
Green = image(:,:,2);
Blue = image(:,:,3);

[yRed, x] = imhist(Red);
[yGreen, x] = imhist(Green);
[yBlue, x] = imhist(Blue);

figure
subplot(2,2,1), subimage(image)
title('Original Image')

subplot(2,2,2)
plot(x, yRed, 'Red')
title('Red Histogram')

subplot(2,2,3)
plot(x, yGreen, 'Green')
title('Green Histogram')

subplot(2,2,4)
plot(x, yBlue, 'Blue')
title('Red Histogram')