%% Dit script runt de nieuwe LDAbasic algorithme!!!
clear all


%% Initialize
HN=1; % there are in total five houses
TS=96; % Amount of time slices
coarse = 2; % The time is Coarse if this variable is 1, 0 otherwise
V=6; %the amount of clusters
k=5; %aantal topics
maxIter=100; %max aantal iteraties van LDA

%% Laad de data
try
    %load the clustered Data
    path = '../../Data/DATAClustered/';
    load(strcat([path,'Clustered',num2str(V),'TS',num2str(TS),'Coarse', num2str(coarse),'.mat']));
    d=House{HN}.day;
catch
    % if that is not possible create the clustered data
    fprintf(1,'Starting to make the Clusters ');
    load ../../Data/DATAMain/sepDays.mat
    addpath ../../Data/ALGClusteren
    d=ClusterIt(House,HN,TS,coarse,V);
end

%% Change the input data for LDA into the good fomat
for i=1:length(d)
    p{i}.mat=d{i}.ClusteredData;
end


%% Use LDAbasic on the clustered data

[a,b,l]=ldaBasic(p,k,maxIter);

%% Visualize the topics
most=10;
figure(1)
VisuLDAbasic(most,p,b,a,50,V)

%% Visualize the clusters
figure(2)
VisuClusters(House{HN});

%% Visulize clusters perday
figure(3)
VisuClusDays(House{HN}.day,V);

%% show beta
b
