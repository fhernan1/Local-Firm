function [ yield ] = boardYield( numBoards, bill, lambda, mu)
%This function performs the mandatory cuts
%yield and boards
%input example boardYield(2000, [10.75 24; 29 30; 39 41.5; 49 58])
% the above example is the actual cut bill

% you can leave off the arguments to get the following defaults:
if ~exist('numBoards', 'var')
    numBoards = 10^5;
end
if ~exist('bill', 'var')
    bill = [10.75 24; 29 30; 39 41.5; 49 58];
end
if ~exist('lambda', 'var')
    lambda = 0.5;
end
if ~exist('mu', 'var')
    mu = 0.25;
end

startTime = tic;

[boardList, place] = simulateBoardDefects(numBoards, lambda, mu);

boardSet = boardList(1:(place-1),:);
filename = strcat('euclid_lambda_', num2str(lambda), '_mu_', num2str(mu), '.mat');
save(filename, 'boardSet');
disp(strcat('Saved boardSet into...', filename));

% csvwrite('euclid.csv', boardList(1:(place-1),:));

saw = Saw(bill, filename);
disp('Finished Saw()')

% csvwrite('sophielambda1.25.csv', saw);
 filename = strcat('sophie_lambda_', num2str(lambda), '_mu_', num2str(mu), '.mat');
 save(filename, 'saw');
 
yield=sum(saw)/(58*numBoards);

Bargraphcomparison(filename, lambda, mu);

disp('Finished script in...')
toc(startTime)

end

