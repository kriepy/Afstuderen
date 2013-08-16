    function VisuTopicsPois(a,b,show,timeMax)
if nargin < 3
    show = 5
end

[a,ind]=sort(a,'descend');

lam=b(:,ind);
D=size(lam,1);
x=0:24;
Fields={'Bathroom','Kitchen','Bedroom','Living','Hallway'};
cmap=colormap(hsv(show));

maxY=1;
minY=-1;
for ss=1:show
    s=show-ss+1;
    subplot(show,4,(4*s-3):(4*s-1))
    for d=1:D-1
        bar(lam(1:5,ss),'FaceColor',cmap(ss,:));
        hold on
        axis([0.1 5.9 0 10])
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
    if D==6
        subplot(show,4,4*s)
        bar(lam(6,ss),'FaceColor',cmap(ss,:));
        hold on
        axis([0.1 1.9 0 timeMax])
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


end