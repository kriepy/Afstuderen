function ClusterData

houseNr=254;

k=100; %amount of clusters

path='C:\Users\Kristin\UVA\Afstuderen\Afstuderen\Matlab\Data\DATACorpus';

storePath='C:\Users\Kristin\UVA\Afstuderen\Afstuderen\Matlab\Data\DATAclustered\';
name=strcat([storePath,'House',num2str(houseNr),'Clusters',num2str(k)]);
delete(name)
fid = fopen(name,'a');



load(strcat([path,'\House',num2str(houseNr),'.mat']));
DicGroot=House.DicWordsGrof;

[idx, c, sumd]=kmeans(DicGroot,k);
 

for i=1:length(House.day)
    words=House.day(i).WordsGrof;
    doc=[];
    for j=1:48
        w=words(j,:);
        ind=find(ismember(DicGroot,w,'rows'));
        doc=[doc idx(ind)];
    end
    
    unwor=unique(doc);
    
    array=[];
    for p=1:length(unwor)
        len=length(find(doc==unwor(p)));
        array=[array [' ', num2str(unwor(p)),':',num2str(len)]];
    end
    
    st=strcat([array,'\n']);
    
    st=sprintf(st);
    
    fprintf(fid, '%s', st);
    
    
end

fclose(fid);


end