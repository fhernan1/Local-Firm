function [ decks ] = Nester( franciscosBoards )

x = importdata(franciscosBoards); %excel file that is being inputed in command line
x(x<1) = [];
cat = zeros(1,100);
statsBucket = [0,0,0,0,0,0,0,0,0,59,27,16,29,31,27,26,25,16,18,17,17,17,18,23,0,0,0,8,39,5,0,0,0,0,0,0,0,0,5,6,5,0,0,0,0,0,0,0,5,7,8,7,7,8,6,6,7,3,2,0];
actualBucket = zeros(1,60);
place = 1;
i = 0;
GAP = 5; %Not sure if useful, GAP is space where there is no lane underneath
% caterpillar legs
meanBoardLength = 23;
lane = zeros(1,42);
decks = [];
drops=0;
clawconflicts=0;

while (place <= length(x))
   
    if(cat(mod(place, 100) + 1)~=0)
%         disp('occupied claw')
        clawconflicts=clawconflicts+1;
    end
    cat(mod(place, 100) + 1) = x(place);
    if place < 500
        actualBucket(round(x(place))) = actualBucket(round(x(place))) +1;
    end
     if place == 500
          statsBucket = actualBucket;
     end
     if place > 500
            statsBucket(round(x(place))) = statsBucket(round(x(place))) + 1;
            trailer = round(x(place -500));
            statsBucket(trailer) = statsBucket(trailer) -1;
            %meanBoardLength = meanBoardLength + (x(place) - x(place - 500)) ./ 500;
        end
   
    for (j = 0:27)
        if (cat(mod(place + j, 100)+1)==0) %If the claw is empty do nothing
            continue
        end
        if (cat(mod(place + j, 100)+1) >= 47) && (lane(j+1) == 0)
             disp('dropped')
            drops=drops+1;
            disp(place)
            decks = [decks; cat(mod(place + j, 100)+1)];
            cat(mod(place + j, 100)+1) = 0;
        
            
        elseif dropFunction(cat(mod(place + j, 100)+1) + lane(j+1:42), statsBucket) 
            disp('dropped')
            drops=drops+1;
            disp(place)
            lane(j+1) = lane(j+1) + cat(mod(place + j, 100)+1);
            cat(mod(place + j, 100)+1) = 0;
            if (lane(j+1) >= 54)
            decks = [decks; lane(j+1)];
            lane(j+1) = 0;
            end
            
        end
    end
        for(j = 28:41)
            if (cat(mod(place + j+GAP, 100)+1)==0)
            continue
            end
        if (cat(mod(place + j+ GAP, 100)+1) >= 47) && (lane(j+1) == 0)
             disp('dropped')
             disp(place)
            drops=drops+1;
            decks = [decks; cat(mod(place + j + GAP, 100)+1)];
            cat(mod(place + j + GAP, 100)+1) = 0;
        
        elseif dropFunction(cat(mod(place + j + GAP, 100)+1) + lane(j+1:42), statsBucket)
              lane(j+1) = lane(j+1) + cat(mod(place + j + GAP, 100)+1);
              cat(mod(place + j + GAP, 100)+1) = 0;
              disp('dropped')
              disp(place)
            drops=drops+1;
            if (lane(j+1) >= 54)
            decks = [decks; lane(j+1)];
            lane(j+1) = 0;
            end
            
        end
        end
place = place + 1;
end

disp(lane)
disp('drops:')
disp(drops)
disp('clawconflicts')
disp(clawconflicts)
disp('Current place')
disp(place)
% disp('mean board length')
% disp(meanBoardLength)
% disp('elements of sophie greater than the meanBoardLength')
% disp(sum(x > meanBoardLength))
csvwrite('decks.csv', decks)
end
