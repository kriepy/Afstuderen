function getOverview(H)

Words=[];
for i=1:length(H.day)
    Words=[Words; [H.day{i}.PreClusteredData(:,1:5) (1:size(H.day{i}.PreClusteredData,1))' ]];
end
fprintf(1,'The number of words is %d\n',size(Words,1))
[C,ia,ic]=unique(Words,'rows','sorted');
L=[];
for i=1:size(C,1)
    p=sum(ismember(Words,C(i,:),'rows'));
    L=[L p];
end
    NB=sort(L,'descend');
    bar(NB(1:450))
    axis([0 50 0 140])
    xlabel('unique words')
    ylabel('# of occurence')
    
    figure(2)
    subplot(2,3,1)
    hist(C(:,1))
    xlabel('Bathroom')
    ylabel('# of occurrence')
    subplot(2,3,2)
    hist(C(:,2))
    xlabel('Kitchen')
    subplot(2,3,3)
    hist(C(:,3))
    xlabel('Bedroom')
    subplot(2,3,4)
    hist(C(:,4))
    xlabel('Livingroom')
    ylabel('# of occurence')
    subplot(2,3,5)
    hist(C(:,5))
    xlabel('Hallway')
    subplot(2,3,6)
    hist(C(:,6),48)
    xlabel('time')
    axis([0 48 0 500])