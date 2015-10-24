%% Common

training_set = {'CroppedYale/yaleB02/yaleB02_P00A-005E-10.pgm';
                    'CroppedYale/yaleB07/yaleB07_P00A-085E+20.pgm';
                    'CroppedYale/yaleB10/yaleB10_P00A-015E+20.pgm';
                    'CroppedYale/yaleB11/yaleB11_P00A+035E+65.pgm';
                    'CroppedYale/yaleB12/yaleB12_P00A+060E+20.pgm';
                    'CroppedYale/yaleB15/yaleB15_P00A-060E+20.pgm';
                    'CroppedYale/yaleB19/yaleB19_P00A+095E+00.pgm';
                    'CroppedYale/yaleB22/yaleB22_P00A-050E+00.pgm';
                    'CroppedYale/yaleB23/yaleB23_P00A+050E-40.pgm';
                    'CroppedYale/yaleB33/yaleB33_P00A+120E+00.pgm'};
                
test_set = {'CroppedYale/yaleB15/yaleB15_P00A-010E-20.pgm';
            'CroppedYale/yaleB15/yaleB15_P00A-035E+15.pgm';
            'CroppedYale/yaleB15/yaleB15_P00A+020E-40.pgm';
            'CroppedYale/yaleB15/yaleB15_P00A+035E+15.pgm';
            'CroppedYale/yaleB15/yaleB15_P00A+050E+00.pgm';
            'CroppedYale/yaleB15/yaleB15_P00A-060E+20.pgm';
            'CroppedYale/yaleB15/yaleB15_P00A+085E-20.pgm';
            'CroppedYale/yaleB15/yaleB15_P00A+110E+65.pgm';
            'CroppedYale/yaleB15/yaleB15_P00A-070E-35.pgm';
            'CroppedYale/yaleB15/yaleB15_P00A-050E-40.pgm'};

cellSize = 4 ;
numCluster = 500;
numSizeCodebook = 256;

%% HOG
feature_vector = [];
for i=1:length(training_set)
    img = imread(char(training_set(i)));
    hog = vl_hog(im2single(img), cellSize, 'verbose');
    [hog_rows, hog_cols, hog_desc_size] = size(hog);
    reshaped_hog = reshape(hog, [hog_rows*hog_cols, hog_desc_size]); % reshape so it can be processed with k-means
    feature_vector = [feature_vector; reshaped_hog];
end

[idx,C] = kmeans(feature_vector, numCluster, 'Display','iter');

[counts, edges] = histcounts(idx, numCluster); % num bins is the number of clusters
[sortedCounts, sortedIndices] = sort(counts, 'descend'); % sort in descending order of frequency
highestCounts = sortedCounts(1:numSizeCodebook);
highestCountsIndices = sortedIndices(1:numSizeCodebook);
highestCountsCenters = C(highestCountsIndices,:);

colors = generate_nplus1_colors(numSizeCodebook); % generate colors according to the size of the codebook

for i=1:length(test_set)
    I_test = imread(char(test_set(i)));
    hog_test = vl_hog(im2single(I_test), cellSize, 'verbose') ;

    final_image = zeros([size(I_test) 3]);
    [hog_test_rows, hog_test_cols, ~] = size(hog_test);
    for i = 1:hog_test_rows
        for j = 1:hog_test_cols
            [idx, closestCenter] = find_closest_center(hog_test(i, j, :), C);
            [Lia, countIdx] = ismember(idx, highestCountsIndices);
            color_index = numSizeCodebook + 1;
            if countIdx > 0
                color_index = countIdx; % expect only one element since values in highestCountsIndices are unique
            end
            for k = (i-1)*cellSize+1:i*cellSize
                for l = (j-1)*cellSize+1:j*cellSize
                    final_image(k, l, :) = colors(color_index);
                end
            end
        end
    end
    figure;
    imshow(I_test);
    figure;
    imshow(final_image, []);
end

%% DSIFT
binSize = 2 ;
magnif = 1 ;

feature_vector = [];
for i=1:length(training_set)
    img = imread(char(training_set(i)));
    img_resized = imresize(img, 0.25);
    I_single = im2single(img_resized);
    Is = vl_imsmooth(I_single, sqrt((binSize/magnif)^2 - .25)) ;
    figure;
    imshow(Is);
    [f, d] = vl_dsift(Is, 'size', binSize, 'geometry', [2 2 4]) ;
    
    d = im2double(d);
    feature_vector = [feature_vector; d'];
end

[idx,C] = kmeans(feature_vector, numCluster, 'Display','iter');

[counts, edges] = histcounts(idx, numCluster); % num bins is the number of clusters
[sortedCounts, sortedIndices] = sort(counts, 'descend'); % sort in descending order of frequency
highestCounts = sortedCounts(1:numSizeCodebook);
highestCountsIndices = sortedIndices(1:numSizeCodebook);
highestCountsCenters = C(highestCountsIndices,:);

colors = generate_nplus1_colors(numSizeCodebook); % generate colors according to the size of the codebook


for i=1:length(test_set)
    I_test = imread(char(test_set(i)));
    
    I_single = im2single(I_test);
    Is = vl_imsmooth(I_single, sqrt((binSize/magnif)^2 - .25)) ;
    [f, d] = vl_dsift(Is, 'size', binSize, 'geometry', [2 2 4]) ;
    d = d';
    
    final_image = zeros([size(I_test) 3]);
    [d_rows, d_cols] = size(d);
    
    for r = 1:d_rows
        [idx, closestCenter] = find_closest_center(d(r, :), C);
        [Lia, countIdx] = ismember(idx, highestCountsIndices);
        color_index = numSizeCodebook + 1;
        if countIdx > 0
            color_index = countIdx; % expect only one element since values in highestCountsIndices are unique
        end
        int_part = fix(r/168);
        remainder = rem(r, 168);
        final_image(int_part+1, remainder+1, :) = colors(color_index);
    end
    figure;
    imshow(I_test);
    figure;
    imshow(final_image, []);
end


%% LBP
img = imread(char(training_set(1)));
I_single = im2single(img);

f = vl_lbp(I_single, cellSize);
feature_vector = [];
for i=1:length(training_set)
    img = imread(char(training_set(i)));
    f = vl_lbp(I_single, cellSize);
    [f_rows, f_cols, f_desc_size] = size(f);
    reshaped_f = reshape(f, [f_rows*f_cols, f_desc_size]); % reshape so it can be processed with k-means
    feature_vector = [feature_vector; reshaped_f];
end

[idx,C] = kmeans(feature_vector, numCluster, 'Display','iter');

[counts, edges] = histcounts(idx, numCluster); % num bins is the number of clusters
[sortedCounts, sortedIndices] = sort(counts, 'descend'); % sort in descending order of frequency
highestCounts = sortedCounts(1:numSizeCodebook);
highestCountsIndices = sortedIndices(1:numSizeCodebook);
highestCountsCenters = C(highestCountsIndices,:);

colors = generate_nplus1_colors(numSizeCodebook); % generate colors according to the size of the codebook

for i=1:length(test_set)
    I_test = imread(char(test_set(i)));
    f_test = vl_lbp(im2single(I_test), cellSize) ;

    final_image = zeros([size(I_test) 3]);
    [f_test_rows, f_test_cols, ~] = size(f_test);
    for i = 1:f_test_rows
        for j = 1:f_test_cols
            [idx, closestCenter] = find_closest_center(f_test(i, j, :), C);
            [Lia, countIdx] = ismember(idx, highestCountsIndices);
            color_index = numSizeCodebook + 1;
            if countIdx > 0
                color_index = countIdx; % expect only one element since values in highestCountsIndices are unique
            end
            for k = (i-1)*cellSize+1:i*cellSize
                for l = (j-1)*cellSize+1:j*cellSize
                    final_image(k, l, :) = colors(color_index);
                end
            end
        end
    end
    figure;
    imshow(I_test);
    figure;
    imshow(final_image, []);
end