%% K-means + LDA
%This Script creates the clusterd data on the fly and
% runs the LDA alg. with it. After that the topics are visualized.
%% Initialize
HN=247;  %HouseNumber
clus=30;    % amount of clusters for the k-means
TimeSlices=48; % the amount of timesslices used
TimeCoarse=1;   % 1 for timecoarse and 0 for no time at all used
Fields=1;   % value 1 means that the sensors are devided in fields

k=20; % amount of topics

%% Get the data
%d{i}.id:= contains the identities of the clusters that is contained on day i
%d{i}.cnt:= gives the count how often a clusters appears on day i.
addpath ../../Data/ALGClusteren
d=ClusterData(HN,clus,TimeSlices,TimeCoarse);

%% Run LDA
[a,b]=lda(d,k,100)

%% Visualize Result
%needs to be written should be called from here
%VisuLDAbasic(d,b,a,10)

