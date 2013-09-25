function VisuLDAbasic(most,d,beta,alpha0,n,V)
%needs to be adjusted to a fixed document length N(=48)
%hiervoor moet de data worden aangepast, ik moet dus ook onthouden voor
%elke dag en elke timeslice wat de bijbehorende cluster is. Misschien dat
%ook de vbem functie moet worden aangepast
%close all
%figure(1)
emmax=100;
[~,k]=size(alpha0);
cmap=colormap(hsv(k));
y=[0 0 1 1];
[sD,~]=size(d{1}.mat);
for i=1:n
    [alpha,phi]=vbem(d{i}.mat,beta,alpha0,emmax);
    x=[0 1 1 0];
    [N,~]=size(phi);
    for j=1:N
        [~,ind]=max(phi(j,:));
        
        
        hold on
        fill(x,y,cmap(ind,:));
        x=x+1;
    end
    y=y+1;
end
axis([0 24 0 n])
xlabel('time of the day')
ylabel('day')

% here the labels are gained from the alpha
[aa,idx]=sort(alpha0,'descend');
for i=1:most
    stringa{i} = strcat(['Topic ',num2str(i)]);
end
hcb = colorbar('YTickLabel',...
stringa);
set(hcb, 'YTick', [1:most]+0.5, 'YTickMode','manual')
title('bathroom, kitchen, bedroom, living, hallway')

% This is for setting the x-as Tick
set(gca,'XLim',[0 sD]);
ticky=[0,5,10,15,20,24];
set(gca,'XTick',4*ticky);
TickLab = {'3am','8am','1pm','6pm','11pm','3am'};
set(gca,'XTicklabel',TickLab);

%name = strcat(['pics/ClusterAantal', num2str(V),'.png']);
%saveas(figure(1),name); %name is a string