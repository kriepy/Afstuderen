%With this script the plot data is made and stored for all houses

h(1)=247;
h(2)=251;
h(3)=252;
h(4)=253;
h(5)=254;


for i=1:5
    hou=getplotData(h(i));
    House{i}=hou;
    House{i}.HouseNr=h(i);
end

path='../DATAMain';
save(strcat([path,'/plotFields.mat']),'House');