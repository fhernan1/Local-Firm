function [] = Bargraphcomparison(filename, lambda, mu)
    %script to create bar graph comparing actual vs simulated results
    nBins = 60;
    % x = xlsread('actual.xlsx');%once files are read in can comment these lines out to run faster.
    load('actual.mat') % loads actual.xlsx data saved as variable x
    % x(x<9.9375)=[] %removes unneccessry values

    load(filename); % loads into variable saw
    y = saw;
    % y = csvread('sophielambda1.25.csv'); % or run lines 7-13 in the command window
    % y2 = randsample(y, length(x), true); % I believe that this bit up-samples our smaller, simulated data set

    % [~, bins] = hist( [x(:), y2(:)], nBins);
    % xCounts = hist(x, bins);
    % yCounts = hist(y2, bins);
    % bar(bins, xCounts, 'b', 'FaceAlpha', 0.5);
    % hold on;
    % bar(bins, yCounts, 'r', 'FaceAlpha', 0.5);
    % hold off;

    h1 = histogram(x);
    hold on
    h2 = histogram(y);
    h1.Normalization = 'probability';
    h1.BinWidth = 0.5;
    h2.Normalization = 'probability';
    h2.BinWidth = 0.5;
    legend('Actual', 'Simulation')
    hold off
    % h = kstest2(x, y) % komogorovsmirnov test 0 same dist, 1 different dist
   
    filename = strcat('histogram_lamdba', num2str(lambda), '_mu', num2str(mu), '.png');
%     savefig(strcat('histogram_lamdba', num2str(lambda), '_mu', num2str(mu), '.fig'))
    print(filename, '-dpng');
    
end
