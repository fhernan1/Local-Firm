function [ truefalse ] = cutBill( bill, checkBoard )
%Checking the cut bill/ T or F

truefalse = false;
for i = 1:size(bill,1)
    if checkBoard < bill(i,1)
      return
    end
    if checkBoard <= bill(i,2)
        truefalse = true;
      return
    end
end

