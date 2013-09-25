%% show all days with the same topic
% you have given p,a and b
figure(3)
emmax=50;
for m=1:length(p)
    [alpha,phi]=vbem(p{m},b,a,emmax);
    bar(alpha)
end