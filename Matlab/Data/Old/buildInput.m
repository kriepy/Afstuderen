function buildInput

houseNr=247

load(strcat(['DataMatlab/House',num2str(houseNr),'.mat']));

for i=1:length(House.day)
    Mat=House.day(i).sWords;
end

end