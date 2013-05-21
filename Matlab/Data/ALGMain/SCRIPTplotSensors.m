%With this script the plot data is made and stored for all houses. Here all
%sensor data is seperated so that every sensor can be plotted apart.

h(1)=247;
h(2)=251;
h(3)=252;
h(4)=253;
h(5)=254;


for i=1:5
    hou=getplotDataAll(h(i));
    House{i}=hou;
    House{i}.HouseNr=h(i);
end

path='C:\Users\Kristin\UVA\Afstuderen\Afstuderen\Matlab\Data\DATAMain';
save(strcat([path,'\plotSensors.mat']),'House');
