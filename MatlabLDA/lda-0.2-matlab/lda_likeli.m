function llh = lda_likeli( d , alpha , beta , gam  )

% the likelihood depending on alpha
Lalpha = log(gamma(sum(alpha))) - sum(log(gamma(alpha)))...
         + sum((alpha-1) *( psi(gam)-repmat(psi(sum(gam,2)),1,size(gam,2)) )'  ,2);
     
     
% the likelihood depending on phi
% kan niet maar zo worden berekend om dat de phis niet worden opgeslagen
% Lphi = sum(sum( phi (psi(gam)-psi(sum(gam))))) ...
       

% the likelihood depending on gamma
Lgamma = -log(gamma(sum(gam,2))) + sum(log(gamma(gam)),2)...
         -sum((gam-1)*( psi(gam)-repmat(psi(sum(gam,2)),1,size(gam,2)) )'  ,2);



llh= Lalpha + Lgamma;
end