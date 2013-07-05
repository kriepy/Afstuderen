%% EXPERIMENT 1
% In this experiment we look at the variance of the outcomes. The feature
% representation of the data is fixed. (See initializations)
% We run the LDAext alg for a couple of times. The mean and the variance of
% the likelihood of each document is stored. We also store the alpha and
% beta, so that we can check if the topics that are found are the same.

%% INITIALIZE
close all
k=20;
maxIter=50;
HN=1;
TS=48;
V=6;
coarse=1;

%% LOAD DATA

path = '../Data/DATAClustered/';
load(strcat([path,'Clustered',num2str(V),'TS',num2str(TS),'Coarse', num2str(coarse),'.mat']));
H=House{HN};
for i=1:length(H.day)
    % mat is a N by V matri
    p{i}.mat=H.day{i}.PreClusteredData;
    p{i}.mat(:,end)=[1:TS]';
end

Loops=20;
A=[];
LikDocs = [];
LikTot = [];
for l=1:Loops
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

    [a,b,L,lik]=ldaExtension(p,k,beta,maxIter);
    LikDocs=[LikDocs lik]; % likeli for the documents
    LikTot = [LikTot L]; % total likeli
    A=[A ;a];
    B{l}.mu = b.mu;
    B{l}.sig = b.sigma;
end

%% VISU topics

load OutcomeExp1.mat

for i=1:5
    figure(i)
    B{i}.sigma = B{i}.sig;
    
    VisuTopics(A(i,:),B{i})
end

