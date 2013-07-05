function [alpha,q] = vbem(d,lam,alpha0,emmax)
% [alpha,q] = vbem(d,beta,alpha0,[emmax])
% calculates a document and words posterior for a document d.
% alpha  : Dirichlet posterior for a document d
% q      : (L * K)-matrix of word posterior over latent classes
% d      : document data
% alpha0 : Dirichlet prior of alpha
% emmax  : maximum # of VB-EM iteration.
% $Id: vbem.m,v 1.5 2004/11/08 12:42:18 dmochiha Exp $
if nargin < 4
  emmax = 20;
end
mat=d.mat;

l = size(mat,1); %length of this document, amount of words
k = length(alpha0); %amount of clusters
nt = ones(1,k) * l / k; %in arcticle wordt dit gamma genoemt (mist hier nog + alpha)
pnt = nt;
for j = 1:emmax
  % vb-estep
  q=zeros(l,k);  % in article wordt dit phi genoemt
  for v=1:l
      w=repmat(mat(v,:)',1,k);
      qu=prod(myNormPoi(w,lam)).*(exp(psi(alpha0 + nt)));
      q(v,:)=qu;
  end
  
  q = mnormalize(q,2);
%   figure(2)
%   hold on
%   plot(q(1,1),q(1,2),'rx');
%   plot(q(end,1),q(end,2),'bx');
  % vb-mstep
  nt = sum(q);
  % converge?
  if (j > 1) && converged(nt,pnt,1.0e-2)
    break;
  end
  pnt = nt;
end
alpha = alpha0 + nt;
