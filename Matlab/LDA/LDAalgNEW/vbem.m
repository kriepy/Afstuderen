function [alpha,q] = vbem(d,beta,alpha0,emmax)
% [alpha,q] = vbem(d,beta,alpha0,[emmax])
% calculates a document and words posterior for a document d.
% alpha  : Dirichlet posterior for a document d
% q      : (L * K) matrix of word posterior over latent classes
% d      : document data
% alpha0 : Dirichlet prior of alpha
% emmax  : maximum # of EM iteration.
if nargin < 4
  emmax = 20;
end

%l = length(d.id); %length of this document
k = length(alpha0); %amount of clusters
N = size(d,1); %amount of words in document

q = zeros(N,k); %init phi
nt = ones(1,k) * N / k; %init gamma deel

pnt = nt;
for j = 1:emmax
  % estep
  q = mnormalize((d*beta)  .* repmat(exp(psi(alpha0 + nt)),N,1) ,2);

  nt = sum(q,1);
  % converge?
  if (j > 1) && converged(nt,pnt,1.0e-2)
    break;
  end
  pnt = nt;
end
alpha = alpha0 + nt;
