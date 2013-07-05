load SEED
close all
%% INITIALIZE
k=20;
maxIter=50;
HN=3; % there are in total five houses
TS=48; % Amount of time slices
V=6;
coarse=1;

%% LOAD DATA
% addpath ../Data/Old/ALGtranExtData
% d=transExtData;
%% Laad de data
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






% seed for the rand function
%rng(s);

m=[];
for i=1:length(p)
    m=[m;max(p{i}.mat)];
end
m=max(m,[],1);


beta.mu=[];
for i=1:length(m)
    beta.mu=[beta.mu;m(i)*rand(1,k)];
end
beta.sigma=ones(length(m),k);

% a:= alpha, b:=beta(.mu,.sigma), L:=total Likelihood, l:=per doc likeli
[a,b,L,l]=ldaExtension(p,k,beta,maxIter);


% LDAout{cnt}.alpha=a;
% LDAout{cnt}.beta=b;
% LDAout{cnt}.likeli=l;
% cnt=cnt+1;

VisuLDAMosttopics(10,p,b,a,10)


% cnt=1;
% for k=3:10
%     for j=1:10
%         for t=1:5 %voor elke run 5 keer testen
%             beta.mu=[];
%             for i=1:length(m)
%                 beta.mu=[beta.mu;m(i)*rand(1,k)];
%             end
%             beta.sigma=j*ones(length(m),k);
%             
%             [a,b,l]=ldaExtension(d,k,beta);
%             LDAout{cnt}.alpha=a;
%             LDAout{cnt}.beta=b;
%             LDAout{cnt}.likeli=l;
%             cnt=cnt+1;
%         end
%     end
% end

%% BANALE TEST
% twee clusters maken met dimensie 2
% maakTestData
% 
% k=2;
% l=2;
% 
% b.mu=[5 5;4 5]
% b.sigma=1*ones(l,k);
% [alpha,beta] = ldaExtension(d,k,b)
% beta.mu

%% 
% A=[];
% B=[];
% for mu1=-1:10
%     atemp=[];
%     btemp=[];
%     for mu2=-1:10
%         b.mu=[mu1 mu2;mu1 mu2]
%         b.sigma=1*ones(2,2);
%         [alpha,beta] = ldaExtension(d,3,b)
%         atemp=[atemp alpha];
%         btemp=[btemp beta];
%     end
%     A=[A; atemp];
%     B=[B; btemp];
% end

