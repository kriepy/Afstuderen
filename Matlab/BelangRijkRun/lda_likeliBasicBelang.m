function [llh,Lalpha,d1,d2,d3,Lgamma] = lda_likeliBasicBelang( d , alpha , beta , gam ,Clus )
% This is for the LDA basic algorithm

% the likelihood depending on alpha
% will be only one value because alpha is the same for all documents
%Lalpha = repmat(gammaln(sum(alpha)),length(d),1) - repmat(sum(gammaln(alpha)),length(d),1)...
         %+ ((alpha-1) *( psi(gam)-repmat(psi(sum(gam,2)),1,size(gam,2)) )')' ;
Lalpha = repmat(gammaln(sum(alpha)),length(d),1) - repmat(sum(gammaln(alpha)),length(d),1)...
         + sum( repmat(alpha-1,length(d),1) .* ( psi(gam)-repmat(psi(sum(gam,2)),1,size(gam,2)) ) ,2);
     
% the likelihood depending on phi
% Lphi = sum(sum( phi (psi(gam)-psi(sum(gam))))) ...
N=48;
D=length(alpha);
d1=[];
d2=[];
d3=[];
for i=1:length(d)
    t=d{i};
    d1=[d1;sum(sum( (psi(gam(i,:))-psi(sum(gam(i,:)))) * t.phi'  ))]; 
       
       
    %d2=[d2;sum(sum(  (t.phi'*diag(t.cnt))'.* log(beta(t.id,:)) ))];
    be=zeros(size(t.phi));
    for n=1:N
        w=t.matOld(n,:);
        sig=repmat(sqrt(Clus.CovOld(t.idx(n))),1,5); %for each dimension
        mu=Clus.centroidsOld(t.idx(n),:);
        y=myNorm(w,mu,sig);
        be(n,:)=repmat(prod(y),1,length(alpha));
    end
    d2 = [d2 ;  sum(sum(t.phi.* log((t.mat*beta).*be)  ))];
    %d2 = [d2 ;  sum(sum(t.mat'*t.phi  .* log(beta) )) ];
    
    d3=[d3;sum(sum(t.phi.*log(t.phi)))];
    d3(isnan([d3]))=0;
end
Lphi=d1+d2-d3;

       

% the likelihood depending on gamma
% Lgamma = -gammaln(sum(gam,2)) + sum(gammaln(gam),2)...
%          -sum((gam-1)*( psi(gam)-repmat(psi(sum(gam,2)),1,size(gam,2)) )'  ,2);
Lgamma = -gammaln(sum(gam,2)) + sum(gammaln(gam),2)...
         -sum((gam-1).*( psi(gam)-repmat(psi(sum(gam,2)),1,size(gam,2)) )  ,2);


llh= Lalpha + Lphi + Lgamma;
%d3=-d3;
end
