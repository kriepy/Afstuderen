function VisuTop(mu,sigma)
% this function only visualize one topic
D=length(mu);
cmap=colormap(hsv(D));
x=0:24;

for d=1:D
    if ~(sigma(d)<0.001)
        plot(x,normpdf(x,mu(d),sigma(d)),'-','Color',cmap(d,:));
        hold on
    end
end
hcb = colorbar('YTickLabel',{'Bathroom','Kitchen','Bedroom','Living','Hallway','Time'});
set(hcb, 'Position', [.8314 .11 .0581 .8150])
set(hcb, 'YTick', [1:D]+0.5, 'YTickMode','manual');