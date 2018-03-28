function [results] = testNester(bill, franciscosBoards )

x = franciscosBoards; %excel file that is being inputed in command line
x(x<1) = [];
statsBucket = zeros(1,60);
place = 1;
lane = zeros(1,42);
%decks = zeros(length(x),1); 
%decks=[];
%drops=0;
Lanes = zeros(1,42);
startTime = tic;
nestingRate = [];
%freeLanes=[];
dropPriority=zeros(1,42);
%mList=[];
%shortsAdded=0;
%laneFlushPlaces=[];
laneFlushes=0;
shortestShort=bill(1,1)-2*.40625;
billLength=0;
for i=1:length(bill)
    billLength=billLength+bill(i,2)-bill(i,1);
end
genericOdds=1/billLength;

%fill statsBucket using the first 500 boards

for i=1:500
        statsBucket(round(x(i))) = statsBucket(round(x(i))) +1;
end

while (place <= length(x))
%************BEGIN STATSBUCKET HANDLING
    
    if place > 500
            statsBucket(round(x(place))) = statsBucket(round(x(place))) + 1;
            trailer = round(x(place -500));
            statsBucket(trailer) = statsBucket(trailer) -1;
     end
%***********END STATSBUCKET HANDLING     

%If the board is at least 47" and there's an empty lane, just make (half) a deck
%from the board.
     if (x(place) >= 47) && (~isempty(lane(lane == 0)))
%         decks = [decks; x(place)];
%         drops = drops+1;
         place=place+1;
         continue;
     end
%Otherwise we look at what happens to each lane when we add the board to it.         
         Lanes = lane+x(place);
%Each lane will be assigned a drop priority.
         dropPriority=zeros(1,42);
        
         for i = 1:42
                   
             %completing a lane is top priority (Level 3)
             if (Lanes(i)>=54)&&(Lanes(i)<=60)
                dropPriority(i)=3;
             end
             
             %if the lane isn't full but there's a decent probability (as
             %measured by statsBucket) of another board filling the lane in
             %the near future, we get priority Level 2.
             r = ceil(54 - Lanes(i));
            if r > 0 
                v = sum(statsBucket(r:min(r+6,60)));
                if (v >= (500*7)/60) 
                    dropPriority(i)=2;
                end
            end
            %the possibility of completing the lane with some shorts is a
             %lower priority (Level 1)
             %if ((Lanes(i) >= 36) && (Lanes(i) <=42))||((Lanes(i) >= 27) && (Lanes(i) <=33))||((Lanes(i) >= 18) && (Lanes(i) <=24))
             if ((Lanes(i) >= 60-2*shortestShort) && (Lanes(i) <=60-shortestShort))
                dropPriority(i)=1;
             end
             
             %if the lane isn't full but there's a decent probability (as
             %measured by statsBucket) of another board filling the lane in
             %the near future, we get priority Level 2.
             r = ceil(54 - Lanes(i));
            if r > 0 
                completeOdds = sum(statsBucket(r:min(r+6,60)))/500;
                if (completeOdds >= genericOdds) 
                    dropPriority(i)=2;
                end
            end
            %if the lane isn't full but there would be no chance of filling
            %the lane, we get priority Level -1, which should NEVER result
            %in a drop.
            if (Lanes(i)>50)&&(Lanes(i)<54)
                dropPriority(i)=-1;
            end
            %if the lane overflows, again priority level is -1. Again, this
            %should NEVER result in a drop.
            if Lanes(i)>60
               dropPriority(i)=-1; 
            end
         end      
         
   [M,I] = max(dropPriority);
%   mList=[mList;M];
   if M>-1
    lane(I) = lane(I) + x(place);
 %   drops =drops+1;
    place = place + 1;
    if (lane(I) >= 54)
%        decks = [decks; lane(I)];
        lane(I) = 0;
    end
   else
%        disp('nester failed')
%        disp(lane)
%        disp(place)
%        disp(x(place-10:place))
%        break
          lane=zeros(1,42);
%          disp('flushed lanes')
%          laneFlushPlaces=[laneFlushPlaces;place];
            laneFlushes=laneFlushes+1;
   
   end
    if mod(place,10) == 0
        nestingRate = [nestingRate; sum(lane)/2520];
%         if nestingRate>.7
%             lane=zeros(1,42);
%             disp('flushed lanes')
%             laneFlush=laneFlush+1;
%          if nestingRate(end)>.4
%             for j=1:2
%             [longest,spot]=max(lane);
%             decks = [decks; max(lane(spot)+9,54)];
%             lane(spot) = 0;
%             disp('added a short at place ')
%             disp(place);
%             shortsAdded=shortsAdded+1;
%             end
%         end
        %disp(nestingRate);
        %freeLanes=[freeLanes;size(lane(lane==0))];
        %disp(lane);
    end
end
%decks(decks<1)=[];
%save('nestingrate.mat', 'nestingRate');
%save('decks.mat', 'decks');
%save('mlist.mat','mList');
%save('laneflushes.mat','laneFlushPlaces');
toc(startTime)
%disp(drops/place);
%disp('shorts added');
%disp(shortsAdded);
%disp('Lane Flushes');
%disp(length(laneFlushPlaces));
meanNestingRate=mean(nestingRate);
maxNestingRate=max(nestingRate);
timesAbove60=length(nestingRate(nestingRate>0.6));
results=[meanNestingRate,maxNestingRate,timesAbove60,laneFlushes];
end

