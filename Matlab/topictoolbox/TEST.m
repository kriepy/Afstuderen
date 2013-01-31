

DS=[1 1 1 1 1 2 2 2 2 2 3 3 3 3 3 4 4 4 4 4] %4 documents
WS=[1:5 1:5 6:10 6:10]

WO={'hallo' 'ik' 'moet' 'tien' 'woorden' 'opschrijven' 'want' 'dan' 'werkt' 'het'};

T=2; % number of topics

ALPHA=50/T;
BETA=200/length(WO);

N=20000; %number of iterations

SEED=100; %random seed

OUTPUT=2;

tic
[ WP,DP,Z ] = GibbsSamplerLDA( WS , DS , T , N , ALPHA , BETA , SEED , OUTPUT );
toc

%save it
save 'ldaTEST' WP DP Z ALPHA BETA SEED N;

[S] = WriteTopics( WP , BETA , WO , 7 , 0.7 );
S

WriteTopics( WP , BETA , WO , 10 , 0.7 , 4 , 'topics.txt' );