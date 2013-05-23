function sumd=ClusterData(k)

Visu=0; %if visu 1 dan meteen visualizeren
houseNr=247;
len=30;
way='simple'
% possible options for the case cs are: Data6, Data16, Grof6, Grof16
cs= 'Data6'
if nargin<1
    k=20; %amount of clusters
end
N=24*60/len; %amount of timeslices

pathPlain='C:\Users\Kristin\UVA\Afstuderen\Afstuderen\Matlab\Data\DATACorpus\plainBewerkt';
pathDic='C:\Users\Kristin\UVA\Afstuderen\Afstuderen\Matlab\Data\DATACorpus\forLDAbasic'


storePath='C:\Users\Kristin\UVA\Afstuderen\Afstuderen\Matlab\Data\DATACorpus\forLDAbasic\';
name=strcat([storePath,'House',num2str(houseNr),'SL',num2str(len),'Clusters',num2str(k),way,'.mat']);



%% for the Dictionary
load(strcat([pathDic,'\House',num2str(houseNr),'SL',num2str(len),way,'.mat']));
if strcmp(cs,'Data6')
    DicGroot=House.DicData6;
    
    %maak Dic zonder tijd, 5D dus
    DicGroot=unique(DicGroot(:,1:5),'rows');
    
    sw=2;
    ew=N+1;
end
if strcmp(cs,'Data16')
    DicGroot=House.DicData16;
    sw=1;
    ew=N;
end
if strcmp(cs,'Grof6')
    DicGroot=House.DicGrof6;
end
if strcmp(cs,'Grof16')
    DicGroot=House.DicGrof16;
end

% here wordt geclustered. Misschien wat vaker clusteren en de clusters
% vergelijken
% DD=[];
% for k=1:100
%     [idx, c, sumd]=kmeans(DicGroot,k);
%     DD=[DD sum(sumd)];
% end
%   sortClusters(c)

[idx, c, sumd]=kmeans(DicGroot,k);
%% for the plain Data
load(strcat([pathPlain,'\House',num2str(houseNr),'SL',num2str(len),way,'.mat']));
if Visu
    cmap=colormap(hsv(k));
    y=[0 0 1 1];
end
    


for i=1:10%length(House.day)
    words=House.day{i}.data;
    doc=[];
    x=[0 0.5 0.5 0];
    for j=sw:ew
        w=words(j,1:5);
        ind=find(ismember(DicGroot,w,'rows'));
        doc=[doc idx(ind)];
        
        if (Visu && i<11)
            
            figure(1)
            hold on
            fill(x,y,cmap(idx(ind),:));
            x=x+24/N;
        end
    end
    if (Visu && i<11)
        y=y+1;
    end
    words=unique(doc);
    House.clus5D{i}.id=words;
    cnt=[];
    for p=words
        cnt=[cnt length(find(doc==p))]; 
    end
    House.clus5D{i}.cnt=cnt;
    
end
if Visu
    axis([0 24 0 10])
    xlabel('hour')
    ylabel('day')
end

House=rmfield(House,'day');

save(name,'House')
end




