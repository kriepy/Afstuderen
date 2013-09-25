function [HOSc,dc]=ClusterDataNew(HOS,d,V)

% houseNr
% k is the amount of clusters for k-means
% N is the amount of time slices on a day
% TC if this value is 1 the time coarse grain is used
% Should return the clusterd data in form d.cnt and d.id
fprintf(1,'Starting the Clustering\n');
Visu=0; %if visu 1 dan meteen clusters visualizeren
% possible options for the case cs are: Data6, Data16, Grof6, Grof16
%cs= 'Grof6';

% Combining the two structs
P=[HOS d];

% Finding the maximum values
maxa = zeros(1,5);
for i=1:length(P)
    tempMa=max(P{i}.mat,[],1);
    for la = 1:length(tempMa)
        if maxa(la)<tempMa(la)
            maxa(la)=tempMa(la);
        end
    end
end
maxa


%N is the amount of timeslices
N=size(HOS{1}.mat,1);
len=1440/N;

% if Norm=1 then the data will be normalized before it is clustered
Norm=1;

DA=[];
if Norm
    for ja = 1:length(P)
        P2{ja}.dat =   P{ja}.mat./repmat(maxa,size(P{ja}.mat,1),1);
        DA=[DA;P2{ja}.dat ];
    end
end


% applying k-means
while ~exist('idx','var')
    try
    [idx, c]=kmeans(DA,V);
    catch
        fprintf(1,'k-means didnt work. We try again');
    end
end
fprintf(1,'k-means worked!!');

for la=1:length(HOS)
    f=[];
    for n=1:N
        ff=zeros(1,V);
        ff(idx(1))=1;
        idx=idx(2:end);
        f=[f; ff];
    end
    HOSc{la}.mat=f;
end

for la=1:length(d)
    f=[];
    for n=1:N
        ff=zeros(1,V);
        ff(idx(1))=1;
        idx=idx(2:end);
        f=[f; ff];
    end
    dc{la}.mat=f;
end


end
%% for the plain Data
%load(strcat([pathPlain,'\House',num2str(houseNr),'SL',num2str(len),way,'.mat']));
% if Visu
%     cmap=colormap(hsv(k));
%     y=[0 0 1 1];
% end
%     
% 
% 
% for i=1:10%length(House.day)
%     words=H.day{i}.data;
%     doc=[];
%     x=[0 0.5 0.5 0];
%     for j=1:N
%         w=words(j,1:5);
%         ind=find(ismember(H.Dic,w,'rows'));
%         doc=[doc idx(ind)];
%         
%         if (Visu && i<11)
%             
%             figure(1)
%             hold on
%             fill(x,y,cmap(idx(ind),:));
%             x=x+24/N;
%         end
%     end
%     if (Visu && i<11)
%         y=y+1;
%     end
%     words=unique(doc);
%     House.clus5D{i}.id=words;
%     cnt=[];
%     for p=words
%         cnt=[cnt length(find(doc==p))]; 
%     end
%     House.clus5D{i}.cnt=cnt;
%     
% end
% if Visu
%     axis([0 24 0 10])
%     xlabel('hour')
%     ylabel('day')
% end
% 
% House=rmfield(House,'day');

%save(name,'House')

%load(strcat([pathDic,'\House',num2str(houseNr),'SL',num2str(len),'simple.mat']));
% if strcmp(cs,'Data6')
%     DicGroot=House.DicData6;
%     
%     %maak Dic zonder tijd, 5D dus
%     DicGroot=unique(DicGroot(:,1:5),'rows');
%     
%     sw=2;
%     ew=N+1;
% end
% if strcmp(cs,'Data16')
%     DicGroot=House.DicData16;
%     sw=1;
%     ew=N;
% end
% if strcmp(cs,'Grof6')
%     DicGroot=House.DicGrof6;
% end
% if strcmp(cs,'Grof16')
%     DicGroot=House.DicGrof16;
% end

% here wordt geclustered. Misschien wat vaker clusteren en de clusters
% vergelijken
% DD=[];
% for k=1:100
%     [idx, c, sumd]=kmeans(DicGroot,k);
%     DD=[DD sum(sumd)];
% end
%   sortClusters(c)


