
%numbers = int8(39*rand([1, 10]));

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
    

%{
for i=1:length(training_set)
    disp(training_set(i))
    img = imread(char(training_set(i)));
    [featureVector, hogVisualization] = extractHOGFeatures(img);
    figure;
    imshow(img); hold on;
    plot(hogVisualization);
end
%}

cellSize = 4 ;
numCluster = 500;
numSizeCodebook = 256;

feature_vector = [];
for i=1:length(training_set)
    img = imread(char(training_set(i)));
    hog = vl_hog(im2single(img), cellSize, 'verbose');
    [hog_rows, hog_cols, ~] = size(hog);
    reshaped_hog = reshape(hog, [hog_rows*hog_cols, 31]); % reshape so it can be processed with k-means
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

    final_image = zeros([size(I) 3]);
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

%{
I_single = im2single(I);
binSize = 8 ;
magnif = 3 ;
Is = vl_imsmooth(I_single, sqrt((binSize/magnif)^2 - .25)) ;

[f, d] = vl_dsift(Is, 'size', binSize) ;
                    

img = imread(char(training_set(1)));
nFiltSize=8;
nFiltRadius=1;
filtR=generateRadialFilterLBP(nFiltSize, nFiltRadius);
fprintf('Here is our filter:\n')
disp(filtR);
effLBP= efficientLBP(img, 'filtR', filtR, 'isRotInv', false, 'isChanWiseRot', false);
effRILBP= efficientLBP(img, 'filtR', filtR, 'isRotInv', true, 'isChanWiseRot', false);

uniqueRotInvLBP=findUniqValsRILBP(nFiltSize);
tightValsRILBP=1:length(uniqueRotInvLBP);
% Use this function with caution- it is relevant only if 'isChanWiseRot' is false, or the
% input image is single-color/grayscale
effTightRILBP=tightHistImg(effRILBP, 'inMap', uniqueRotInvLBP, 'outMap', tightValsRILBP);

binsRange=(1:2^nFiltSize)-1;
figure;
subplot(2,1,1)
hist(single( effLBP(:) ), binsRange);
axis tight;
title('Regular LBP hsitogram', 'fontSize', 16);

subplot(2,2,3)
hist(single( effRILBP(:) ), binsRange);
axis tight;
title('RI-LBP sparse hsitogram', 'fontSize', 16);

subplot(2,2,4)
hist(single( effTightRILBP(:) ), tightValsRILBP);
axis tight;
title('RI-LBP tight hsitogram', 'fontSize', 16);
%}
