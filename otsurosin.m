% function that runs Rosin's method (iterative Otsu) on an image, assuming the object is
% darker
function Image = otsurosin(I, T1)

T1 = greythresh2(I);
T2 = greythresh2(I, T1);
BW = im2bw(I, T2);
imshow(BW)
CMap = [1, 0, 0;  0, 1, 0];
Image  = ind2rgb(BW, CMap);