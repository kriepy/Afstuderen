function VisuClusDay(d)
% This functions visualizes how the clusters are distributed over the days
% so we can compare it to the other outcomes
n=length(d)
cmap=colormap(hsv(size(d{1}.ClusteredData,2)));
y=[0 0 1 1];
for i=1:n
    %[alpha,phi]=vbem(d{i}.mat,beta,alpha,emmax);
    x=[0 1 1 0];
    p=d{i}.ClusteredData;
    [N,~]=size(p);
    for j=1:N
        [~,ind]=max(p(j,:));
        
        
        hold on
        fill(x,y,cmap(ind,:));
        x=x+1;
    end
    y=y+1;
end