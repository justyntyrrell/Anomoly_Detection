function [bestEpsilon bestF1] = selectThreshold(yval, pval)
%SELECTTHRESHOLD Find the best threshold (epsilon) to use for selecting
%outliers
%   [bestEpsilon bestF1] = SELECTTHRESHOLD(yval, pval) finds the best
%   threshold to use for selecting outliers based on the results from a
%   validation set (pval) and the ground truth (yval).
%

bestEpsilon = 0;
bestF1 = 0;
F1 = 0;

%Choose stepsize for incrementing  
stepsize = (max(pval) - min(pval)) / 1000;

%Loop through each epsilon to calculate each F Score
for epsilon = min(pval):stepsize:max(pval)
    
    %find cross validation predictions. Any probability in pval less then epsilon labeled as an anomaly
    cvprediction = pval < epsilon;
    
    %calculate true positives
    tp = sum(cvprediction == yval & yval == 1);
    %calculate false positives
    fp = sum(cvprediction = not(yval) & cvprediction == 1);
    %Calculate false negatives
    fn = sum(cvprediction = not(yval) & yval == 1);
    
    %calculate precicsion
    prec = tp / (tp + fp);
    
    %calculate recall
    rec = tp / (tp + fn);
    
    %calculate F1 score
    F1 = (2 * prec * rec) / (prec + rec);
    
    % update epsilon based on F1 score
    if F1 > bestF1
       bestF1 = F1;
       bestEpsilon = epsilon;
    end
end

end
