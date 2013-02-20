function beta=getBeta(Corpus,k)
%%
% INPUT: phi:= this is the variable that you get from the E-step
%        words:= the 



beta=ones(k,Corpus.V);

M=length(Corpus.documents);

for d=1:M
    [~,N]=size(Corpus.documents(d).doc);
    for n=1:N
        j=find(Corpus.documents(d).doc(:,n));
        for i=1:k
            beta(i,j)=beta(i,j)+Corpus.documents(d).phi(n,i);
        end
    end
end

SB=sum(beta,2);
for i=1:k
    beta(i,:)=beta(i,:)./SB(i);
end
end