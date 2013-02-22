function buildWords
% this function build words of the plain data
% the previous and next timeslices are used to create a 48 x 16 dimensional
% matrix. In every row there will be three times the values for each sensor
% field and one time value.

houseNr=247;

load(strcat([num2str(houseNr),'Data/House.mat']));


for i=1:length(House.day)
    Mat=House.day(i).data;
    Words=zeros(48,16);
    for j=1:48
        if j==1
            t_0=[0 0 0 0 0];
        else
            t_0=Mat(j,1:5);
        end
        if j==48
            t_2=[0 0 0 0 0];
        else
            t_2=Mat(j+1,1:5);
        end
        t_1=Mat(j,1:5);
        timeval=grofTime(Mat(j,6));
        Words(j,:)=[t_0 t_1 t_2 timeval];
    end
    
    
    House.day(i).Words=Words;
    
end
save(strcat(['DataMatlab/House',num2str(houseNr),'.mat']),'House');
end

function T=grofTime(t)

if t<8
    T=1;
elseif t>7 && t<13
    T=2;
elseif t>12 && t< 18
    T=3;
elseif t>17 && t<21
    T=4;
elseif t>20
    T=5;
else
    disp('something went wrong')
end
end