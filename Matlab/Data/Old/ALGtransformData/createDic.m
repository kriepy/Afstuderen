function createDic
% this function creates a dictionary and stores it to the global struct
% it looks for unique words and stores them in the same struct.
% can be adjust to make different dics. For plain data of words.

houseNr=254
len=30;
% possible options for the case cs are: Data6, Data16, Grof6, Grof16
cs= 'Data6'
% possible way are '1cnt' or 'RM'. Depending a different House Struct is
% loaded
way='RM';



load(strcat(['C:\Users\Kristin\UVA\Afstuderen\Afstuderen\Matlab\Data\DATACorpus\plainBewerkt\House',num2str(houseNr),'SL',num2str(len),way,'.mat']));

path='C:\Users\Kristin\UVA\Afstuderen\Afstuderen\Matlab\Data\DATACorpus\forLDAbasic';


try
    load(strcat([path,'\House',num2str(houseNr),'SL',num2str(len),way,'.mat']));
catch err
    fprintf(1,'the House file not yet exists\n')
end

switch(cs)
    case 'Data6'

    Words=[];
    for i=1:length(House.day)
        if strcmp(way,'1cnt')
            Words=[Words; House.day{i}.data1cnt];
        end
        if strcmp(way,'RM')
            Words=[Words; House.day{i}.data1cnt];
        end
        size(Words);
    end
    unWords=unique(Words,'rows');
    size(unWords);

    House.DicData6=unWords;

    save((strcat([path,'\House',num2str(houseNr),'SL',num2str(len),way,'.mat'])),'House');
    fprintf(1,'I saved it')

    case 'Data16'
        
    case 'Grof6'
        
    case 'Grof16'
        
    otherwise
        frpintf(1,'I dont know this case. Please choose something else')
end

end