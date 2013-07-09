close all
clear all
%% INITIALIZE
k=30;
maxIter=50;
HN=1; % there are in total five houses
TS=48; % Amount of time slices
V=6;
coarse=1;

%% LOAD DATA
% addpath ../Data/Old/ALGtranExtData
% d=transExtData;
%% Laad de data
try
    %load the clustered Data
    path = '../Data/DATAClustered/NEW/';
    load(strcat([path,'Clustered',num2str(V),'TS',num2str(TS),'Coarse', num2str(coarse),'.mat']));
    H=House{HN};
catch
    % if that is not possible create the clustered data
    fprintf(1,'Starting to make the Clusters ');
    load ../Data/DATAMain/NEW/sepDays.mat
    addpath ../Data/ALGClusteren/
    d=ClusterIt(House,HN,TS,coarse,V);
end

%% Change the input data for LDA into the good fomat for LDAext
for i=1:length(H.day)
    % mat is a N by V matri
    p{i}.mat=H.day{i}.PreClusteredData;
    p{i}.mat(:,end)=[1:TS]';
end






% seed for the rand function
%rng(s);

m=[];
for i=1:length(p)
    m=[m;max(p{i}.mat)];
end
m=max(m,[],1);


beta.mu=[];
for i=1:length(m)
    beta.mu=[beta.mu;m(i)*rand(1,k)];
end
beta.sigma=ones(length(m),k);

% a:= alpha, b:=beta(.mu,.sigma), L:=total Likelihood, l:=per doc likeli
[a,b,L,l]=ldaExtension(p,k,beta,maxIter);


% LDAout{cnt}.alpha=a;
% LDAout{cnt}.beta=b;
% LDAout{cnt}.likeli=l;
% cnt=cnt+1;

VisuLDAMosttopics(10,p,b,a,10)


