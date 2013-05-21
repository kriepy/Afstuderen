

HN=254;
SL=30;

getFlexData(HN,SL);
disp('data is ingedeeld in dagen')
buildWords(HN);
disp('words are created')
createDic(HN);
disp('dictionary is created')
createLDAdata(HN);
disp('LDAdata is created')
createFile(HN);
