function Analyse

A=[];
B=[];
cmap=colormap(hsv(4))
for i=1:4
    load(strcat(['theta0.',num2str(i),'.mat']));
    A=[A Corpus.alpha];
    B=[B Corpus.beta(:,1)];
    figure(1)
    hold on
    plot(1:500,Corpus.Alpha(1,:),'Color',cmap(i,:))
    title Alpha
    hold off
    figure(2)
    hold on
    plot(1:500,Corpus.Beta(1,:),'Color',cmap(i,:))
    title Beta
    hold off
end
figure(3)
hold on
plot(A(1,:))
plot(A(2,:),'r')
title Alpha
hold off
figure(4)
hold on
plot(B(1,:))
plot(B(2,:),'r')
title Beta