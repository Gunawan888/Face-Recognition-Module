function [confmat, predictedFinal, realFinal] = createConfusionMatrix(predicted, real)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
predictedFinal = [];
realFinal = [];

for i=1:size(real,1)
    predictedFinal = [predictedFinal, predicted(i,:)];
    realFinal = [realFinal, real(i,:)];
end

confmat = confusionmat(realFinal, predictedFinal);

end

