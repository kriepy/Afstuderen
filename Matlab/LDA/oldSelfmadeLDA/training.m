function training
%% LOAD one Copora
% Corpus.documents(d).doc there are M documents
% Every document doc is a matrix of words. Every word is a colum in this
% matrix with one 1 and the rest 0 of length V. Where V is the length of
% the dictionary.
% Corpus.V is the length of the dictionary


% Corpus.alpha will be a vector of length k
% Corpus.beta will be a matrix of size k x V
% Corpus.documents(d).phi will be a matrix of size N x k
% Corpus.documents(d).gamma willbe a vector of length k



% phi and gamma will be different for every document. Alpha and beta stay
% the same for the whole corpus.


%% The nr of house we are looking at, each house nr is a different corpus.
format compact
clear all
close all
clc
houseNr=254;
k=2; %amount of topics
the=0.3;


%load(strcat(['C:\Users\Kristin\UVA\Afstuderen\Afstuderen\Matlab\ExtractData\DataMatlab\House',num2str(houseNr),'.mat']));
%Corpus=House;
%load(strcat(['Generate\CorpusTheta',num2str(the),'.mat']))
load('Generate\CorpusSimple.mat')
%VisuData(Corpus)
V=Corpus.V; % the length of the dictionary

% initialize alpha and beta
try
    Corpus.alphaOld=Corpus.alpha;
    Corpus.betaOld=Corpus.beta;
    Corpus.alpha=20*ones(k,1);
    Corpus.beta=[0.4 0.6;0.6 0.4];   %rand(k,V);
catch
    Corpus.alpha=ones(k,1);
    Corpus.beta=rand(k,V);
end
    
%normalize beta:
SB=sum(Corpus.beta,2);
for i=1:size(Corpus.beta,1)
    Corpus.beta(i,:)=Corpus.beta(i,:)./SB(i);
end


N=200; %amount of iterations (EM)
Beta=[];
Alpha=[];
% starting EM
for n=1:N
%% E-STEP
    tic
    n

    tic
    for i=1:length(Corpus.documents)
        
        i;
        [Corpus.documents(i).phi,Corpus.documents(i).gamma]=Estep(Corpus.alpha,Corpus.beta,Corpus.documents(i).doc);
    end
    toc

%% M-STEP
    tic
    [Corpus.alpha,Corpus.beta]=Mstep(Corpus,k);
    toc
    %hold on
    %plot([0 10*Corpus.beta(1,1)],[0 10*Corpus.beta(1,2)],'-r')
    %plot([0 10*Corpus.beta(2,1)],[0 10*Corpus.beta(2,2)],'-r')
    
    Beta=[Beta Corpus.beta(:,1)];
    Alpha=[Alpha Corpus.alpha];
    toc
end
Corpus.Alpha=Alpha;
Corpus.Beta=Beta;
%% End EM
%save(strcat(['C:\Users\Kristin\UVA\Afstuderen\Afstuderen\Matlab\ExtractData\DataMatlab\House',num2str(houseNr),'.mat']));

    %disp('new beta:')
    %Corpus.beta
    %disp('old')
    %Corpus.betaOld

    %disp('phi(1) is:')
    %disp(Corpus.day(1).phi)
    %disp('En beta is:');
    %disp(Corpus.beta)
    %disp('And finaly the gamma')
    %disp([Corpus.day(1).gamma Corpus.day(2).gamma])
    VisuResult(Corpus)
    save(strcat(['Analyse\theta', num2str(Corpus.theta), '.mat']),'Corpus')
    Corpus.beta
    figure(2)
    plot(1:N,Corpus.Beta(1,:))
end
