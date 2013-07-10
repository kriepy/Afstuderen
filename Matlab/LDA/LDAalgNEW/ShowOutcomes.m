%% Show the outcomes for BOW and Clusters

% load('OutcomeExp1Clus.mat')
% for HN=1:5
%     
%     plot(10:5:100,DataClus{HN}.perCLUSm)
%     hold on
% end

%% Show for clusters 2

load('OutcomeExp2Clus')
figure(1)
for HN=1:5
    plot(2:10,DataClus2{HN}.perClusM)
    hold on
end