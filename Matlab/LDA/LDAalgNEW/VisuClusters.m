function VisuClusters(p)
Clus =p.Clusters.centroids;
[V,D]=size(Clus);
cmap=colormap(hsv(V));
Fields={'Bathroom','Kitchen','Bedroom','Living','Hallway'};

for s=1:V
    subplot(V,4,(4*s-3):(4*s-1))
    for d=1:D-1
        bar(Clus(s,1:5),'FaceColor',cmap(s,:));
        hold on
        axis([0.1 5.9 0 1])
        if s==V
            ax=axis;
            axis(axis); % Set the axis limit modes (e.g. XLimMode) to manual
            Yl = ax(3:4); % Y-axis limits
            t = text(1:5,Yl(1)*ones(1,5),Fields);
            set(t,'HorizontalAlignment','right','VerticalAlignment','top', ...
            'Rotation',45);
            set(gca,'XTicklabel','');
        else
            set(gca,'XTicklabel','');
        end
    end
    subplot(V,4,4*s)
    bar(Clus(s,6),'FaceColor',cmap(s,:));
    axis([0.1 1.9 0 1])
    if s==V
        ax=axis;
        axis(axis); % Set the axis limit modes (e.g. XLimMode) to manual
        Yl = ax(3:4); % Y-axis limits
        t = text(1,Yl(1)*ones(1),'Time');
        set(t,'HorizontalAlignment','right','VerticalAlignment','top', ...
        'Rotation',45);
        set(gca,'XTicklabel','');
    else
        set(gca,'XTicklabel','');
    end
end


end % from the function