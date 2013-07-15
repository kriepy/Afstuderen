function [alpha,lam,likeli] = ldaExtPoi(d,k,lam,emmax,demmax)
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
  doLam= 1 ;
  if nargin < 4
      doLam= 1 ;
    emmax = 50;
    if nargin < 3
        doLam= 1 ;
    end
  end
end

%TOT HIER
n = length(d);
l = size(d{1}.mat,2); %dimensie van de woorden
if doLam
    lam = 10*rand(l,k);
end
alpha = (sort(rand(1,k)));

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
fprintf(1,'number of words          = %d\n', l);
fprintf(1,'number of latent classes = %d\n', k);
prevBet=0;
AA=[];
%% begin van EM iteraties
for j = 1:emmax
  fprintf(1,'iteration %d/%d..\t',j,emmax);
  
  % vb-estep
  PoiNum=zeros(l,k);
  PoiDem=zeros(1,k);
  for i = 1:n
   
    [gamma,q] = vbemPoi(d{i},lam,alpha,demmax); %q:=phi E-STEP
   
    gammas(i,:) = gamma; % foreach document a different gamma
    d{i}.phi=q;

    
    tempPoiNum = PoiNum;
    tempPoiDem = PoiDem;
    for topic=1:k
        tempPoiNum(:,topic)=sum(repmat(q(:,topic),1,l).*d{i}.mat)';
    end
    
    
    
    
    PoiNum=PoiNum+tempPoiNum;
    PoiDem=PoiDem+sum(q);

   
  end
  
  % m-step om beta te berekenen, smoothing van sigma om nul te voorkomen
  if isnan(prod(PoiDem))
      fprintf(1,'WRONG!!!!!!\n')
  end
  PoiDem=repmat(PoiDem,l,1);
  
  lam=PoiNum./PoiDem;

  
  % m-step om alpha te berekenen
  alpha = newton_alpha(gammas);
  AA=[AA;alpha];
  
  % converge?
   [ppl,l1,l2,l3,l4,l5] = lda_likeliPoi(d, alpha, lam ,gammas);
   %ppl = lda_lik(d,beta,gammas);
   L1=[L1 l1];
   L2=[L2 l2];
   L3=[L3 l3];
   L4=[L4 l4];
   L5=[L5 l5];
   LLH=[LLH ppl];
   fprintf(1,'Likelihood = %g\t',sum(ppl));
   likeli=sum(ppl);
   
   
   if isnan(sum(ppl))
       fprintf(1,'No convergence\n');
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
  if (j > 1) && (converged(ppl,pppl,1.0e-2))
    if (j < 2)
      fprintf(1,'\n We try the EM again\n');
%       fprintf(1,'Previous Alphas');
%       alpha      
%       fprintf(1,'WRONG mean Beta');
%       fprintf(1,'WRONG sigma Beta');
      [alpha,lam,l] = ldaExtPoi(d,k); % try again!
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
% fprintf(1,'alpha is\n');
% alpha
%figure(3)
%plot(AA(:,1),AA(:,2),'x')
fprintf(1,'\n');
end

% $Id: lda.m,v 1.8 2013/01/16 08:11:40 daichi Exp $
