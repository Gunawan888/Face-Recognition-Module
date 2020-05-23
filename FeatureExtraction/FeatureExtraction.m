% TODO: Need to work around the FeatExtraction, should not need to pass it
% back.
function [trainingFeatures,trainingLabel, FeatExtraction, personIndex] = FeatureExtraction(training, stackedImages, Database)

%   Detailed explanation goes here
FeatExtraction=menu('Choose Feature Extraction Method','HOG','LBP','PCA');

% Create Array to store feature
trainingFeatures = [];
trainingLabel = [];
personIndex = [];

% Count feature from the first image in training
featureCount = 1;

switch FeatExtraction
    
    % select HOG
    case 1
        for i=1:size(training,2)
            for j = 1:training(i).Count
                p = histeq(read(training(i),j));
                trainingFeatures(featureCount,:) = extractHOGFeatures(p);
                trainingLabel{featureCount} = training(i).Description;
                featureCount = featureCount + 1;
            end
            personIndex{i} = training(i).Description;
        end
        
    % select LBP
    case 2
        for i=1:size(training,2)
            for j = 1:training(i).Count
                % Binarize the picture before feature extraction
                after = im2bw(read(training(i),j));
                trainingFeatures(featureCount,:) = extractLBPFeatures(after);
                trainingLabel{featureCount} = training(i).Description;
                featureCount = featureCount + 1;
            end
            personIndex{i} = training(i).Description;
        end
        
    % select PCA
    case 3
        for i=1:size(training,2)
            for j=1:training(i).Count
                
                % IF FERET, transform queryImage to 2D
                switch Database
                    case 1
                        before = imread(training(i).ImageLocation{j});
                        thisImage = rgb2gray(before);
                    case 2
                        thisImage = imread(training(i).ImageLocation{j});
                end 
                
                
                t = single(double(thisImage) - stackedImages);
                shifted_images = cov(t);
                [evectors, evalues] = eig(shifted_images);
                ev = single(thisImage) * evectors;
                
                % Get the maximum eigenvector
                N=1;
                input = ev(:,end:-1:end-(N-1));
                
                trainingFeatures(featureCount, :) = input;
                trainingLabel{featureCount} = training(i).Description;
                featureCount = featureCount + 1;
            end
            personIndex{i} = training(i).Description;
        end
end

end

