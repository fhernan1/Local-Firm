function [splits] = attemptSplit(bill, j, currBoardLen, amountToSaw)
    splits = [0, 0];
    
    minCut = bill(j, 1);
    maxCut = bill(j, 2);
    midCut = mean([minCut, maxCut]);

    canCutMin = cutBill(bill, currBoardLen - minCut);
    canCutMax = cutBill(bill, currBoardLen - maxCut);
    canCutMid = cutBill(bill, currBoardLen - midCut); 

    % This can be improved to allow for something between minCut and
    % maxCut. For example, if currBoardLen = 50 and bill = [ [10,15] , [30, 45] ]
    % then (for j = 2), minCut = 30 and maxCut = 45. Then canCutMax and
    % canCutMin both return 0, because cutting 45 would leave 5 and
    % cutting 30 would leave 20, neither of which is within cut bill.
    % However, cutting something between [30, 45], namely 40, would be
    % ideal. Currently, the below code doesn't allow that.

    % if the current bill's middle is less than half of 58inch board,
    % then we'd prefer cutting in order of min, mid, max. If it's more
    % than half, then we'd prefer cutting in order of max, mid, min.
    if midCut < 29
        if canCutMin == 1
            splits(1) = max(0, currBoardLen - minCut - amountToSaw(1));
            splits(2) = max(0, minCut - amountToSaw(2));
%         elseif canCutMid == 1
%             splits(1) = max(0, currBoardLen - midCut - amountToSaw(1));
%             splits(2) = max(0, midCut - amountToSaw(2));
        elseif canCutMax == 1
            splits(1) = max(0, currBoardLen - maxCut - amountToSaw(1));
            splits(2) = max(0, maxCut - amountToSaw(2));
        end
    else
        if canCutMax == 1
            splits(1) = max(0, currBoardLen - maxCut - amountToSaw(1));
            splits(2) = max(0, maxCut - amountToSaw(2));
%         elseif canCutMid == 1
%             splits(1) = max(0, currBoardLen - midCut - amountToSaw(1));
%             splits(2) = max(0, midCut - amountToSaw(2));
        elseif canCutMin == 1
            splits(1) = max(0, currBoardLen - minCut - amountToSaw(1));
            splits(2) = max(0, minCut - amountToSaw(2));
        end
    end
end