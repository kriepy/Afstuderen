function sortedCl=sortClusters(cluster)
    [k,dimen]=size(cluster);
    [~,ind]=sort(cluster(:,1));
    
    
    sortedCl=cluster(ind,:);
end