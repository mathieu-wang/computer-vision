%% Parameters
sigma = 1;
tao1 = 0.2;

tao2 = 2*tao1;

%% Read the image and convert to double
I = imread('resources/plant.pgm');
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

%% Convolve with Sobel operators to compare
Sobelx3x3 = [1 0 -1; 2 0 -2; 1 0 -1];
Sobely3x3 = [-1 -2 -1; 0 0 0; 1 2 1];
Sobelx5x5 = [1 2 0 -2 -1; 4 8 0 -8 -4; 6 12 0 -12 -6; 4 8 0 -8 -4; 1 2 0 -2 -1];
Sobely5x5 = [-1 -4 -6 -4 -1; -2 -8 -12 -8 -2; 0 0 0 0 0; 2 8 12 8 2; 1 4 6 4 1];

Sx_Sob3x3 = conv2(I, Sobelx3x3, 'same');
Sy_Sob3x3 = conv2(I, Sobely3x3, 'same');
M_Sob3x3 = sqrt(Sx_Sob3x3.^2 + Sy_Sob3x3.^2);
figure('Name', 'Magnitude After Sobel 3x3')
imshow(normalize(M_Sob3x3));

Sx_Sob5x5 = conv2(I, Sobelx5x5, 'same');
Sy_Sob5x5 = conv2(I, Sobely5x5, 'same');
M_Sob5x5 = sqrt(Sx_Sob5x5.^2 + Sy_Sob5x5.^2);
figure('Name', 'Magnitude After Sobel 5x5')
imshow(normalize(M_Sob5x5));


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

[row_vector, col_vector] = findendpoints(T2);
[T2_row, T2_col] = size(T2);
endpoints = zeros(T2_row, T2_col);
final_image = T2;
for ind=1:size(re)
    i = row_vector(ind);
    j = col_vector(ind);
    endpoints(i, j) = 1;

    if i > 1 && j >1 && i < T2_row && j < T2_col
        if T1(i-1, j-1) == 1
            next_i = i-1;
            next_j = j-1;
            while next_i >= 1 && next_j >= 1 && T2(next_i, next_j) == 0 && T1(next_i, next_j) == 1 % extend in that direction
                final_image(next_i, next_j) = 1;
                next_i = next_i-1;
                next_j = next_j-1;
            end
        end
        if T1(i-1, j) == 1
            next_i = i-1;
            next_j = j;
            while next_i >= 1 && T2(next_i, next_j) == 0 && T1(next_i, next_j) == 1 % extend in that direction
                final_image(next_i, next_j) = 1;
                next_i = next_i-1;
            end
        end
        if T1(i-1, j+1) == 1
            next_i = i-1;
            next_j = j+1;
            while next_i >= 1 && next_j <= T2_col && T2(next_i, next_j) == 0 && T1(next_i, next_j) == 1 % extend in that direction
                final_image(next_i, next_j) = 1;
                next_i = next_i-1;
                next_j = next_j+1;
            end
        end
        if T1(i, j-1) == 1
            next_i = i;
            next_j = j-1;
            while next_j >= 1 && T2(next_i, next_j) == 0 && T1(next_i, next_j) == 1 % extend in that direction
                final_image(next_i, next_j) = 1;
                next_j = next_j-1;
            end
        end
        if T1(i, j+1) == 1
            next_i = i;
            next_j = j+1;
            while next_j <= T2_col && T2(next_i, next_j) == 0 && T1(next_i, next_j) == 1 % extend in that direction
                final_image(next_i, next_j) = 1;
                next_j = next_j+1;
            end
        end
        if T1(i+1, j-1) == 1
            next_i = i+1;
            next_j = j-1;
            while next_i <= T2_row && next_j >= 1 && T2(next_i, next_j) == 0 && T1(next_i, next_j) == 1 % extend in that direction
                final_image(next_i, next_j) = 1;
                next_i = next_i+1;
                next_j = next_j-1;
            end
        end
        if T1(i+1, j) == 1
            next_i = i+1;
            next_j = j;
            while next_i <= T2_row && T2(next_i, next_j) == 0 && T1(next_i, next_j) == 1 % extend in that direction
                final_image(next_i, next_j) = 1;
                next_i = next_i+1;
            end
        end
        if T1(i+1, j+1) == 1
            next_i = i+1;
            next_j = j+1;
            while next_i <= T2_row && next_j <= T2_col && T2(next_i, next_j) == 0 && T1(next_i, next_j) == 1 % extend in that direction
                final_image(next_i, next_j) = 1;
                next_i = next_i+1;
                next_j = next_j+1;
            end
        end
    end
end

figure
imshow(endpoints);

figure
imshow(final_image);
