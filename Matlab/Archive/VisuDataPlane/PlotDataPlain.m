function PlotDataPlain( houseNr , dayNr)
% this function plots the day with 5 fields of the given House NR.
% houseNr:=     the number of the house (247,251,252,253,254)
% dayNr:=       the day you want to plot

if nargin<1
    houseNr=254;
    dayNr=5;
end

dagL=86400 % amount of second on a day

load(strcat(['C:\Users\Kristin\UVA\Afstuderen\Afstuderen\Matlab\ExtractData\DataMatlab\House',num2str(houseNr),'.mat' ]))

plo=House.day(dayNr).plo;
for i=1:5
    X=plo{i}(1,:);
    Y=plo{i}(2,:);
    subplot(5,1,i); area(X,Y); axis ([0 dagL 0 1.2]);
    if i==1
        ylabel bathroom
        title(strcat(['HouseNr: ', num2str(houseNr), ' day: ', num2str(dayNr)]))
    elseif i==2
        ylabel kitchen
    elseif i==3
        ylabel bedroom
    elseif i==4
        ylabel living
    else
        ylabel hallway
    end
end
    

end
