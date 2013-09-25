%% EXPERIMENT Compare Gaus & Pois%% EXPERIMENT 4
% In this experiment we again want to find the perplexity of a hold-out-set
% with different amount of topics. But now we initialize the EM-algorithm
% with 5 random documents of the data that is used for trainings.
% FIRST we run the algorithm with the same hold-out-set and same
% initialization set for every amount of topics. THEN we see further...


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
HN=5; %moet voor alle huizen
nameKmeans = 'OutcomeExp_CompareKmeans9goed.mat'
try
    load(nameKmeans);
catch
    fprintf(1,'File not yet existing');
end


addpath ../LDA/LDAalgNEW
path = '../Data/DATAClustered/';
load(strcat([path,'Clustered',num2str(V),'TS',num2str(TS),'Coarse', num2str(coarse),'.mat']));
H=House{HN};
for i=1:length(H.day)
    % mat is a N by V matri
    p{i}.mat=H.day{i}.PreClusteredData;
    %p{i}.mat(:,end)=[1:TS]';
end


[p,Clusters]=ClusterData(p,V);

%getting the hold out set 10%
try
    load r2
catch
    n=length(p);
    r = randperm(n);
    save r
end
n=length(p);
len = round(n/10);
%%%%% save('HOS.mat','HOS','d')



InitBet = [];
flap=0;
for k=5:30:290
    flap=flap+1;
    for cros=1:10
        fprintf(1,'\n -----------------------The %dth run startedCROS----------------\n',cros );
        rTemp=r;
        idxV = rTemp(cros*7-6:cros*7);
        rTemp(cros*7-6:cros*7)=[];
        idxA = rTemp;
        HOS=p(idxV); %Hold-out-set
        d=p(idxA);
        %[HOS,d]=ClusterDataNew(HOS,d,V);
        
        
        
        
        % hier elke 10 keer uitvoeren of zo (Dude dat zal lang duren)
        fprintf(1,'\n -----------------------The %dth run started----------------\n',k );
        per = [];
        B=[];
        for step=1:10
            fprintf(1,'\n -----------------------This is the  %dth iterationGaus.----------------\n',step );

            % initialize beta for LDA initialization            
            [a,b,l]=ldaBasic(d(1:5),k,maxIter);
        
            % run LDA
            [a,b,l]=ldaBasic(d,k,maxIter,b);

            Perpl = calcPerplNew(a,b,l,HOS,Clusters);
            if ~isnan(Perpl)
                per=[per Perpl];
            end
            Bic = calcBiC(a,b,l,length(d)*48*6);

            DataKmeans{HN}.Run{flap}.Cros{cros}.Step{step}.a=a;
            DataKmeans{HN}.Run{flap}.Cros{cros}.Step{step}.b=b;
            DataKmeans{HN}.Run{flap}.Cros{cros}.Step{step}.L=l;
            B = [B Bic];
        end

        DataKmeans{HN}.Run{flap}.Cros{cros}.Perpl=per;
        DataKmeans{HN}.Run{flap}.amTopics = k;
        DataKmeans{HN}.Run{flap}.Cros{cros}.Bic = B;

        save(nameKmeans,'DataKmeans');
        fprintf(1,'&&&&&&&&&&&&&THE %dth run is saved&&&&&&&&&&&&&',k);

    end
end





