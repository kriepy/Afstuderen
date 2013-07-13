clear all
close all
%% Show the outcomes for BOW and Clusters

% load('OutcomeExp1Clus.mat')
% for HN=1:5
%     
%     plot(10:5:100,DataClus{HN}.perCLUSm)
%     hold on
% end

%% Show for clusters 2

% load('OutcomeExp2Clus')
% figure(1)
% for HN=1:5
%     plot(2:10,DataClus2{HN}.perClusM)
%     hold on
% end

%% Show for clusters 1
%load OutcomeExp1_2ClusV8
load OutcomeExp1_4ClusV6
figure(1)
    for HN=1:5
    plot(DataClus{HN}.perCLUSm)
    hold on
end

%% Visualize the topic distribution Training and HO set
