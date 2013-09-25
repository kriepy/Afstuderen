%% Compare HOS and trainings set
close all
clear all

load OutcomeExp1_4ClusV6
HN=1;
kTemp=1;
k=kTemp*5
run=2; % er zijn 10 van
TS=48; % Amount of time slices
coarse = 0; % The time is Coarse if this variable is 1, 0 otherwise
V=6; %the amount of clusters
%k=20; %aantal topics
maxIter=100; %max aantal iteraties van LDA




H=DataClus{HN};
HOS = H.HOS;

a=H.Run{kTemp}.A(:,run*10-9:run*10);
b=H.Run{kTemp}.B(:,run*10-9:run*10);

figure(1)
VisuLDAbasic(HOS,b,a,3,6)
hold off
figure(2)
VisuLDAbasic(H.d,b,a,3,6)

path = '../../Data/DATAClustered/';
load(strcat([path,'Clustered',num2str(V),'TS',num2str(TS),'Coarse', num2str(coarse),'.mat']));
figure(3)
p=House{HN};
VisuClusters(p)