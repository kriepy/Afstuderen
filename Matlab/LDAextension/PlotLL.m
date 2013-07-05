function PlotLL(l1,l2,l3,l4,l5,LLH)
figure(1)
%subplot(7,1,1); plot(LLH'); title Likelihood
subplot(3,2,1); plot(sum(LLH)); title SumLikelihood
%figure(2)
subplot(3,2,2); plot(sum(l1)); title LikeliAlpha
%subplot(3,1,2); plot(l5'); title LikeliGamma
subplot(3,2,3); plot(sum(l5)); title sumGammaLikeli
%figure(3)
subplot(3,2,4); plot(sum(l2)); title d1
subplot(3,2,5); plot(sum(l3)); title d2
subplot(3,2,6); plot(sum(l4)); title d3
 figure(2)
 subplot(5,1,1); plot(LLH'); title perDocLikeli
 subplot(5,1,2); plot(l5'); title GamPerDoc
 subplot(5,1,3); plot(l2'); title D1
 subplot(5,1,4); plot(l3'); title D2
 subplot(5,1,5); plot(l4'); title D3
 
end