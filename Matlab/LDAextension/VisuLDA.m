function VisuLDA(d,beta,alpha,n)
% this function visualizes the first n days of the corpus.
% It runs the e step with calculated alpha and beta.
close all


emmax=100;
[~,k]=size(alpha);
cmap=colormap(hsv(k));
y=[0 0 1 1];
for i=1:n
    [alpha,phi]=vbem(d{i},beta,alpha,emmax);
    x=[0 1 1 0];
    [N,~]=size(phi);
    for j=1:N
        [~,ind]=max(phi(j,:)); 
        figure(1)
        hold on
        fill(x,y,cmap(ind,:));
        x=x+1;
    end
    y=y+1;
end

end