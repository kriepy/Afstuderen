%% EXPERIMENT 4
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
coarse=1;
startValue = 5;

%% LOAD DATA
HN=2; %moet voor alle huizen
name = 'OutcomeExp4_TEST.mat'

try
    load(name);
    PerGausM = DataGaus{HN}.PerGausM;
    PerGausS = DataGaus{HN}.PerGausS;
catch
    PerGausM = [];
    PerGausS = [];
end


path = '../Data/DATAClustered/';
load(strcat([path,'Clustered',num2str(V),'TS',num2str(TS),'Coarse', num2str(coarse),'.mat']));
H=House{HN};
for i=1:length(H.day)
    % mat is a N by V matri
    p{i}.mat=H.day{i}.PreClusteredData;
    p{i}.mat(:,end)=[1:TS]';
end

%getting the hold out set 10%
n=length(p);
r = randperm(n);
len = round(n/10);
idxV = r(1:len);
idxA = r(len+1:end);
HOS=p(idxV); %Hold-out-set
d=p(idxA);




InitBet = [];
flap=0;
for k=startValue:5:100
    flap=flap+1;
    % hier elke 10 keer uitvoeren of zo (Dude dat zal lang duren)
    fprintf(1,'\n -----------------------The %dth run started----------------\n',k );
    per = [];
    B=[];
    for step=1:10
        fprintf(1,'\n -----------------------This is the  %dth iteration.----------------\n',step );

        % initialize beta for LDA initialization
        m=[];
        for i=1:length(d)
            m=[m;max(p{i}.mat)];
        end
        m=max(m,[],1);
        beta.mu=[];
        for i=1:length(m)
            beta.mu=[beta.mu;m(i)*rand(1,k)];
        end
        beta.sigma=ones(length(m),k);

        % initialize with 5 documents (always the same)
        [al,bet,~,~]=ldaExtension(d(1:5),k,beta,maxIter);

        InitBet = [InitBet bet];

        [a,b,L,lik]=ldaExtension(d,k,bet,maxIter);

        Perpl = calcPerpl(a,b,lik,HOS);
        if ~isnan(Perpl)
            per=[per Perpl];
        end
        Bic = calcBiC(a,b,L,length(d)*48*6);
        
        DataGaus{HN}.Run{flap}.Step{step}.a=a;
        DataGaus{HN}.Run{flap}.Step{step}.b=b;
        DataGaus{HN}.Run{flap}.Step{step}.L=L;
        B = [B Bic];
    end
    PerGausM = [PerGausM mean(per)];
    PerGausS = [PerGausS std(per)];
    
    DataGaus{HN}.Run{flap}.Perpl=per;
    DataGaus{HN}.PerGausM = PerGausM;
    DataGaus{HN}.PerGausS = PerGausS;
    DataGaus{HN}.Run{flap}.amTopics = k;
    DataGaus{HN}.Run{flap}.Bic = B;
    
    save(name,'DataGaus');
    fprintf(1,'&&&&&&&&&&&&&THE %dth run is saved&&&&&&&&&&&&&',k);
end



