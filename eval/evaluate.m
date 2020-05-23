function [F_1Score,Precision,Recall,accuracy] = evaluate (confmat, verbose)

[row, col] = size(confmat);

n_class=row;
switch n_class
    case 2
        TP=confmat(1,1);
        FN=confmat(1,2);
        FP=confmat(2,1);
        TN=confmat(2,2);
    otherwise
        TP=zeros(1,n_class);
        FN=zeros(1,n_class);
        FP=zeros(1,n_class);
        TN=zeros(1,n_class);
        for i=1:n_class
            TP(i)=confmat(i,i);
            FN(i)=sum(confmat(i,:))-confmat(i,i);
            FP(i)=sum(confmat(:,i))-confmat(i,i);
            TN(i)=sum(confmat(:))-TP(i)-FP(i)-FN(i);
        end
end

P=TP+FN;
N=FP+TN;

switch n_class
    case 2
        accuracy=(TP+TN)/(P+N);
        Error=1-accuracy;
    otherwise
        accuracy=(TP)./(P+N);
        Error=(FP)./(P+N);
end

Accuracy=sum(accuracy);
TrueNegativeRate=mean(TN./N);
FalsePositiveRate=mean(1-TrueNegativeRate);
Recall= TP./(TP+FN);
Recall(isnan(Recall))=[];
Recall=mean(Recall);
Precision = TP./(TP+FP);
Precision(isnan(Precision))=[];
Precision=mean(Precision);


F_1Score=(2*Recall*Precision)/(Recall+Precision);
if (verbose)
    fprintf("|-->  Accuracy == %f \n",Accuracy);
    fprintf("|-->  True Negative Rate == %f \n", TrueNegativeRate);
    fprintf("|-->  False Positive Rate == %f \n", FalsePositiveRate);
    fprintf("|-->  precision == %f \n",Precision);
    fprintf("|-->  recall == %f \n",Recall);
    fprintf("|-->  F1 == %f \n",F_1Score);
end
end
