
function [alpha,beta] = lda(d,k,emmax,demmax)
% Latent Dirichlet Allocation, standard model.
% Copyright (c) 2004 Daichi Mochihashi, all rights reserved.
% $Id: lda.m,v 1.8 2013/01/16 08:11:40 daichi Exp $
% [alpha,beta] = lda(d,k,[emmax,demmax])
% d      : data of documents
% k      : # of classes to assume
% emmax  : # of maximum VB-EM iteration (default 100)
% demmax : # of maximum VB-EM iteration for a document (default 20)
if nargin < 4
  demmax = 20;
  if nargin < 3
    emmax = 500;
  end
end
n = length(d);
l = features(d);
beta = mnormalize(rand(l,k),1);
Inbeta=beta;
alpha = normalize(fliplr(sort(rand(1,k))));
Inalpha=alpha;
gammas = zeros(n,k);
ppl = 0;
pppl = ppl;

LLH=[]; %the likelihood stored all values
l1=[];
l2=[];
l3=[];
l4=[];
l5=[];

tic;

fprintf(1,'number of documents      = %d\n', n);
fprintf(1,'number of words          = %d\n', l);
fprintf(1,'number of latent classes = %d\n', k);

for j = 1:emmax
  fprintf(1,'iteration %d/%d..\t',j,emmax);
  
  % vb-estep
  betas = ones(l,k);
  for i = 1:n
    [gamma,q] = vbem(d{i},beta,alpha,demmax); %q:=phi
    gammas(i,:) = gamma; % foreach document a different gamma
    d{i}.phi=q;
    betas = accum_beta(betas,q,d{i}); % a part of the m-step already
  end
  
  % vb-mstep
  alpha = newton_alpha(gammas);
  beta = mnormalize(betas,1);
  % converge?
   [ppl,la1,lp2,lp3,lp4,lg5] = lda_likeliBasic(d, alpha, beta,gammas);
   %ppl = lda_lik(d,beta,gammas);
   l1=[l1,la1];
   l2=[l2, lp2];
   l3=[l3, lp3];
   l4=[l4, lp4];
   l5=[l5, lg5];
   LLH=[LLH ppl];
   fprintf(1,'Likelihood = %g\t',ppl(1));
   
   
   
   if (j>50)
       minLikeli=sum(ppl);
   end
   if (j>50 && minLikeli < sum(ppl)) 
       fprintf(1,'\nThe likelihood is getting smaller. Not good!\n');
       return
   end
  if (j > 1) && converged(ppl,pppl,1.0e-4)
    if (j < 5)
      fprintf(1,'\n');
      [alpha,beta] = lda(d,k,emmax,demmax); % try again!
      return
    end
    fprintf(1,'\nconverged.\n');
    %plot(LLH'); title Likelihood
%     figure(2)
%     plot(beta(:,1),beta(:,2),'xr')
    Inbeta
    Inalpha
    fprintf(1,'I got here');
    break
  end
  pppl = ppl;
  % ETA
  elapsed = toc;
  fprintf(1,'ETA:%s (%d sec/step)\r', ...
	  rtime(elapsed * (emmax / j  - 1)),round(elapsed / j));
end

PlotLL(l1,l2,l3,l4,l5,LLH);
% plot(beta(:,1),beta(:,2),'xr')
%Inbeta
%Inalpha
fprintf(1,'\n');
end

% $Id: lda.m,v 1.8 2013/01/16 08:11:40 daichi Exp $
