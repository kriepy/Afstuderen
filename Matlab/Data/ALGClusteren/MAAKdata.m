%% SCRIPT om data te maken en te saven

load ../DATAMain/sepDays.mat %this generates the Variable 'House'
HN = 1;
TS = 96;
coarse = 0;
V = 8;

ClusterIt(House,HN,TS,coarse,V);