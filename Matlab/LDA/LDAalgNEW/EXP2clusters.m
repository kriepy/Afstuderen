%% EXPERIMENT 2 CLUSTERS
% in this experiment we take a fixed k (amount of topics) and vary the
%  cluster size.

clear all

%% Initialize
HN=5; % there are in total five houses
TS=48; % Amount of time slices
coarse = 1; % The time is Coarse if this variable is 1, 0 otherwise
%V=6; %the amount of clusters
k=20; %aantal topics
maxIter=100; %max aantal iteraties van LDA


%% Laad de data
name = 'OutcomeExp2Clus.mat';
try
    load(name);
    MM = DataClus2{HN}.perClusM;
    SS = DataClus2{HN}.perClusS;
catch
    fprintf(1,'The file does not yet exist');
    MM=[];
    SS=[];
end


for V=2:10

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

%% Get the hold out set
% getting the hold out set 10%
n=length(p);
r = randperm(n);
len = round(n/10);
idxV = r(1:len);
idxA = r(len+1:end);
HOS=p(idxV); %Hold-out-set
d=p(idxA);

%% RUN with different topics


    fprintf(1,'\n -----------------------The %dth run started----------------\n',k );
    per =[];
    
    for step=1:10

        % init is done in ldaBasic
        [a,b,l]=ldaBasic(d,k,maxIter,V);
        Perpl = calcPerpl(a,b,l,HOS);
        per = [per Perpl];
        DataClus2{HN}.Run{V}.Step{step}.a=a;
        DataClus2{HN}.Run{V}.Step{step}.b=b;
        DataClus2{HN}.Run{V}.Step{step}.l=l;
    end
    
	MM=[MM mean(per)];
    SS=[SS std(per)];
    
    DataClus2{HN}.Run{V}.per = per;
    DataClus2{HN}.perClusM=MM;
    DataClus2{HN}.perClusS=SS;
    
    fprintf(1,'^^^^^^^^^^^^^^^^^^^^^^^^ The %dth run is saved^^^^^^^^^^^^^^^^',V);
    save(name,'DataClus2');
end

