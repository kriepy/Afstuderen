%% EXPERIMENT 2
% In this experiment we take different amount of initializations of topic
% and calculate the perplexity. We take a random hold-out-set of 10%. 
%
% Maybe we need to do the tests a couple of time per run and take the mean
% about it.

%% INITIALIZE
close all
%k=20;
maxIter=50;
%HN=1;
TS=48;
V=6;
coarse=1;

%% LOAD DATA
HN=1; %moet voor alle huizen

path = '../Data/DATAClustered/';
load(strcat([path,'Clustered',num2str(V),'TS',num2str(TS),'Coarse', num2str(coarse),'.mat']));
H=House{HN};
for i=1:length(H.day)
    % mat is a N by V matri
    p{i}.mat=H.day{i}.PreClusteredData;
    p{i}.mat(:,end)=[1:TS]';
end

PerM = [];
PerV = [];

for k=10:5:100
    % hier elke 20 keer uitvoeren of zo (Dude dat zal lang duren)
    fprintf(1,'\n -----------------------The %dth run started----------------\n',k );
    per = [];
    for i=1:10
        %getting the hold out set 10%
        n=length(p);
        r = randperm(n);
        len = round(n/10);
        idxV = r(1:len);
        idxA = r(len+1:end);
        HOS=p(idxV); %Hold-out-set
        d=p(idxA);

        % initialize beta for LDA
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

        [a,b,L,lik]=ldaExtension(d,k,beta,maxIter);

        Perpl = calcPerpl(a,b,lik,HOS);
        per=[per Perpl];
    end
    PerM = [PerM mean(per)];
    PerV = [PerV var(per)];
end
save('OutcomeLongExp2.mat','PerM','PerV')