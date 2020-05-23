function [predicted, real] = experimentOnPicture(trySize, choice, test, training, FeatExtraction, faceClassifier, personIndex, stackedImages, Database)
%   Detailed explanation goes here

if strcmp(choice, "experiment")
    prompt1 = 'Enter index of test set (1-40)';
    prompt2 = strcat('Choose between Pict 1-',  num2str(test(1).Count));
    num1 = inputdlg(prompt1);
    num2 = inputdlg(prompt2);
    index1 = str2double(num1{:});
    index2 = str2double(num2{:});
end
predicted = [];
real = [];

% Get the image from test set and extract the features
figureNum = 1;
for person=1:trySize
    for j = 1:test(person).Count
        queryImage = read(test(person),j);
        if strcmp(choice, "experiment")
            queryImage = read(test(index1),index2);
        end
        
        queryFeatures = featureExtractionApplyForTesting(FeatExtraction, queryImage, stackedImages, Database);
        
        personLabel = predict(faceClassifier,queryFeatures);
        booleanIndex = strcmp(personLabel, personIndex);
        integerIndex = find(booleanIndex);
        predicted(j, person) = integerIndex;
        real(j, person) = person;
        
        %IF we are trying to show something.
        if strcmp(choice,"show")
            subplot(2,2,figureNum);
            imshow(imresize(queryImage,3));title('Query Face');
            subplot(2,2,figureNum+1);
            imshow(imresize(read(training(integerIndex),1),3));title('Matched Class');
        end
    end
    if strcmp(choice,"show")
        figure;
        figureNum = 1;
    end
end


if strcmp(choice, "experiment")
    % Label of real images
    realLabel = test(index1).Description;
    
    % Label of predicted images
    index = predict(faceClassifier,queryFeatures);
    personLabel = index{1};
    
    % Map back to training set to find identity
    booleanIndex = strcmp(personLabel, personIndex);
    integerIndex = find(booleanIndex);
    subplot(1,2,1);
    imshow(queryImage);title('Query Face');
    subplot(1,2,2);
    imshow(read(training(integerIndex),1));title('Matched Class');
    
    % Check if its the same
    valid = strcmp(realLabel,personLabel);
    % Check if the prediction is correct
    if(valid)
        a = msgbox(['This person is indeed ' personLabel], 'Correct!!!');
    else
        a = msgbox(['This person is actually ' realLabel ', not ' personLabel] , 'Wrong!!!');
    end
    
end
end

