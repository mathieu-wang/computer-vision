% 1) find T1
% 2) create image

I = imread('lena_r92-053-04.jpg');
%imshow(I)
%T1 = graythresh(I);
level = multithresh(I);
seg_I = imquantize(I,level, [0, level]);
%figure
imshow(seg_I, [])

CMap = [1, 0, 0;  0, 1, 0];
RGB  = ind2rgb(seg_I, CMap);
figure
imshow(RGB)
%T2 = graythresh(newI);
%BW = im2bw(I,T2);