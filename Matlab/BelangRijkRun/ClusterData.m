function [p,Clusters]=ClusterData(P,V)

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
N=size(P{1}.mat,1);
len=1440/N;

% if Norm=1 then the data will be normalized before it is clustered
Norm=1;

DA=[];
DD=[];
if Norm
    for ja = 1:length(P)
        P2{ja}.dat =   P{ja}.mat./repmat(maxa,size(P{ja}.mat,1),1);
        DA=[DA;P2{ja}.dat ];
        DD=[DD;P{ja}.mat];
    end
end

% applying k-means
while ~exist('idx','var')
    try
    [idx, c,dsum,D]=kmeans(DA,V);
    catch
        fprintf(1,'k-means didnt work. We try again');
    end
end
fprintf(1,'k-means worked!!');

% Calculate the Covariance
dis=[];
for li=1:size(DD,1)
    X=[DD(li,:);c(idx(li),:)];
    dis=[dis (pdist(X))^2];
end

m=[];
co=[];
for i=1:V
    m=[m sum(idx==i)];
    co=[co sum(dis'.*(idx==i))];
end


for la=1:length(P)
    f=[];
    g=[];
    id=[];
    ds=[];
    for n=1:N
        ff=zeros(1,V);
        ff(idx(1))=1;
        g=[g ;DA(1,:)];
        DA=DA(2:end,:);
        id=[id idx(1)];
        ds=[ds D(idx(1))];
        idx=idx(2:end);
        f=[f; ff];
    end
    p{la}.matOld=P{la}.mat;
    p{la}.mat=f;
    p{la}.idx=id;
    p{la}.dist=ds;
    p{la}.dat=g;
end



Clusters.centroids = c;
Clusters.centroidsOld = c.*repmat(maxa,6,1);
Clusters.Cov = dsum./(5.*m');
Clusters.CovOld = co./(5.*m);
