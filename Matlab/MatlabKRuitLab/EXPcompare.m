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

%% LOAD DATA
HN=5; %moet voor alle huizen
namePois = 'OutcomeExp_ComparePois3.mat'
nameGaus = 'OutcomeExp_CompareGaus3.mat'
try
    load(nameGaus);

catch

end
try
    load(namePois);

catch

end

addpath ../LDAextPoisson/

path = '../Data/DATAClustered/';
load(strcat([path,'Clustered',num2str(V),'TS',num2str(TS),'Coarse', num2str(coarse),'.mat']));
H=House{HN};
for i=1:length(H.day)
    % mat is a N by V matri
    p{i}.mat=H.day{i}.PreClusteredData;
    %p{i}.mat(:,end)=[1:TS]';
end

%getting the hold out set 10%
try
    load r
catch
    n=length(p);
    r = randperm(n);
    save r
end
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
        
        
        
        
        % hier elke 10 keer uitvoeren of zo (Dude dat zal lang duren)
        fprintf(1,'\n -----------------------The %dth run started----------------\n',k );
        per = [];
        B=[];
        for step=1:10
            fprintf(1,'\n -----------------------This is the  %dth iterationGaus.----------------\n',step );

            % initialize beta for LDA initialization
            m=[];
            for i=1:length(d)
                m=[m;max(d{i}.mat)];
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

            DataGaus{HN}.Run{flap}.Cros{cros}.Step{step}.a=a;
            DataGaus{HN}.Run{flap}.Cros{cros}.Step{step}.b=b;
            DataGaus{HN}.Run{flap}.Cros{cros}.Step{step}.L=L;
            B = [B Bic];
        end

        DataGaus{HN}.Run{flap}.Cros{cros}.Perpl=per;
        DataGaus{HN}.Run{flap}.amTopics = k;
        DataGaus{HN}.Run{flap}.Cros{cros}.Bic = B;

        save(nameGaus,'DataGaus');
        fprintf(1,'&&&&&&&&&&&&&THE %dth run is saved&&&&&&&&&&&&&',k);

        per = [];
        B=[];
        for step=1:10
            fprintf(1,'\n -----------------------The %dth iterationPois----------------\n',step);
            % initilize EM
            lam=10*rand(1,k);
            [a,b,l]=ldaExtPoi(d(1:5),k,lam,maxIter);

            % real run
            [a,b,L]=ldaExtPoi(d,k,b,maxIter);

            Perpl = calcPerplPoi(a,b,HOS);
            Bic = calcBiCPoi(a,b,L,length(d)*48*6);

            if ~isnan(Perpl)
                per=[per Perpl];
            else


            end
            DataPois{HN}.Run{flap}.Cros{cros}.Step{step}.a=a;
            DataPois{HN}.Run{flap}.Cros{cros}.Step{step}.b=b;
            DataPois{HN}.Run{flap}.Cros{cros}.Step{step}.L=L;
            B = [B Bic];
        end


        DataPois{HN}.Run{flap}.amTopics = k;
        DataPois{HN}.Run{flap}.Cros{cros}.Bic = B;
        DataPois{HN}.Run{flap}.Cros{cros}.per=per;


        save(namePois,'DataPois');
        fprintf(1,'&&&&&&&&&&&&&THE %dth run is saved&&&&&&&&&&&&&',k);
    end
end





