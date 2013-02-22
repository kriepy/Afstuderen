function createDic

houseNr=247

load(strcat(['DataMatlab/House',num2str(houseNr),'.mat']));

Words=[];
for i=1:length(House.day)
Words=[Words; House.day(i).sWords];
size(Words)
end
unWords=unique(Words,'rows');
size(unWords)

House.DicSWords=unWords;

save(strcat(['DataMatlab/House',num2str(houseNr),'.mat']),'House');

end