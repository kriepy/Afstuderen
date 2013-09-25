function y=vonMisesPDF(x,mu,kap)
% this function calculates the de vonMises probability for a given x value
% x must be in an interval of 2 pi
% mu and kap zijn de parameters van deze functie
% 10 runs voor de bessel functie is ruim voldoende

if size(x,1)>1
    y = 0
    return
end


p=[];
for i=1:10
    p=[p ;besseli(i,kap)*cos(i*(x-mu))];
end
P=sum(p);
y=1/(2*pi) * (1+2/(besseli(0,kap))*P);

end