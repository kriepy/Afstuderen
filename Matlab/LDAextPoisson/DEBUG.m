% This is a script to debug the LDAext function


d=maakTestData
k=2;

lam=10*rand(1,k);

[a,b,l]=ldaExtPoi(d,k,lam,20); %20 iteraties
VisuLDA(d,lam,a,10)