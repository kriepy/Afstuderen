function d=createLDAdata(H,dat)
% This function creates from the data and the found clusters in the
% dictionary the two fielded data that is needed in LDAbasic.


% k is the amount of clusters and dime is the dimension of words
V=size(H.Clusters.centroids,1);
N=size(dat{1}.dat,1);


for i=1:length(dat)
    p=zeros(N,V);
    
    for j=1:N
        word=dat{i}.dat(j,:);
        clus = H.Clusters.idx(find(ismember(H.Clusters.idx,word),1));
        p(j,clus)=1;
    end
    d{i}.dat=p;
end