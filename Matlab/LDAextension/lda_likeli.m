function llh = lda_likeli( d , alpha , beta , gam  )
% For every document a likelihood is returned


% the likelihood depending on alpha
% will be only one value because alpha is the same for all documents
Lalpha = gammaln(sum(alpha)) - sum(gammaln(alpha))...
         + sum((alpha-1) *( psi(gam)-repmat(psi(sum(gam,2)),1,size(gam,2)) )'  ,2);
     

     
% the likelihood depending on phi
% Lphi = sum(sum( phi (psi(gam)-psi(sum(gam))))) ...

d1=[];
d2=[];
d3=[];
for i=1:length(d)
    t=d{i};
    
    %d1
    d1=[d1;sum(sum( (psi(gam(i,:))-psi(sum(gam(i,:)))) * t.phi'  ))]; 
    
    %d2=[d2;sum(sum(  (t.phi'*diag(t.cnt))'.* log(beta(t.id,:)) ))];
    be=[];%zeros(size(t.phi))
    for j=1:size(t.mat,1)
        w=repmat(t.mat(j,:)',1,length(alpha));
        be=[be;prod(myNorm(w,beta.mu,beta.sigma))];
    end
    %be=be+0.00000001;
 
    d2=[d2;sum(sum(t.phi.*log(be)))];
    
    
    %d3
    d3=[d3;sum(sum(t.phi.*log(t.phi)))];
    d3(isnan([d3]))=0;
end
Lphi=d1+d2+d3;%d1+d2+d3;
test=sum(Lphi);
% p1=sum(d1)
% p2=sum(d2)
% p3=sum(d3)
       

% the likelihood depending on gamma
Lgamma = -gammaln(sum(gam,2)) + sum(gammaln(gam),2)...
         -sum((gam-1)*( psi(gam)-repmat(psi(sum(gam,2)),1,size(gam,2)) )'  ,2);

fprintf(1,'\na is %g, d1 is %g, d2 is %g, d3 is %g, g is %g \n',sum(Lalpha),...
    sum(d1),sum(d2),sum(d3),sum(Lgamma));
     
llh= Lalpha +  Lgamma + Lphi;
end