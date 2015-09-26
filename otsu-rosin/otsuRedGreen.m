% Use Otsu's method to color (darker) object in red and background in green
I = imread('lena_r92-053-04.jpg');
level = graythresh(I);
BW = im2bw(I,level);
imshow(BW)
CMap = [1, 0, 0;  0, 1, 0];
RGB  = ind2rgb(BW, CMap);
figure
imshow(RGB)