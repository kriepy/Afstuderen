function unWords=createDic(House)

%houseNr=247

%load(strcat(['DataMatlab/House',num2str(houseNr),'.mat']));

Words=[];
for i=1:length(House.day)
    Words=[Words; House.day{i}.PreClusteredData];
end
fprintf(1,'The number of words is %d\n',size(Words,1))
unWords=unique(Words,'rows');
fprintf(1,'The number of unique words is %d\n',size(unWords,1))

%House.DicSWords=unWords;

%save(strcat(['DataMatlab/House',num2str(houseNr),'.mat']),'House');

end