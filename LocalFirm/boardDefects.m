function [ x ] = boardDefects(  )
%generating a defective board
% (L-r,L+r)endpoints
pd = makedist('Poisson');  %to replace normal distribution with Poisson
t = truncate(pd, 1, inf); %truncates so that lambda is 1, thus ZTP Poisson
N=random(t); % changed from N=randi(5);
y=zeros(N,2);

for i=1:N
L=58*rand;
r=abs(normrnd(2.5,2)); %changed from r=abs(normrnd(2.5,2));
%normal dist may need to adjust/change
y(i,1)=max(L-r,0);
y(i,2)=min(L+r,58);
end

y= sort(y);

%smasher
x(1,:) = y(1,:);
for i=2:N
    if y(i,1)<=x(end,end)
        x(end,end)= max(y(i, end),x(end,end));
    else
        x=[x;y(i,:)];
    end

end

