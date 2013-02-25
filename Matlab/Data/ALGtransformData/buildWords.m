function buildWords(houseNr)
% this function build words of the preprocessed data
% the previous and next timeslices are used to create a 48 x 16 dimensional
% matrix. In every row there will be three times the values for each sensor
% field and one time value.

%% TODO:
% This function should be adjust to make the automatically not depending on
% the timeslices.
% There should be a value to check how many timeslices previous and after
% should take into account.
% Not yet clear if this function is really useful (depending on the 
%%
%houseNr=254;


load(strcat(['DataMatlab/House',num2str(houseNr),'.mat']));

for i=1:length(House.day)
    Mat=House.day(i).data;
    lenSli=size(Mat,1)-2;
    lenSens=size(Mat,2)-1;
    Words=zeros(lenSli,3*lenSens+1);
    for j=1:48
        t_0=Mat(j,1:lenSens);
        t_1=Mat(j+1,1:lenSens);
        t_2=Mat(j+2,1:lenSens);

        timeval=grofTime(Mat(j+1,6));
        Words(j,:)=[t_0 t_1 t_2 timeval];
    end
    
    
    House.day(i).WordsGrof=Words;
    
end
save(strcat(['DataMatlab/House',num2str(houseNr),'.mat']),'House');
end

function T=grofTime(t)

if t>2 && t<8
    T=1;
elseif t>7 && t<13
    T=2;
elseif t>12 && t< 18
    T=3;
elseif t>17 && t<21
    T=4;
elseif t>20 || t<3
    T=5;
else
    disp('something went wrong')
end
end