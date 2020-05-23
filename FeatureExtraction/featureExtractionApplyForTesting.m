function [queryFeatures] = featureExtractionApplyForTesting(FeatExtraction, queryImage, stackedImages, Database)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
switch FeatExtraction
    % HOG
    case 1
        after = histeq(queryImage);
        queryFeatures = extractHOGFeatures(after);
    % LBP
    case 2
        after = im2bw(queryImage);
        queryFeatures = extractLBPFeatures(after);
        
    case 3
        % IF FERET, transform queryImage to 2D
        switch Database
            case 1
                after = rgb2gray(queryImage);
            case 2
                after = queryImage;
        end
        
        t = single(double(after) - stackedImages);
        shifted_images = cov(t);
        [evectors, evalues] = eig(shifted_images);
        ev = single(after) * evectors;
        
        % Get the maximum eigenvectors
        N=1;
        input = ev(:,end:-1:end-(N-1));
        queryFeatures = input';
        
end
end

