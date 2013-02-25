function llh = lda_likeli( d , alpha , beta , gam  )

% the likelihood depending on alpha
% will be only one value because alpha is the same for all documents
Lalpha = log(gamma(sum(alpha))) - sum(log(gamma(alpha)))...
         + sum((alpha-1) *( psi(gam)-repmat(psi(sum(gam,2)),1,size(gam,2)) )'  ,2);
     
     
% the likelihood depending on phi
% Lphi = sum(sum( phi (psi(gam)-psi(sum(gam))))) ...

d1=[];
d2=[];
d3=[];
for i=1:length(d)
    t=d{i};
    d1=[d1;sum( (psi(gam(i,:))-psi(sum(gam(i,:)))) * (t.phi'*diag(t.cnt))  )]; 
    
    d2=[d2;sum(sum(  (t.phi'*diag(t.cnt))'.* log(beta(t.id,:)) ))];
    
    d3=[d3;sum(sum(diag(t.cnt)*t.phi.*log(t.phi)))];
end
Lphi=d1+d2+d3;

       

% the likelihood depending on gamma
Lgamma = -log(gamma(sum(gam,2))) + sum(log(gamma(gam)),2)...
         -sum((gam-1)*( psi(gam)-repmat(psi(sum(gam,2)),1,size(gam,2)) )'  ,2);



llh= Lalpha + Lphi + Lgamma;
end