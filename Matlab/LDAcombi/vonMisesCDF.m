function y=vonMisesCDF(x,mu,kap)
% deze functie kan alleen vectoren handelen die horizontaal zijn 
if size(x,1)>1
    y = 0
    return
end

p=[];
for i=1:10
    p=[p ;besseli(i,kap)*sin(i*(x-mu))/i];
end
P=sum(p);
y=1/(2*pi) * (x+2/(besseli(0,kap))*P);

end