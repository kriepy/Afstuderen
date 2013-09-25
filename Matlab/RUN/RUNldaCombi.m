%% RUN
clear all
format compact
clc

%% LOAD DATA

% Initialize
TS=48;
coarse=2; %    1:=coarse grain 2:= fine grain (0:=no time, is not possible with LDAcombi)
%trans=0;  % 0:= no transitions, 1:=tansitions taken into account (changes dimensions)
V=6;
HN=1;     % the houseNR (1-5)
k=20;     % aantal topics
type = 'trans'

% path to data
basePath='../Data/SET1'

% Load
try
    %load the clustered Data
    path = strcat(basePath,'/DATAClustered/');
    load(strcat([path,'Clustered',num2str(V),'TS',num2str(TS),'Coarse', num2str(coarse),'.mat']));
    if ~isfield(House{1}.day{1},'TransData')
        House=addTransData(House);
    end
    H=House{HN};
catch
    % if that is not possible create the clustered data
    fprintf(1,'Starting to make the Clusters ');
    load(strcat(basePath,'/DATAMain/sepDays.mat')); 
    addpath ../Data/ALGClusteren
    House=ClusterIt(House,HN,TS,coarse,V,type);
    savePath = strcat(basePath,'/DATAClustered/Clustered',num2str(V),'TS'...
               ,num2str(TS),'Coarse', num2str(coarse)');
    save(savePath,'House');
    H=House{HN};
end


%% Change the input data for LDA into the good fomat for LDAext
for i=1:length(H.day)
    % mat is a N by V matri
    p{i}.mat=H.day{i}.TransData;
    %p{i}.mat(:,end)=[1:TS]';
end

%% Initialize beta
m=[];
for i=1:length(p)
    if i==99
        yes=1;
    end
    m=[m;max(p{i}.mat)];
end
m=max(m,[],1);


beta.mu=[];
for i=1:length(m)
    beta.mu=[beta.mu;m(i)*rand(1,k)];
end
beta.sigma=ones(1,k); % alleen de tijd dimensie heeft een sigma nodig

%% RUN LDAcombi
% here the last dimension is always calculated as a time dimension
addpath ../LDAcombi
[alpha,beta,likeli,ppl] = ldaCombi(p,k,beta)
