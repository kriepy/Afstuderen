function P = calcPerpl(alpha,beta,HOS)

len = length(HOS);
demmax = 20;
for i=1:len
    [gamma,q] = vbemPoi(HOS{i},beta,alpha,demmax); %q:=phi E-STEP
    gammas(i,:) = gamma; % foreach document a different gamma
    HOS{i}.phi=q;
end

[ppl,l1,l2,l3,l4,l5] = lda_likeliPoi(HOS, alpha, beta,gammas);

M = size(HOS{1}.mat,1);
P = exp(-sum(ppl)/(M*len));