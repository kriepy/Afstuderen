function VisuLDAMosttopics(most,d,beta,alpha,n)
% this function visualizes the first n days of the corpus.
% and highlights the 5 most important topics in different colours
% It runs the e step with calculated alpha and beta.
% n:= the amount of days you want to plot
%close all
figure(2)
emmax=100;
[~,k]=size(alpha);
cmap=colormap(hsv(most));
bm=round(beta.mu)';

% Here the labels for the colorbar are gained from beta.mu
for i=1:k
    st=[];
    for j=1:size(bm,2)

        st=[st num2str(bm(i,j))];
        if j<size(bm,2)
            st=[ st ','];
        end
    end
    stringa{i}=st;
end

bv=round(beta.sigma);

% here the labels are gained from the alpha
[aa,idx]=sort(alpha,'descend');
for i=1:most
    stringa{i} = strcat(['Topic ',num2str(i)]);
end

hcb = colorbar('YTickLabel',...
stringa);
set(hcb, 'YTick', [1:most]+0.5, 'YTickMode','manual')
title('bathroom, kitchen, bedroom, living, hallway')

y=[0 0 1 1];
for i=1:n % for each day
    [alpha,phi]=vbem(d{i},beta,alpha,emmax);
    d{i}.phi=phi;
    x=[0 0.5 0.5 0];
    [N,~]=size(phi);
    for j=1:N %for each timeslice
        [~,ind]=max(phi(j,:)); 
        figure(2)
        hold on
        no = 0;
        for ja=1:most
            if idx(ja)==ind
                no=ja;
                break
            end
        end
        
        if no
            fill(x,y,cmap(no,:));
        else
            fill(x,y,[0.5,0.5,0.5]);
        end
        x=x+24/N;
    end
    y=y+1;
end
axis([0 24 0 10])
xlabel('time of the day')
ylabel('day')

% This is for setting the x-as Tick
set(gca,'XLim',[0 24]);
ticky=[0,5,10,15,20,24];
set(gca,'XTick',ticky);
TickLab = {'3am','8am','1pm','6pm','11pm','3am'};
set(gca,'XTicklabel',TickLab);




%figure(2)
%VisuTopicsNew(alpha,beta,most)

end