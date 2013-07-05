function Bic = calcBiC(alpha,beta,lik,n)
% lik:= this is the final likelihood that comes out of a run
% n:=   this is the amount of timeslices of all days in one corpus

k_a = length(alpha);
[la,li]=size(beta.mu);
degFree = k_a + 2*la*li;

Bic = - 2* lik + degFree * log(n);