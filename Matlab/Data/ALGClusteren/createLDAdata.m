function d=createLDAdata(House)
% This function creates from the data and the found clusters in the
% dictionary the two fielded data that is needed in LDAbasic.


% k is the amount of clusters and dime is the dimension of words
[k,dime]=size(House.Clusters.centroids);
[TL,~]=size(House.day{1}.DataForClusters);

for i=1:length(House.day)
    CntVec=zeros(1,k);
    
    for j=1:TL
        word=House.day{i}.DataForClusters(j,:);
        clus = House.Clusters.idx(find(ismember(House.Clusters.idx,word),1));
        CntVec(clus)=CntVec(clus)+1;
    end
    
    d{i}.id = find(CntVec);
    d{i}.cnt = CntVec(d{i}.id);
end