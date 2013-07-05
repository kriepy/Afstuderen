function [d,alpha,lam]=VisuLDA(d,lam,alpha,n)
% this function visualizes the first n days of the corpus.
% It runs the e step with calculated alpha and beta.
% n:= the amount of days you want to plot


emmax=100;
[~,k]=size(alpha);
cmap=colormap(hsv(k));
bm=round(lam)'

% Here the labels for the colorbar are gained
for i=1:k
    st=[];
    for j=1:size(bm,2)

        st=[st num2str(bm(i,j))];
        if j<size(bm,2)
            st=[ st ','];
        end
    end
    stringa{i}=st
end




hcb = colorbar('YTickLabel',...
stringa);
set(hcb, 'YTick', [1:k]+0.5, 'YTickMode','manual')
title('bathroom, kitchen, bedroom, living, hallway')

y=[0 0 1 1];
for i=1:n % for each day
    [alpha,phi]=vbem(d{i},lam,alpha,emmax);
    d{i}.phi=phi;
    x=[0 0.5 0.5 0];
    [N,~]=size(phi);
    for j=1:N %for each timeslice
        [~,ind]=max(phi(j,:)); 
        figure(1)
        hold on
        fill(x,y,cmap(ind,:));
        x=x+24/N;
    end
    y=y+1;
end
axis([0 24 0 10])
xlabel('hour')
ylabel('day')
alpha
end