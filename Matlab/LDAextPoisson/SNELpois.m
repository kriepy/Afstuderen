close all
clear all
%% INITIALIZE
k=20;
maxIter=50;
HN=1; % there are in total five houses
TS=48; % Amount of time slices
V=6;
coarse=2;

%% LOAD DATA
% addpath ../Data/Old/ALGtranExtData
% d=transExtData;
%% Laad de data
try
    %load the clustered Data
    path = '../Data/DATAClustered/';
    load(strcat([path,'Clustered',num2str(V),'TS',num2str(TS),'Coarse', num2str(coarse),'.mat']));
    H=House{HN};
catch
    % if that is not possible create the clustered data
    fprintf(1,'Starting to make the Clusters ');
    load ../Data/DATAMain/sepDays.mat
    addpath ../Data/ALGClusteren
    d=ClusterIt(House,HN,TS,coarse,V);
end

%% Change the input data for LDA into the good fomat for LDAext
% so the clusters are not used, but the plain Data.
for i=1:length(H.day)
    % mat is a N by V matri
    p{i}.mat=H.day{i}.PreClusteredData(:,1:5);
    %p{i}.mat(:,end)=[1:TS]';
end



lam=10*rand(1,k);

[a,b,l]=ldaExtPoi(p,k,lam,maxIter);


VisuLDAPoisMost(10,p,b,a,50);
