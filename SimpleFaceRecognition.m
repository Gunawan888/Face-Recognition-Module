%% Simple Face Recognition Example
%% Clear everything
clear
clc

%% To set up path to enable to use all function from subfolders.
MyPath = userpath;
MyDir = MyPath(1:strfind(MyPath,';')-1);
MyWorkDir = genpath(MyDir);
addpath(MyWorkDir, '-end');

%% Initial Settings

%% Load Image Information from ATT Face Database Directory

Database = menu('Select Database to use', 'FERET', 'ORL');

switch Database
    case 1
        faceDatabase = readDatabase('FERET');
        
        % Getting the mean of FERET Database
        thisImage = zeros(768,512);
        for i=1:size(faceDatabase,2)
            for k = 1 : faceDatabase(i).Count
                before = imread(faceDatabase(i).ImageLocation{k});
                after = rgb2gray(before);
                thisImage(:,:,k) = after;
            end
        end
        stackedImages = mean(thisImage,3);
        
    case 2
        faceDatabase = readDatabase('FaceDatabaseATT');  
        
        % Getting the mean of ORL Database
        thisImage = zeros(112,92,40);
        for i=1:size(faceDatabase,2)
            for k = 1 : faceDatabase(i).Count
                thisImage(:,:,k) = imread(faceDatabase(i).ImageLocation{k});
            end
        end
        stackedImages = mean(thisImage,3);
end



%% Split Database into Training & Test Sets
[training,test] = partition(faceDatabase,[0.7, 0.3]);

%% Feature Extraction
[trainingFeatures, trainingLabel, FeatExtraction, personIndex] = FeatureExtraction(training, stackedImages, Database);

%% Create the Classifier based on several options
faceClassifier = classification(trainingFeatures, trainingLabel);

%% Main Menu GUI

% please make each options into function

mainMenu = 1;
while(mainMenu < 4)
    mainMenu = menu('Main Menu', 'Recognize Picture', 'Test on 5 Image', 'Check Accuracy', 'Exit');
    switch mainMenu
        case 1
            % Call option 1: Select one picture from Test set to recognize
            experimentOnPicture(1, "experiment", test, training, FeatExtraction, faceClassifier, personIndex, stackedImages, Database);
        case 2
            % Call option 2: Select 5 pictures
            experimentOnPicture(5, "show", test, training, FeatExtraction, faceClassifier, personIndex, stackedImages, Database);
            
        case 3
            % Call option 3: Check Accuracy
            [predicted, real] = experimentOnPicture(size(test, 2), "", test, training, FeatExtraction, faceClassifier, personIndex, stackedImages, Database);
            
            [confmat, predictedFinal, realFinal] = createConfusionMatrix(predicted, real);
            % confusionchart(confmat)
            
            % Other Evaluation Method --> Accuracy, Recall, Precision and F1 Score
            evaluate(confmat, 1);
    end
end

%% Something
