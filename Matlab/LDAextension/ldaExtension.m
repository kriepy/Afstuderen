function [alpha,beta,likeli,ppl] = ldaExtension(d,k,beta,emmax,demmax)
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
  doBeta=0;
  if nargin < 4
    doBeta=0;
    emmax = 50;
    if nargin < 3
        doBeta= 1 ;
        %beta=0;
  end
end
n = length(d);
l = size(d{1}.mat,2); %dimensie van de woorden
if doBeta
    beta.mu = 10*rand(l,k);
    beta.sigma = 8*ones(l,k);
end
Inbeta=beta;
alpha = (sort(rand(1,k)));
Inalpha=alpha;
gammas = zeros(n,k);
ppl = 0;
pppl = ppl;

LLH=[]; %the likelihood stored for every iteration
L1=[];
L2=[];
L3=[];
L4=[];
L5=[];


tic;

fprintf(1,'number of documents      = %d\n', n);
fprintf(1,'number of dimensions     = %d\n', l);
fprintf(1,'number of latent classes = %d\n', k);
prevBet=0;
AA=[];
%% begin van EM iteraties
for j = 1:emmax
  fprintf(1,'iteration %d/%d..\t',j,emmax);
  
  % vb-estep
  %betas = ones(l,k); %smooting part, moet denk ik anders
  numeratorPhi=zeros(1,k);
  tellerMuPhi=zeros(l,k);
  tellerSigPhi=zeros(l,k);
  for i = 1:n
    [gamma,q] = vbem(d{i},beta,alpha,demmax); %q:=phi E-STEP
    gammas(i,:) = gamma; % foreach document a different gamma
    d{i}.phi=q;

    
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
  %numeratorPhi(numeratorPhi<0.00000001)=1;
  % m-step om beta te berekenen, smoothing van sigma om nul te voorkomen
  numeratorPhi=repmat(numeratorPhi,l,1);
  beta.mu=tellerMuPhi./numeratorPhi;
  beta.sigma=sqrt(tellerSigPhi./numeratorPhi-((beta.mu).^2)+0.00000001); 
  if isnan(sum(sum(beta.mu)))
      fprintf(1,'I got here!');
  end
  if isnan(sum(sum(tellerMuPhi)))
      fprintf(1,'DUDE, thats not good');
  end
  
  % m-step om alpha te berekenen
  alpha = newton_alpha(gammas);
  AA=[AA;alpha];
  
  % converge?
   [ppl,l1,l2,l3,l4,l5] = lda_likeli(d, alpha, beta,gammas);
   %ppl = lda_lik(d,beta,gammas);
   L1=[L1 l1];
   L2=[L2 l2];
   L3=[L3 l3];
   L4=[L4 l4];
   L5=[L5 l5];
   LLH=[LLH ppl];
   beta.mu;
   beta.sigma;
   fprintf(1,'Likelihood = %g\t',sum(ppl));
   likeli=sum(ppl);
   prevL3 = l3;
   
   
   if isnan(sum(ppl))
       fprintf(1,'No convergence\n');
        beta.sigma
        beta.mu
        subplot(2,1,1)
        plot(LLH'); title Likelihood
        subplot(2,1,2)
        plot(sum(LLH)); title SumLikelihood
       return
   end
%    if (j>50 && minLikeli < sum(ppl)) 
%        fprintf(1,'\nThe likelihood is getting smaller. Not good!\n');
%        return
%    end
   % Bet=sum(sum(beta.mu));
  if (j > 1) && (converged(ppl,pppl,1.0e-3))
    if (j < 5)
      fprintf(1,'\n We try the EM again\n');
      fprintf(1,'Previous Alphas');
%       Inalpha
%       alpha      
%       fprintf(1,'WRONG mean Beta');
%       beta.mu
%       fprintf(1,'WRONG sigma Beta');
%       beta.sigma
      [alpha,beta,l] = ldaExtension(d,k); % try again!
      return;
    end
    fprintf(1,'\nconverged.\n');
    fprintf(1,'Likelihood is %g\t',sum(ppl));
%     figure(2)
%     plot(beta(:,1),beta(:,2),'xr')
    break
  end
%   prevBet=Bet;
  pppl = ppl;
  % ETA
  elapsed = toc;
  fprintf(1,'ETA:%s (%d sec/step)\r', ...
	  rtime(elapsed * (emmax / j  - 1)),round(elapsed / j));
end

%PlotLL(L1,L2,L3,L4,L5,LLH);
% plot(beta(:,1),beta(:,2),'xr')
% fprintf(1,'Sigma is\n');
% beta.sigma
% fprintf(1,'Mu is\n');
% beta.mu
% fprintf(1,'alpha is\n');
% alpha
% figure(3)
% plot(AA(:,1),AA(:,2),'x')
% fprintf(1,'previouse mu and sigma\n')
% Inbeta.mu
% Inbeta.sigma
% fprintf(1,'Init alpha\n');
% Inalpha
% fprintf(1,'\n');
end

