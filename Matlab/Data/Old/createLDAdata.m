function createLDAdata(houseNr)
% this function creates data that can be used with the old LDA
% implementation that I wrote by myself.

%houseNr=254

load(strcat(['DataMatlab/House',num2str(houseNr),'.mat']));

dic=House.DicWordsGrof;
V=House.V;

for i=1:length(House.day)
    Doc=[];
    for j=1:size(House.day(i).WordsGrof,1)
        row=House.day(i).WordsGrof(j,:);
        WordNR=find(ismember(dic,row,'rows'));
        wo=zeros(V,1);
        wo(WordNR)=1;
        wo=sparse(wo);
        Doc=[Doc wo];
    end
    House.documents(i).doc=Doc;
end

save(strcat(['DataMatlab/House',num2str(houseNr),'.mat']),'House');

end