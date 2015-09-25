% Subdivide each image in to 3x3 and 8x8 blocks, then run Rosin on them

image_bw = imread('lena_r92-053-04.jpg');
image_color = imread('Lena_stasjon.jpg');

%% Resize and crop image so it becomes a square image with size that's a multiple of 24.
% Assumes that the image is larger than 24 x 24
cropped_bw = resizeandcrop(image_bw, 24);
cropped_color = resizeandcrop(image_color, 24);

imshow(cropped_bw);
figure
imshow(cropped_color);
figure

%% Do block-by-block processing
fun = @(block_struct) otsurosin(block_struct.data);

bw8x8 = blockproc(cropped_bw,[8 8],fun);
imshow(bw8x8)
figure

color8x8 = blockproc(cropped_color,[8 8],fun);
imshow(color8x8)
figure

bw3x3 = blockproc(cropped_bw,[3 3],fun);
imshow(bw3x3)
figure

color3x3 = blockproc(cropped_color,[3 3],fun);
imshow(color3x3)
figure
