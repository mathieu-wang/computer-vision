
numbers = int8(39*rand([1, 10]));

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
                    
%{
I = imread(char(training_set(1)));
[featureVector, hogVisualization] = extractHOGFeatures(I);
I_single = im2single(I);
binSize = 8 ;
magnif = 3 ;
Is = vl_imsmooth(I_single, sqrt((binSize/magnif)^2 - .25)) ;

[f, d] = vl_dsift(Is, 'size', binSize) ;
%}

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


