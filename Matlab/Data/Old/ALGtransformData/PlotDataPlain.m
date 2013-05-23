function PlotDataPlain( houseNr , dayNr)
% this function plots the day with 5 fields of the given House NR.
% It uses the data stored in plainBewerkt
% houseNr:=     the number of the house (247,251,252,253,254)
% dayNr:=       the day you want to plot

if nargin<1
    houseNr=254;
    dayNr=8;
end

dagL=86400 % amount of second on a day

load(strcat(['C:\Users\Kristin\UVA\Afstuderen\Afstuderen\Matlab\Data\DATACorpus\plainBewrkt\House',num2str(houseNr),'SliLen30.mat' ]))

plo=House.day{dayNr}.plo;
for i=1:5    
    X=plo{i}(1,:)/3600;
    Y=plo{i}(2,:);
    
%     ind=find(X>14);
%     X=X(ind);
%     Y=Y(ind);
    
    subplot(5,1,i); area(X,Y); axis ([0 dagL/3600 0 1.2]);
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
