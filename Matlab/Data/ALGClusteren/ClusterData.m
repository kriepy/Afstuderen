function H=ClusterData(dat,V,TC)

% houseNr
% k is the amount of clusters for k-means
% N is the amount of time slices on a day
% TC if this value is 1 the time coarse grain is used
% Should return the clusterd data in form d.cnt and d.id

Visu=0; %if visu 1 dan meteen clusters visualizeren
% possible options for the case cs are: Data6, Data16, Grof6, Grof16
%cs= 'Grof6';


%N is the amount of timeslices
N=size(dat{1},1);
len=1440/N;


%% create Dictionary
if TC==1
    %the dimension of the dictionary is 6
    dic = createDic(dat);
    H.Dic=dic;
    %save(strcat([pathPlain,'\Dic',num2str(houseNr),'Clusters']),'H');
else
    %the dimension of the dictionary becomes 5, we do not take the time
    %into account
end



[idx, c]=kmeans(H.Dic,V);

H.Clusters.idx=idx;
H.Clusters.centroids=c;


d=createLDAdata(H,dat);
H.dat=d;


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


