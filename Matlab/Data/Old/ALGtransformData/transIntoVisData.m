% this script shoult store for every day a vector with the index of the
% word of the dictionary

houseNr=254;

path='C:\Users\Kristin\UVA\Afstuderen\Afstuderen\Matlab\Data\DATACorpus\House'

load(strcat([path,num2str(houseNr),'SliLen30.mat']));

name=strcat(['C:\Users\Kristin\UVA\Afstuderen\Afstuderen\Matlab\Data\DATACorpus\Visu48House',num2str(houseNr),'.mat']);
V=[]
for i=1:length(House.documents)
    doc=House.documents(i).doc;
    vec=[];
    for j=1:size(doc,2)
        vec=[vec find(doc(:,j))];
    end
    V=[V;vec];
    
end

save(name,'V');