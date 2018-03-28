function [report] = testingBills(billArray,rawBoards)
%This function takes a list of cut bills and tests them all on a set of
%boards. It records the average cuts per board

%billArray is a cell-array of cut bills; each cut bill is a two-column
%array
%rawBoards is a .mat file containing boards pre-cut-bill
testResults=[];

for i=1:length(billArray)
   fromSaw=testSaw(billArray{i},rawBoards);
   fromNester=testNester(billArray{i},fromSaw{1})
   testResults=[testResults;fromSaw{2},fromNester]
   disp(fromSaw{2});
end
report{1}=billArray;
report{2}=testResults;
end

