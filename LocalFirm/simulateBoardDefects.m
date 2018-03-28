function [boardList, place] = simulateBoardDefects(numBoards, lambda, mu)

pd = makedist('Poisson', 'lambda', lambda); %determines number of defects per board
% nd = makedist('Normal','mu', 2.5, 'sigma',2); %makes modifications to defect location and size
ed = makedist('Exponential', 'mu', mu);

t = truncate(pd,1,inf); %truncates so that lambda is 1, thus ZTP Poisson
t2 = truncate(ed, 0.1, 58);

% tn= truncate(nd,0,4);
boardList = zeros(3*numBoards,2);
place=1;
tic;

N = random(t, numBoards, 1);
radi = random(t2, numBoards, 20);

printInterval = max(10^5, numBoards / 20);
for i = 1:numBoards
    if mod(i, printInterval) == 0
        fprintf('Simulating the %d -th board...', i);
        toc
        tic;
    end
    Ni=N(i); % changed from N=randi(5);
    y=zeros(Ni,2);
    
    rands = rand(Ni, 1);
    
    for j=1:Ni
        L=58*rands(j);
        %r=random(tn); %changed from r=abs(normrnd(2.5,2));
        rij = radi(i, min(20,j));
        %normal dist may need to adjust/change
        y(j,1)=max(L-rij,0);
        y(j,2)=min(L+rij,58);
    end

    y= sort(y);
    %smasher
    b=[];
    b(1,:) = y(1,:);
    for j=2:Ni
        if y(j,1)<=b(end,end)
            b(end,end)= max(y(j, end),b(end,end));
        else
            b=[b;y(j,:)];
        end
    end

    if b(1,1) ~= 0
        boardList(place,:) = [b(1,1),1];
        place=place+1;
    end
    for j = 2:size(b,1)
        boardList(place,:) = [b(j,1)-b((j-1),2),2];
        place=place+1;
    end
    if b(end, end) ~= 58
        boardList(place,:) = [58-b(end,end),1];
        place=place+1;
    end
end               
toc

end