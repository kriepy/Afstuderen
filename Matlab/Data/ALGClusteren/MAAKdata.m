%% SCRIPT om data te maken en te saven
clear all
load ../SET1/DATAMain/sepDays.mat %this generates the Variable 'House'
HN = 1;
TS = 48;
coarse = 0;
V = 8;
type = 'trans' % 'simple' or 'transitions' is possible

House = ClusterIt(House,HN,TS,coarse,V,type);


