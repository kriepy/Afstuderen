function [alpha,beta,likeli] = ldaExtension(d,k,beta,emmax,demmax)
close all
% Latent Dirichlet Allocation, standard model.
% Copyright (c) 2004 Daichi Mochihashi, all rights reserved.
% $Id: lda.m,v 1.8 2013/01/16 08:11:40 daichi Exp $
% [alpha,beta] = lda(d,k,[emmax,demmax])
% d      : data of documents
% k      : # of classes to assume
% emmax  : # of maximum VB-EM iteration (default 100)
% demmax : # of maximum VB-EM iteration for a document (default 20)
if nargin < 5
  demmax = 20;
  if nargin < 4
    emmax = 50;
    if nargin < 3
        doBeta= 1 ; 
    else
        doBeta=0;
    end
  end
end
n = length(d);
l = size(d{1}.mat,2); %dimensie van de woorden
if doBeta
    beta.mu = 10*rand(l,k);
    beta.sigma = 1*ones(l,k);
end
Inbeta=beta;
alpha = fliplr(sort(rand(1,k)));
Inalpha=alpha;
gammas = zeros(n,k);
ppl = 0;
pppl = ppl;

LLH=[]; %the likelihood stored for every iteration

tic;

fprintf(1,'number of documents      = %d\n', n);
fprintf(1,'number of words          = %d\n', l);
fprintf(1,'number of latent classes = %d\n', k);
prevBet=0;
%% begin van EM iteraties
for j = 1:emmax
  fprintf(1,'iteration %d/%d..\t',j,emmax);
  
  % vb-estep
  %betas = ones(l,k); %smooting part, moet denk ik anders
  numeratorPhi=zeros(1,k);
  tellerMuPhi=zeros(l,k);
  tellerSigPhi=zeros(l,k);
  for i = 1:n
    [gamma,q] = vbem(d{i},beta,alpha,demmax); %q:=phi
    gammas(i,:) = gamma; % foreach document a different gamma
    d{i}.phi=q;
    %% TOT HIER GOED
    
    tempTellerMu = tellerMuPhi;
    tempTellerSig = tellerSigPhi;
    for topic=1:k
        tempTellerMu(:,topic)=sum(repmat(q(:,topic),1,l).*d{i}.mat)';
        tempTellerSig(:,topic)=sum(repmat(q(:,topic),1,l).*((d{i}.mat).^2))';
    end
    
    
    
    
    tellerMuPhi=tellerMuPhi+tempTellerMu;
    tellerSigPhi=tellerSigPhi+tempTellerSig;
    numeratorPhi=numeratorPhi+sum(q);

    
  end
  
  % m-step om beta te berekenen, smoothing van sigma om nul te voorkomen
  numeratorPhi=repmat(numeratorPhi,l,1);
  beta.mu=tellerMuPhi./numeratorPhi;
  beta.sigma=tellerSigPhi./numeratorPhi-((beta.mu).^2)+0.00000001; 
  
  
  % m-step om alpha te berekenen
  alpha = newton_alpha(gammas);
  
  % converge?
   ppl = lda_likeli(d, alpha, beta,gammas); %DEZEFUNCTIE AANPASSEN
   %ppl = lda_lik(d,beta,gammas);
   LLH=[LLH ppl];
   beta.mu;
   beta.sigma;
   fprintf(1,'Likelihood = %g\t',sum(ppl));
   likeli=sum(ppl);
   
   
%    if isnan(sum(ppl))
%        fprintf(1,'No convergence\n');
%         Inbeta.mu
%         beta.mu
%        return
%    end
%    if (j>50 && minLikeli < sum(ppl)) 
%        fprintf(1,'\nThe likelihood is getting smaller. Not good!\n');
%        return
%    end
   % Bet=sum(sum(beta.mu));
  if (j > 1) && (converged(ppl,pppl,1.0e-4))
    if (j < 5)
      fprintf(1,'\n');
      [alpha,beta] = ldaExtension(d,k); % try again!
      return;
    end
    fprintf(1,'\nconverged.\n');
    plot(LLH'); title Likelihood
%     figure(2)
%     plot(beta(:,1),beta(:,2),'xr')
    beta.sigma
    Inbeta.mu
    beta.mu
    return;
  end
%   prevBet=Bet;
  pppl = ppl;
  % ETA
  elapsed = toc;
  fprintf(1,'ETA:%s (%d sec/step)\r', ...
	  rtime(elapsed * (emmax / j  - 1)),round(elapsed / j));
end

figure(1)
plot(LLH'); title Likelihood
% figure(2)
% plot(beta(:,1),beta(:,2),'xr')
fprintf(1,'Sigma is');
beta.sigma
Inbeta.mu
beta.mu
fprintf(1,'\n');
end

% $Id: lda.m,v 1.8 2013/01/16 08:11:40 daichi Exp $
