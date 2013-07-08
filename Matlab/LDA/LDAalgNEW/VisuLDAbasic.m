function VisuLDAbasic(d,beta,alpha,n,V)
%needs to be adjusted to a fixed document length N(=48)
%hiervoor moet de data worden aangepast, ik moet dus ook onthouden voor
%elke dag en elke timeslice wat de bijbehorende cluster is. Misschien dat
%ook de vbem functie moet worden aangepast
close all
h = figure(1)
emmax=100;
[~,k]=size(alpha);
cmap=colormap(hsv(k));
y=[0 0 1 1];
for i=1:n
    [alpha,phi]=vbem(d{i}.mat,beta,alpha,emmax);
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
name = strcat(['pics/ClusterAantal', num2str(V),'.png']);
saveas(figure(1),name); %name is a string