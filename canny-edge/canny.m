%% Read the image and convert to double
I = imread('resources/city.pgm');
I = im2double(I);
imshow(I);
figure;

%% Blur the image using Gaussian filter
sigma = 1.4;
G = gaussian(sigma);
% TODO: Implement conv2
S = conv2(I, G, 'same'); % Get smoothed image S

imshow(S);
figure

%% Get partial derivatives of the smoothed image using first-difference approximations
Sx = S;
Sy = S;
[rows, columns] = size(S);
for i = 1:rows
    for j = 1:columns
        if i >= rows || j >= columns % Pads smoothed image with zeroes on last row and column
            Sx(i, j) = 0;
            Sy(i, j) = 0;
        else
            Sx(i, j) = (S(i, j+1) - S(i, j) + S(i+1, j+1) - S(i+1, j))/2;
            Sy(i, j) = (S(i, j) - S(i+1, j) + S(i, j+1) - S(i+1, j+1))/2;
        end
    end
end

%% Get the magnitude and orientation of the gradient
M = sqrt(Sx.^2 + Sy.^2);

[M_row, M_col] = size(M);
max_in_M = max(max(M));
M_normalized = M./max_in_M;
imshow(M_normalized);
figure


theta = atan2(Sy, Sx);

[theta_row, theta_col] = size(theta);
max_in_theta = max(max(theta));
theta_normalized = theta./max_in_theta;
imshow(theta_normalized);
figure

%% Nonmaxima Suppression
