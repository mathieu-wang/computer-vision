
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

disp(length(training_set))
for i=1:length(training_set)
    disp(training_set(i))
    img = imread(char(training_set(i)));
    [featureVector, hogVisualization] = extractHOGFeatures(img);
    figure;
    imshow(img); hold on;
    plot(hogVisualization);
end