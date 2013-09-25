%% EXPERIMENT BOW TS

clear all


%% Initialize
%TS=48; % Amount of time slices
coarse = 1; % The time dimension can be 2(small), 1(wide) or 0(none) otherwise
V=6; %the amount of clusters
k=10; %aantal topics
maxIter=100; %max aantal iteraties van LDA
startValue=10;
name='OutcomeExp1BowTS.mat';
HN=5;


%% load data
flap=0;
for ts=1:8
TS=2^(ts-1)*6;

try
    load(name);
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


%getting the hold out set 10%

try
    HOS = p(DataBow{HN}.idxV);
    d = p(DataBow{HN}.idxA);
catch
    n=length(p);
    r = randperm(n);
    len = round(n/10);
    idxV = r(1:len);
    idxA = r(len+1:end);
    HOS=p(idxV); %Hold-out-set
    d=p(idxA);
end
DataBow{HN}.idxV=idxV;
DataBow{HN}.idxA=idxA;

flap=flap+1;
fprintf(1,'\n -----------------------The %dth run startedTSGaus----------------\n',ts );
per = [];
B=[];
for step=1:10
    fprintf(1,'\n --------------------This is the  %dth iterationGaus.----------------\n',step );
        % init is done in ldaBasic
        [a,b,l]=ldaBasic(d,k,maxIter,V);
        Perpl = calcPerpl(a,b,l,HOS);
        per = [per Perpl];
        %B=calcBiC(a,b,l,length(d))
        DataBow{HN}.Run{flap}.Step{step}.L=l;
        DataBow{HN}.Run{flap}.Step{step}.a=a;
        DataBow{HN}.Run{flap}.Step{step}.b=b;
    
end
    perBOWm=[perBOWm mean(per)];
    perBOWs=[perBOWs std(per)];
    DataBow{HN}.perBOWm = perBOWm;
    DataBow{HN}.perBOWs = perBOWs;
    
    DataBow{HN}.Run{flap}.Per=per;


    save(name,'DataBow');
    fprintf(1,'It is saved')

end

