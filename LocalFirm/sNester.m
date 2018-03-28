function [  ] = sNester( franciscosBoards )

x = importdata(franciscosBoards); %excel file that is being inputed in command line
x(x<1) = [];
statsBucket = zeros(1,500);
place = 1;
lane = zeros(1,42);
decks = zeros(length(x),1); 
drops=0;
Lanes = zeros(1,42);
startTime = tic;
nestingRate = [];
while (place <= length(x))
   
    for i=1:500
        statsBucket(round(x(i))) = statsBucket(round(x(i))) +1;
    end
    
    if place > 500
            statsBucket(round(x(place))) = statsBucket(round(x(place))) + 1;
            trailer = round(x(place -500));
            statsBucket(trailer) = statsBucket(trailer) -1;
     end
     
     if (x(place) >= 47) && (~isempty(lane(lane == 0)))
         decks = [decks; x(place)];
         drops = drops+1;
     else
         Lanes = lane+x(place);
        
         for i = 1:42
             r = ceil(54 - Lanes(i));
            if r > 0 
                v = sum(statsBucket(r):min(r+6,60));
                if v < (500*(min(r+6,60)- r+1))/60 && ~((Lanes(i) >= 36) && (Lanes(i) <=42))
                    Lanes(i) = 0;
                end
            end
         end
        if mod(place,100) == 0
            nestingRate = [nestingRate; sum(lane)/2520];
            disp(lane)
        end
         Lanes(Lanes>60) = -1;
   [M,I] = max(Lanes);
   lane(I) = lane(I) + x(place);
   drops =drops+1;
   if (lane(I) >= 54)
   decks = [decks; lane(I)];
   lane(I) = 0;
  
   end       
         
     end
     
    
           
place = place + 1;


end
decks(decks<1)=[];
save('nestingrate.mat', 'nestingRate');
save('decks.mat', 'decks');
toc(startTime)
end

