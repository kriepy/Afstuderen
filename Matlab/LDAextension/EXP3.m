%% EXPERIMENT 3 (Compare topics)
% In this experiment we compare the topics of ten runs with each other.
% Every topic is compared to every topic in the other runs. If there is a
% low distance between the topics they might be the same topics. It might
% be interesting 

%% INITIALIZE
close all
k=20;
maxIter=50;
HN=1;
TS=48;
V=6;
coarse=1;

% %% LOAD DATA
% 
% path = '../Data/DATAClustered/';
% load(strcat([path,'Clustered',num2str(V),'TS',num2str(TS),'Coarse', num2str(coarse),'.mat']));
% H=House{HN};
% for i=1:length(H.day)
%     % mat is a N by V matri
%     p{i}.mat=H.day{i}.PreClusteredData;
%     p{i}.mat(:,end)=[1:TS]';
% end
% 
% 
% Loops=10;
% A=[];
% LikDocs = [];
% LikTot = [];
% for l=1:Loops
%     m=[];
%     for i=1:length(p)
%     m=[m;max(p{i}.mat)];
%     end
%     m=max(m,[],1);
% 
% 
%     beta.mu=[];
%     for i=1:length(m)
%     beta.mu=[beta.mu;m(i)*rand(1,k)];
%     end
%     beta.sigma=ones(length(m),k);
% 
%     [a,b,L,lik]=ldaExtension(p,k,beta,maxIter);
%     if isnan(L)
%         fprintf(1,'WRONG, check initialization');
%     end
%     LikDocs=[LikDocs lik]; % likeli for the documents
%     LikTot = [LikTot L]; % total likeli
%     A=[A ;a];
%     B{l}.mu = b.mu;
%     B{l}.sigma = b.sigma;
% end

%% 2nd Part

load('OutcomeExp3');

for i=1:9
    T1=B{i}
    for j=(i+1):10
        T2=B{j};
        for p=1:19
            lin1m = T1.mu(:,p);
            lin1s = T1.sigma(:,p);
            for q=(p+1):20
                lin2m = T2.mu(:,q);
                lin2s = T2.sigma(:,q);
                
                KLdiv = KLdivergenceGau(lin1m,lin1s,lin2m,lin2s)
                sum(KLdiv)
                EuDist =norm(lin1m-lin2m)
                if sum(KLdiv) < 100
                    close all
                    figure(1)
                    VisuTop(lin1m,lin1s);
                    figure(2)
                    VisuTop(lin2m,lin2s);
                end
                EuSigDis = norm(lin1s - lin2s)
            end
        end        
    end
end
