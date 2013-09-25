%% Visu cluster verdeling

clear all


%% Initialize
HN=2; % there are in total five houses
TS=96; % Amount of time slices
coarse = 1; % The time is Coarse if this variable is 1, 0 otherwise
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

VisuClusDay(d)
yes=1;