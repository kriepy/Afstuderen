function VisuTopicsNew(a,b,show)
if nargin < 3
    show = 5
end

[a,ind]=sort(a,'descend');

mu=b.mu(:,ind);
sig=b.sigma(:,ind);
D=size(mu,1);
x=0:24;
Fields={'Bathroom','Kitchen','Bedroom','Living','Hallway'};
cmap=colormap(hsv(show));


maxY=1;
minY=-1;
for s=1:show
    subplot(show,4,(4*s-3):(4*s-1))
    for d=1:D-1
        bar(mu(1:5,s),'FaceColor',cmap(s,:));
        hold on
        errorbar(1:5,mu(1:5,s),sig(1:5,s),'.k','LineWidth',2)
        axis([0.1 5.9 -5 10])
        if s==show
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
    %for the time
    subplot(show,4,4*s)
    bar(mu(6,s),'FaceColor',cmap(s,:));
    hold on
    errorbar(1,mu(6,s),sig(6,s),'.k','LineWidth',2)
    axis([0.1 1.9 0 48])
    if s==show
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


end
% cmap=colormap(hsv(D));
% x=0:24;
% 
% for i=1:show % show the most 5 important topics
%     for d=1:D
%         ax(i)=subplot(show,1,i);
%         if ~(sig(d,i)<0.001)
%             plot(x,normpdf(x,mu(d,i),sig(d,i)),'-','Color',cmap(d,:))
%             hold on
%         end
%     end
% end
% 
% hcb = colorbar('YTickLabel',{'Bathroom','Kitchen','Bedroom','Living','Hallway','Time'});
% set(hcb, 'Position', [.8314 .11 .0581 .8150])
% set(hcb, 'YTick', [1:D]+0.5, 'YTickMode','manual');
% for i=1:show
%     pos=get(ax(i),'Position');
%     set(ax(i), 'Position', [pos(1) pos(2) 0.85*pos(3) pos(4)]);
% end