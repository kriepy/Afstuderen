function [phi,gam]=Estep(alpha,beta,Doc)
pl=1; % 1 if you want to draw it
%%
% INPUT:
% alpha:= a vector of length k (amount of topics)
% beta:= a matrix of size k x V where V is the amount of words in
% dictionary
% Doc:= these are the words in the Document that is used. It is a matrix of
% V x N

% OUTPUT:
% phi:= a matrix of size N x k where N is the amount of words in the given
% document
% gamma:= a vector of length k
%% Initialize
[k,V] = size(beta);
[p,N]=size(Doc); %should be 48 with half hour slices

phi=1/k*ones(N,k);
gam=alpha+N/k;
%% Itarize
% psi(x) is the digamm function, the first derivative of log gamma function
prevPhi=phi;
itEStep=0;

conv=100;
while conv>0.001
    itEStep=itEStep+1;
    for n = 1:N %iterating over words in document
        wn=find(Doc(:,n));
        for i=1:k % itearize over all topics
            tes=exp(psi(gam(i)));
            phi(n,i)=beta(i,wn)*exp(psi(gam(i)));
        end
        phi(n,:)=phi(n,:)/sum(phi(n,:)); %normalize
    end
    gam=alpha+sum(phi,1)';
	conv=sum(sum(abs(prevPhi-phi)));
    
    %this part plots the phi for the first word
    if pl==1
        figure(2)
        hold on
        plot(phi(1,1),phi(1,2),'ro')
    end
    
    prevPhi=phi;
end

end

