%With this script the days are seperated and stored for all houses. 

h(1)=247;
h(2)=251;
h(3)=252;
h(4)=253;
h(5)=254;


for i=1:5
    hou=getDays(h(i));
    House{i}=hou;
    House{i}.HouseNr=h(i);
end

path='C:\Users\Kristin\UVA\Afstuderen\Afstuderen\Matlab\Data\DATAMain';
save(strcat([path,'\sepDays.mat']),'House');
