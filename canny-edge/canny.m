%% Read the image and convert to double
I = imread('resources/tower.pgm');
I = im2double(I);
imshow(I);
figure

%% Blur the image using Gaussian filter
sigma = 1;
G = gaussian(sigma);
% TODO: Implement conv2
S = conv2(I, G, 'same'); % Get smoothed image S

imshow(S);
figure

%% Get partial derivatives of the smoothed image using first-difference approximations
Sx = S;
Sy = S;
[S_rows, S_columns] = size(S);
for i = 1:S_rows
    for j = 1:S_columns
        if i >= rows || j >= S_columns % Pads smoothed image with zeros on last row and column
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
zeta = sector(theta);
for i = 1:M_row
    for j = 1:M_col
        center_value = M(i, j);
        sector = zeta(i, j);
        neighbor1 = 0;
        neighbor2 = 0;
        if sector == 0
            if j > 1
                neighbor1 = M(i, j-1);
            end
            if j < M_col
                neighbor2 = M(i, j+1);
            end
        elseif sector == 1
            if i < M_row && j > 1
                neighbor1 = M(i+1, j-1);
            end
            if i > 1 && j < M_col
                neighbor2 = M(i-1, j+1);
            end
        elseif sector == 2
            if i < M_row
                neighbor1 = M(i+1, j);
            end
            if i > 1
                neighbor1 = M(i-1, j);
            end
        else
            if i < M_row && j < M_col
                neighbor1 = M(i+1, j+1);
            end
            if i > 1 && j > 1
                neighbor2 = M(i-1, j-1);
            end
        end

        if neighbor1 >= center_value || neighbor2 >= center_value
            M(i, j) = 0;
        end
    end
end

imshow(M);
figure