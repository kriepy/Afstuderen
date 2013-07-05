%% EXPERIMENT 1 BOW
% In this Experiment we run the standard test for the LDA model. We variate
% the amount of topics and see what the perplexity of the model is.

clear all


%% Initialize
%HN=1; % there are in total five houses
TS=48; % Amount of time slices
coarse = 1; % The time is Coarse if this variable is 1, 0 otherwise
V=6; %the amount of clusters
k=20; %aantal topics
maxIter=100; %max aantal iteraties van LDA
startValue=10;

%% Laad de data
HN=2;
try
    load('OutcomeExp1Bow.mat');
    perBOWm = DataBow{HN}.perBOWm;
    perBOWs = DataBow{HN}.perBOWs;
catch
    perBOWm = [];
    perBOWs = [];
end


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

%% Get the hold out set
% getting the hold out set 10%
n=length(p);
r = randperm(n);
len = round(n/10);
idxV = r(1:len);
idxA = r(len+1:end);
HOS=p(idxV); %Hold-out-set
d=p(idxA);



%% Use LDAbasic on the clustered data
for k=startValue:5:100
    fprintf(1,'\n -----------------------The %dth run started----------------\n',k );
    per =[];
    for step=1:1
        
        % init is done in ldaBasic
        [a,b,l]=ldaBasic(d,k,maxIter,V);
        Perpl = calcPerpl(a,b,l,HOS);
        per = [per Perpl];
    end
    
    perBOWm=[perBOWm mean(per)];
    perBOWs=[perBOWs std(per)];
    DataBow{HN}.perBOWm = perBOWm;
    DataBow{HN}.perBOWs = perBOWs;


    save('OutcomeExp1Bow.mat','DataBow');
    fprintf(1,'It is saved')
end

