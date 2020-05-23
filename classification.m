function [faceClassifier] = classification(trainingFeatures, trainingLabel)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
classifier = menu('Choose the Classifier','SVM','KNN','Ensemble','Tree','Naive Bayes');
            
switch classifier
    % Select SVM
    case 1
        svmParams = templateSVM('KernelFunction','rbf', 'KernelScale', 'auto', 'Standardize', 1);
        faceClassifier = fitcecoc(trainingFeatures,trainingLabel,'Learners', svmParams, 'Coding', 'onevsall');
    
    % Select KNN
    case 2
        faceClassifier = fitcknn(trainingFeatures,trainingLabel, 'Distance', 'euclidean', 'DistanceWeight', 'squaredinverse');
    
    % Select Ensemble 
    case 3
        t = templateTree('MaxNumSplits',7);
        faceClassifier = fitcensemble(trainingFeatures,trainingLabel,'Learners',t);
    
    % Select Decision Tree 
    case 4
%         t = templateTree('MaxNumSplits',7);
        faceClassifier = fitctree(trainingFeatures,trainingLabel);

    % Select Naive Bayes
    case 5
        faceClassifier = fitcnb(trainingFeatures,trainingLabel, 'DistributionNames', 'kernel', 'Optimize');
end
end

