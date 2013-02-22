function VisuResult(Corpus)

% alleen 10 documenten worden gevisualiseert

[~,k]=size(Corpus.documents(1).phi)
cmap=colormap(hsv(k));
y=[0 0 1 1];
for i=1:10
    phi=Corpus.documents(i).phi;
    x=[0 1 1 0];
    [N,~]=size(Corpus.documents(i).phi)
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