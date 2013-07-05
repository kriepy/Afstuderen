function VisuTopics(a,b,show)

if nargin < 3
    show = 10
end

[a,ind]=sort(a,'descend');

mu=b.mu(:,ind)
sig=b.sigma(:,ind)
D=size(mu,1);
cmap=colormap(hsv(D));
x=0:24;

for i=1:show % show the most 5 important topics
    for d=1:D
        ax(i)=subplot(show,1,i);
        if ~(sig(d,i)<0.001)
            plot(x,normpdf(x,mu(d,i),sig(d,i)),'-','Color',cmap(d,:))
            hold on
        end
    end
end

hcb = colorbar('YTickLabel',{'Bathroom','Kitchen','Bedroom','Living','Hallway','Time'});
set(hcb, 'Position', [.8314 .11 .0581 .8150])
set(hcb, 'YTick', [1:D]+0.5, 'YTickMode','manual');
for i=1:show
    pos=get(ax(i),'Position');
    set(ax(i), 'Position', [pos(1) pos(2) 0.85*pos(3) pos(4)]);
end