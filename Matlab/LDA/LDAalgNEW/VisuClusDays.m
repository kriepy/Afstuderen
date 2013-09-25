function VisuClusDays(d,V)

N=length(d{1}.ClusDataIdx);
cmap = colormap(hsv(V));

y=[0 0 1 1];
for i=1:50
    dd=d{i}.ClusDataIdx;
    x=[0 0.5 0.5 0];
    for n=1:N
        hold on
        fill(x,y,cmap(dd(n),:));
        x=x+24/N;
    end
    y=y+1;
end

end