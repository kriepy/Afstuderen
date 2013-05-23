function d=transExtData(HouseNr,len)
% this function creates direct the input voor ldaExtension. It still can be
% used from the basic lda algorithm.
% d is a struct of size as amount of days contained for a House.
% d{i}.mat is a matrix which contains the words. The size will be
% (3600/len x 5)
% d{i}.id and d{i}.cnt are the index of and the count of the words.


 if nargin<1
    HouseNr=254;
    len=30;
 end

path='C:\Users\Kristin\UVA\Afstuderen\Afstuderen\Matlab\Data\Old\DATACorpus\';

load(strcat([path,'House',num2str(HouseNr),'SL',num2str(len)]));

for i=1:length(House.day)
    d{i}.mat=House.day(i).data(2:end-1,:);
    d{i}.date=House.day(i).date;
end

