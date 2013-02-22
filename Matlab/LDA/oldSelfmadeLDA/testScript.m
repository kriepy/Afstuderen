load('test.txt');


for i=1:20
    s=sum(test(i,:))
    l=find(test(i,:))
    trop=[]
    for j=1:length(l)
        amount=test(i,l(j))
        where=l(j)
        flop=zeros(8,amount);
        flop(where,:)=ones(1,amount);
        trop=[trop flop]
    end
    CompCor.documents(i).doc=trop
end