function VisuLDAbasic(d,beta,alpha,n)
%needs to be adjusted to a fixed document length N(=48)
%hiervoor moet de data worden aangepast, ik moet dus ook onthouden voor
%elke dag en elke timeslice wat de bijbehorende cluster is. Misschien dat
%ook de vbem functie moet worden aangepast
figure(2)
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