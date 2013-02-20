
load('C:\Users\Kristin\UVA\Afstuderen\Afstuderen\Matlab\LDA\Generate\CorpusGenKleinAlphaNstat.mat')

DS=[];
WS=[];
for i=1:length(Corpus.documents)
    a=size(Corpus.documents(i).doc,2);
    DS=[DS i*ones(1,a)] ;
    WS=[WS (abs(mod(i,2))+1)*ones(1,a)];
end


% DS=[1 1 1 1 1 2 2 2 2 2 3 3 3 3 3 4 4 4 4 4] %4 documents
% WS=[1:5 1:5 6:10 6:10]

WO={'hallo' 'ik'};% 'moet' 'tien' 'woorden' 'opschrijven' 'want' 'dan' 'werkt' 'het'};

T=2; % number of topics

ALPHA=50/T;
BETA=200/length(WO);

N=50000; %number of iterations

SEED=200; %random seed

OUTPUT=2;

tic
[ WP,DP,Z ] = GibbsSamplerLDA( WS , DS , T , N , ALPHA , BETA , SEED , OUTPUT );
toc

%save it
save 'ldaTEST' WP DP Z ALPHA BETA SEED N;

[S] = WriteTopics( WP , BETA , WO , 7 , 0.7 );
S

WriteTopics( WP , BETA , WO , 10 , 0.7 , 4 , 'topics.txt' );