%% EXPERIMENT 4 BIC
% In this experiment we want to find the BIC of a dataset
% with different amount of topics. But now we initialize the EM-algorithm
% with 5 random documents of the data that is used for trainings.
% FIRST we run the algorithm with the same hold-out-set and same
% initialization set for every amount of topics. THEN we see further...

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

lenP = length(p);


BicGausM = [];
BicGausS = [];
InitBet = [];

for k=10:5:100
    % hier elke 10 keer uitvoeren of zo (Dude dat zal lang duren)
    fprintf(1,'\n -----------------------The %dth run started----------------\n',k );
    Bic = []
    for step=1:10
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
        [~,bet,~,~]=ldaExtension(d(1:5),k,beta,maxIter);

        InitBet = [InitBet bet];

        [a,b,L,lik]=ldaExtension(d,k,bet,maxIter);

        bic = calcBiC(a,b,lik,lenP)
        Bic=[Bic bic];

    end
    BicGausM = [BicGausM mean(Bic)];
    BicGausS = [BicGauss std(Bic)];
end
DataGaus{HN}.PerGausM = PerGausM;
DataGaus{HN}.PerGausS = PerGausS;


save('OutcomeExp4_2.mat','DataGaus');