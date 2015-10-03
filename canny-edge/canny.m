%% Parameters
sigma = 1;
tao1 = 0.2;

tao2 = 2*tao1;

%% Read the image and convert to double
I = imread('resources/tower.pgm');
I = im2double(I);
figure
imshow(I);

%% Blur the image using Gaussian filter
G = gaussian(sigma);
% TODO: Implement conv2
S = conv2(I, G, 'same'); % Get smoothed image S

figure
imshow(S);

%% Get partial derivatives of the smoothed image using first-difference approximations
Sx = S;
Sy = S;
[S_rows, S_columns] = size(S);
for i = 1:S_rows
    for j = 1:S_columns
        if i >= S_rows || j >= S_columns % Pads smoothed image with zeros on last row and column
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

figure
imshow(normalize(M));

theta = atan2(Sy, Sx);

figure
imshow(normalize(theta));

%% Nonmaxima Suppression for edge thinning
zeta = sector(theta);
N = nms(M, zeta);

normalized_N = normalize(N);
figure
imshow(normalized_N);

%% Double thresholding
T1 = im2bw(normalized_N,tao1);
T2 = im2bw(normalized_N,tao2);

figure
imshow(T1);
figure
imshow(T2);


%% Edge linking