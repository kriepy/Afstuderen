function createDic(houseNr)
% this function creates a dictionary and stores it to the global struct
% it looks for unique words and stores them in the same struct.
% can be adjust to make different dics. For plain data of words.

%% houseNr=254

load(strcat(['DataMatlab/House',num2str(houseNr),'.mat']));

Words=[];
for i=1:length(House.day)
Words=[Words; House.day(i).data];
size(Words);
end
unWords=unique(Words,'rows');
size(unWords);

House.DicData=unWords;

save(strcat(['DataMatlab/House',num2str(houseNr),'.mat']),'House');

end