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
%[k, l] = findendofcontour(T2, visited, i, j);
%while has_not_linked_to_next_edge_in_T2_so_only_one_T2_point_in_neighborhood
%    t1_points = [];
%    try_linking_using_t1;
%    break_after_ten_pixels

%{
[T2_row, T2_col] = size(T2);
final_image = T2;

for i = 2:T2_row-1
    for j = 2:T2_col-1
        if T2(i, j) == 1
            if T1(i-1, j-1) == 1
                final_image(i-1, j-1) = 1;
            end
            if T1(i-1, j) == 1
                final_image(i-1, j) = 1;
            end
            if T1(i-1, j+1) == 1
                final_image(i-1, j+1) = 1;
            end
            if T1(i, j-1) == 1
                final_image(i, j-1) = 1;
            end
            if T1(i, j+1) == 1
                final_image(i, j+1) = 1;
            end
            if T1(i+1, j-1) == 1
                final_image(i+1, j-1) = 1;
            end
            if T1(i+1, j) == 1
                final_image(i+1, j) = 1;
            end
            if T1(i+1, j+1) == 1
                final_image(i+1, j+1) = 1;
            end
        end
    end
end
%}

[rj, cj, re, ce] = findendsjunctions(T2);

endpoints = zeros(T2_row, T2_col);
final_image = T2;
for ind=1:size(re)
    i = re(ind);
    j = ce(ind);
    endpoints(i, j) = 1;

    if i > 1 && j >1 && i < T2_row && j < T2_col
        if T1(i-1, j-1) == 1
            next_i = i-1;
            next_j = j-1;
            while T2(next_i, next_j) == 0 && T1(next_i, next_j) == 1 && next_i >= 1 && next_j >= 1 % extend in that direction
                final_image(next_i, next_j) = 1;
                next_i = i-1;
                next_j = j-1;
            end
        end
        if T1(i-1, j) == 1
            next_i = i-1;
            next_j = j;
            while T2(next_i, next_j) == 0 && T1(next_i, next_j) == 1 && next_i >= 1 % extend in that direction
                final_image(next_i, next_j) = 1;
                next_i = i-1;
                next_j = j;
            end
        end
        if T1(i-1, j+1) == 1
            next_i = i-1;
            next_j = j+1;
            while T2(next_i, next_j) == 0 && T1(next_i, next_j) == 1 && next_i >= 1 && next_j <= T2_col % extend in that direction
                final_image(next_i, next_j) = 1;
                next_i = i-1;
                next_j = j+1;
            end
        end
        if T1(i, j-1) == 1
            next_i = i;
            next_j = j-1;
            while T2(next_i, next_j) == 0 && T1(next_i, next_j) == 1 && next_j >= 1 % extend in that direction
                final_image(next_i, next_j) = 1;
                next_i = i;
                next_j = j-1;
            end
        end
        if T1(i, j+1) == 1
            next_i = i;
            next_j = j+1;
            while T2(next_i, next_j) == 0 && T1(next_i, next_j) == 1 && next_j <= T2_col % extend in that direction
                final_image(next_i, next_j) = 1;
                next_i = i;
                next_j = j+1;
            end
        end
        if T1(i+1, j-1) == 1
            next_i = i+1;
            next_j = j-1;
            while T2(next_i, next_j) == 0 && T1(next_i, next_j) == 1 && next_i <= T2_row && next_j >= 1 % extend in that direction
                final_image(next_i, next_j) = 1;
                next_i = i+1;
                next_j = j-1;
            end
        end
        if T1(i+1, j) == 1
            next_i = i+1;
            next_j = j;
            while T2(next_i, next_j) == 0 && T1(next_i, next_j) == 1 && next_i <= T2_row % extend in that direction
                final_image(next_i, next_j) = 1;
                next_i = i+1;
                next_j = j;
            end
        end
        if T1(i+1, j+1) == 1
            next_i = i+1;
            next_j = j+1;
            while T2(next_i, next_j) == 0 && T1(next_i, next_j) == 1 && next_i <= T2_row && next_j <= T2_col % extend in that direction
                final_image(next_i, next_j) = 1;
                next_i = i+1;
                next_j = j+1;
            end
        end
    end
end

figure
imshow(endpoints);
%}
figure
imshow(final_image);
%{
[final_image_row, final_image_col] = size(final_image);
visited = zeros(final_image_row, final_image_col);

for i = 2:final_image_row-1
    for j = 2:final_image_col-1
        visited(i, j) = 1;
        if final_image(i, j) == 1
            if T1(i-1) == 1;
                final_image(i
            
            if j > 1
                neighbor1 = T1(i, j-1);
            if j < T1_col
                neighbor2 = T1(i, j+1);
            end
        elseif sector == 1
            if i < T1_row && j > 1
                neighbor1 = T1(i+1, j-1);
            end
            if i > 1 && j < T1_col
                neighbor2 = T1(i-1, j+1);
            end
        elseif sector == 2
            if i < T1_row
                neighbor1 = T1(i+1, j);
            end
            if i > 1
                neighbor1 = T1(i-1, j);
            end
        else
            if i < T1_row && j < T1_col
                neighbor1 = T1(i+1, j+1);
            end
            if i > 1 && j > 1
                neighbor2 = T1(i-1, j-1);
            end
        end
%} 
