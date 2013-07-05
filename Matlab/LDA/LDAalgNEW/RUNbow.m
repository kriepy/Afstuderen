%% RUNbow: Dit script runt de nieuwe LDAbasic algorithme with the BOW approach
% So there is no clustering!!!
clear all


%% Initialize
HN=1; % there are in total five houses
TS=48; % Amount of time slices
coarse = 1; % The time is Coarse if this variable is 1, 0 otherwise
V=6; %the amount of clusters
k=20; %aantal topics
maxIter=100; %max aantal iteraties van LDA

%% Laad de data
try
    %load the clustered Data
    path = '../../Data/DATAClustered/';
    load(strcat([path,'Clustered',num2str(V),'TS',num2str(TS),'Coarse', num2str(coarse),'.mat']));
    H=House{HN};
catch
    % if that is not possible create the clustered data
    fprintf(1,'Starting to make the Clusters ');
    load ../../Data/DATAMain/sepDays.mat
    addpath ../../Data/ALGClusteren
    d=ClusterIt(House,HN,TS,coarse,V);
end

%% Change the input data for LDA into the good fomat
for i=1:length(H.day)
    % mat is a N by V matrix
    mat = zeros(size(H.day{1}.PreClusteredData,1),size(H.DicClusters,1));
    for j=1:size(mat,1)
        word=H.day{i}.PreClusteredData(j,:);
        wo = find(ismember(H.DicClusters,word),1);
        mat(j,wo)=1;
    end
    p{i}.mat=sparse(mat);
end


%% Use LDAbasic on the clustered data

[a,b,l]=ldaBasic(p,k,maxIter,V);

%% Visualize the topics
VisuLDAbasic(p,b,a,10,V)