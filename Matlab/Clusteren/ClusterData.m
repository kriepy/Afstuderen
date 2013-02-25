function ClusterData

houseNr=254;

path='C:\Users\Kristin\UVA\Afstuderen\Afstuderen\Matlab\ExtractData\DataMatlab'

load(strcat([path,'\House',num2str(houseNr),'.mat']));


[idx, c]=kmeans(House.DicData,100);

end