function L=Low(a1,a2,Corpus)

M=length(Corpus.documents);
L=0;
for i=1:M
    gam=Corpus.documents(i).gamma;
   l=log(gamma(a1+a2))-...
   (log(gamma(a1))+log(gamma(a2)))+...
   (a1-1)*(psi(gam(1))-psi(sum(gam)))...
   +(a2-1)*(psi(gam(2))-psi(sum(gam)));
    L=L+l;
end

end
    