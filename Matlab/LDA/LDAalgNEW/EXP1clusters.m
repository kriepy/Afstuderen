%% EXPERIMENT 1 CLUSTERS
% in this experiment we take a fixed V (dictionary size) and vary the
% amount of topics.

clear all

%% Initialize
HN=1; % there are in total five houses
TS=48; % Amount of time slices
coarse = 0; % The time is Coarse if this variable is 1, 0 otherwise
V=6; %the amount of clusters
%k=20; %aantal topics
maxIter=100; %max aantal iteraties van LDA


%% Laad de data
name = 'OutcomeExp1_4ClusV6.mat';
try
    load(name)
catch
    fprintf(1,'File not yet exists')
end

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

VisuClusters(House{HN});

%% Get the hold out set
% getting the hold out set 10%
n=length(p);
r = randperm(n);
len = round(n/10);
idxV = r(1:len);
idxA = r(len+1:end);
try
    HOS = DataClus{HN}.HOS;
    d = DataClus{HN}.d;
catch
    HOS=p(idxV); %Hold-out-set
    d=p(idxA);
end

%% RUN with different topics

perCLUSm = [];
perCLUSs = [];
flap = 0;
for k=5:5:100
    flap=flap+1;
    fprintf(1,'\n -----------------------The %dth run started----------------\n',k );
    per =[];
    A=[];
    B=[];
    L=[];
    for step=1:10

        % init is done in ldaBasic
        [a,b,l]=ldaBasic(d,k,maxIter,V);
        Perpl = calcPerpl(a,b,l,HOS);
        per = [per Perpl];
        A=[A a];
        B=[B b];
        L=[L l];
        
    end
    
	perCLUSm=[perCLUSm mean(per)];
    perCLUSs=[perCLUSs std(per)];
    DataClus{HN}.Run{flap}.per=per;
    DataClus{HN}.Run{flap}.A=A;
    DataClus{HN}.Run{flap}.B=B;
    DataClus{HN}.Run{flap}.L=L;
end
DataClus{HN}.perCLUSm = perCLUSm;
DataClus{HN}.perCLUSs = perCLUSs;
DataClus{HN}.d=d;
DataClus{HN}.HOS=HOS;



save(name,'DataClus');