function Q=KLdivergenceGau(m1,s1,m2,s2)

Q=[];
for i=1:length(m1)
    q=log(s2(i)/s1(i)) + (s1(i)^2+(m1(i)-m2(i))^2)/(2*s2(i)^2) - 0.5;
    Q=[Q q];
end
%Q=sum(Q);

