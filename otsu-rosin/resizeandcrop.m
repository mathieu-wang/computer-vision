% Resize and crop image so it becomes a square image with size that's a multiple of N.
function result = resizeandcrop(I, N)

% Assumes that the image is larger than N x N and width >= height
[width, height, color]=size(I);
new_width = N* floor(width/N); % round down to nearest multiple of 24 = 3 * 8
new_height = floor(height/width * new_width); % resize height according to new width
resized = imresize(I, [new_width, new_height]);
pixels_to_crop = (new_height - new_width)/2; % crop same amount on both sides
result = imcrop(resized, [pixels_to_crop, 0, new_width, new_width]);