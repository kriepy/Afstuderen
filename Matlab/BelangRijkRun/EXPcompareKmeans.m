%% EXPERIMENT Compart BOW k-means
% This experiments creates the baseline. The new models are compared to
% this outcome. The HOS is the same as in the other experiments

%% INITIALIZE
close all
clear all
%k=20;
maxIter=50;
%HN=1;
TS=48;
V=6;
coarse=0;
startValue = 5;
maxIter=100; %max aantal iteraties van LDA


%% LOAD DATA
HN=2; %moet voor alle huizen
nameKmeans = 'OutcomeExp_CompareKmeans3.mat'
try
    load(nameKmeans);
catch
    printf(1,'file not yet exist');
end
addpath ../LDA/LDAalgNEW
load HOS

% cluster the data first with k-means
[HOSc,dc]=ClusterDataNew(HOS,d,V);

PerKmeansM=[];
PerKmeansS=[];

flap = 0;
for k=5:30:290
    flap=flap+1;
    
    fprintf(1,'\n -----------------------The %dth run started----------------\n',k );
    per = [];
    B=[];
    for step=1:10
        fprintf(1,'\n -----------------------This is the  %dth iteration.----------------\n',step );
    
        [a,b,l]=ldaBasic(dc(1:5),k,maxIter);
        
        [a,b,l]=ldaBasic(dc,k,maxIter,b);
        
        %figure(3)
        %VisuLDAbasic(dc,b,a,50,V)
        
        Perpl = calcPerpl(a,b,l,HOSc);
        if ~isnan(Perpl)
            per=[per Perpl];
        end
        Bic = calcBiC(a,b,sum(l),length(dc)*48*5);
        
        DataKmeans{HN}.Run{flap}.Step{step}.a=a;
        DataKmeans{HN}.Run{flap}.Step{step}.b=b;
        DataKmeans{HN}.Run{flap}.Step{step}.L=l;
        B = [B Bic];
    end
    PerKmeansM= [PerKmeansM mean(per)];
    PerKmeansS = [PerKmeansS std(per)];
    
    DataKmeans{HN}.Run{flap}.Perpl=per;
    DataKmeans{HN}.PerGausM = PerKmeansM;
    DataKmeans{HN}.PerGausS = PerKmeansS;
    DataKmeans{HN}.Run{flap}.amTopics = k;
    DataKmeans{HN}.Run{flap}.Bic = B;
    
    %save(nameKmeans,'DataKmeans');
    fprintf(1,'&&&&&&&&&&&&&THE %dth run is saved&&&&&&&&&&&&&',k);
end