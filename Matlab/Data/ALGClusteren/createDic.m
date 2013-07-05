function unWords=createDic(dat)

%houseNr=247

%load(strcat(['DataMatlab/House',num2str(houseNr),'.mat']));

Words=[];
for i=1:length(dat)
    Words=[Words; dat{i}.dat];
end
size(Words)
unWords=unique(Words,'rows');
size(unWords)

%House.DicSWords=unWords;

%save(strcat(['DataMatlab/House',num2str(houseNr),'.mat']),'House');

end