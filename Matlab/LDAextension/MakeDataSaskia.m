function MakeDataSaskia(d,beta,alpha,l)

emmax=100;

for i=1:length(d) % for each day
    [alpha,phi]=vbem(d{i},beta,alpha,emmax);
    d{i}.phi=phi;
    [N,~]=size(phi);
    for j=1:N %for each timeslice
        [~,ind]=max(phi(j,:)); 
    end
end

save('forSaskia/254.mat','d','beta','alpha','l')


end