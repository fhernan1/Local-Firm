function [ dropornot ] = dropFunction( Lanes, statsBucket )
%Our skeleton for the nester's drop logic
dropornot = false;

% if (Lanes(1) < 47)
%     dropornot = true;
%    return
% end


if Lanes(1) > 60
    dropornot = false;
    return 
end
    
if Lanes(1) >= 54 
        dropornot = true;
        disp('fill drop')
        return
elseif (Lanes(1) >= 36) && (Lanes(1) <=42) %drop the piece if two more shorts would complete the lane
        dropornot = true;
        disp('double drop')
        return
elseif Lanes(1) >= 50.25
    dropornot = false;
    return
    
end
    
Lanes(Lanes > 60) = 0;
%Lanes(47-Lanes >= statsBucket) = 0;
for i=1:length(Lanes)
    r = round(54 - Lanes(i));
    if r > 0        
    x = sum(statsBucket(r:min(r+6,60)));
    if x < (500*(min(r+6,60)-r+1))/60
        Lanes(i) = 0;
    end
    end
end
% disp(Lanes)        
if Lanes(1) == max(Lanes)        
    dropornot = true;
    disp('maxdrop')
    return
end
    
    
end