%% EXPERIMENT 1 POISSON


%% INITIALIZE
%k=20;
maxIter=50;
%NH=1; % there are in total five houses
TS=48; % Amount of time slices
V=6;
coarse=1;
startValue=5;
%% Laad de data
name='OutExp1_2Pois.mat';
HN =4;
try
    load(name);
    PerPoisM= DataPois{HN}.PerPoisM;
    PerPoisS = DataPois{HN}.PerPoisS;
catch
    PerPoisM = [];
    PerPoisS = [];
end


try
    %load the clustered Data
    path = '../Data/DATAClustered/';
    load(strcat([path,'Clustered',num2str(V),'TS',num2str(TS),'Coarse', num2str(coarse),'.mat']));
    H=House{HN};
catch
    % if that is not possible create the clustered data
    fprintf(1,'Starting to make the Clusters ');
    load ../Data/DATAMain/sepDays.mat
    addpath ../Data/ALGClusteren
    d=ClusterIt(House,HN,TS,coarse,V);
end

%% Change the input data for LDA into the good fomat for LDAext
for i=1:length(H.day)
    % mat is a N by V matri
    p{i}.mat=H.day{i}.PreClusteredData;
    p{i}.mat(:,end)=[1:TS]';
end

%% Getting the hold out set 10%
n=length(p);
r = randperm(n);
len = round(n/10);
idxV = r(1:len);
idxA = r(len+1:end);
HOS=p(idxV); %Hold-out-set
d=p(idxA);


%% Run for verschillende k's
P=[];
flap=0;
for k=startValue:5:100
    flap=flap+1;
    fprintf(1,'\n -----------------------The %dth run started----------------\n',k );
    per = [];
    B=[];
    for step=1:10
        fprintf(1,'\n -----------------------The %dth iteration----------------\n',step);
        % initilize EM
        lam=10*rand(1,k);
        [a,b,l]=ldaExtPoi(d(1:5),k,lam,maxIter);

        % real run
        [a,b,L]=ldaExtPoi(d,k,b,maxIter);

        Perpl = calcPerpl(a,b,HOS);
        Bic = calcBiC(a,b,L,length(d)*48*6);

        if ~isnan(Perpl)
            per=[per Perpl];
        else
            
           
        end
        DataPois{HN}.Run{flap}.Step{step}.a=a;
        DataPois{HN}.Run{flap}.Step{step}.b=b;
        DataPois{HN}.Run{flap}.Step{step}.L=L;
        B = [B Bic];
    end
    PerPoisM = [PerPoisM mean(per)];
    PerPoisS = [PerPoisS std(per)];
    
    DataPois{HN}.PerPoisM = PerPoisM;
    DataPois{HN}.PerPoisS = PerPoisS;
    
    DataPois{HN}.Run{flap}.amTopics = k;
    DataPois{HN}.Run{flap}.Bic = B;
    DataPois{HN}.Run{flap}.per=per;
    
    
    save(name,'DataPois');
    fprintf(1,'&&&&&&&&&&&&&THE %dth run is saved&&&&&&&&&&&&&',k);
end


