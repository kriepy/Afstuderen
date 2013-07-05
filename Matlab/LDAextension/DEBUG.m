% This is a script to debug the LDAext function


d=maakTestData
k=2;

m=[];
for i=1:length(d)
    m=[m;max(d{i}.mat)];
end
m=max(m,[],1);


beta.mu=[];
for i=1:length(m)
    beta.mu=[beta.mu;m(i)*rand(1,k)];
end
beta.sigma=ones(length(m),k);
[a,b,l]=ldaExtension(d,k,beta,20); %20 iteraties