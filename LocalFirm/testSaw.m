function [ outFromSaw] = Saw(bill, inputfile)
% cut bill time
% add counter to keep track of "cuts" per board
% must add "kerf' to compensate for profiling
% therefore sophie.csv has values below 10"
% boardSet = csvread(inputfile);
load(inputfile); % loads into boardSet
franciscosBoards=zeros(size(boardSet,1),1);
place=1;
cutsMade = 0;
boardsInCutBill = 0;
 
for i=1:size(boardSet,1)
    currBoardLen = boardSet(i,1);
    sidesToSaw = boardSet(i, 2);
    if cutBill(bill, currBoardLen)
        franciscosBoards(place)= currBoardLen - sidesToSaw*.40625;
        place=place+1;
        boardsInCutBill= boardsInCutBill+1;
        continue
    end
   
    sawUnit = 0.40625;
    amountToSaw = [0, 0];
    if sidesToSaw == 2
        amountToSaw = [2*sawUnit, 2*sawUnit];
    else
        n = randi(2);
        amountToSaw = [n*sawUnit, (3-n)*sawUnit];
    end
 
   splits = [0, 0];
   for j=1:size(bill,1)
        splitAttempt = attemptSplit(bill, j, currBoardLen, amountToSaw);
        if max(splitAttempt) > max(splits)
            splits = splitAttempt;
            break;
        end
   end
   for j=size(bill,1):-1:1
        splitAttempt = attemptSplit(bill, j, currBoardLen, amountToSaw);
        if max(splitAttempt) > max(splits)
            splits = splitAttempt;
            break;
        end
   end
   if max(splits) > 0
       franciscosBoards(place) = splits(1);
       place=place+1;
       franciscosBoards(place) = splits(2);
       place=place+1;
       cutsMade = cutsMade +1;
   end
end
franciscosBoards=franciscosBoards(1:(place-1));
%disp('Boards in Bill')
%disp(boardsInCutBill)
%disp('cuts')
%disp(cutsMade)
%disp('Cuts per board')
%boardsTooSmall= sum(boardSet(:,1)<bill(1,1));
%avgCutsPB=cutsMade/(length(boardSet)-boardsTooSmall);
%disp(avgCutsPB)
outFromSaw{1}=franciscosBoards;
outFromSaw{2}=cutsMade;
end