%% VISU CLUSTER
% With this script the topics can be shown

%% Initialize
HN=1; % there are in total five houses
TS=48; % Amount of time slices
coarse = 1; % The time is Coarse if this variable is 1, 0 otherwise
V=10; %the amount of clusters
k=20; %aantal topics

try
    path = '../../Data/DATAClustered/';
    load(strcat([path,'Clustered',num2str(V),'TS',num2str(TS),'Coarse', num2str(coarse),'.mat']));
    d=House{HN};
catch
    fprintf(1,'Starting to make the Clusters ');
    load ../../Data/DATAMain/sepDays.mat
    addpath ../../Data/ALGClusteren
    d=ClusterIt(House,HN,TS,coarse,V);
end

VisuClusters(d);
    