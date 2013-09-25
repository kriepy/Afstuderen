function House=getplotDataAll( houseNr , pathReadings )
% this function creates the data for plotting. It uses the plain data as
% input and stores it in the same struct as all other files
%% TODO:
% it might be better to seperate the visualization data from the normal
% data. This will always stays the same and can be handy to look at the
% data while debugging LDA.



% constanten
dagIsec = 86400;
info = importdata(strcat('../SET1/DATAPlain/', num2str(houseNr),'/sensorinfo.txt'));
sensornames = importdata(strcat('../SET1/DATAPlain/',num2str(houseNr),'/sensornames.txt'));

% load data
data = importdata(strcat(pathReadings,'/',num2str(houseNr),'/sensorreadings.txt'));



% For all sensors
%name=strcat(['C:\Users\Kristin\UVA\Afstuderen\Afstuderen\Matlab\Data\DATAMain\PlotSensors.mat'])
%load(name);

%% Get the Sensor fields
% Sensors is a structure of length of the amount of sensors in one house.
% Every Sensor contains the number, name, field(bathroom, kitchen, bedroom,
% living, hallway) and type(reed,motion)

Sensors=getSensNew(info,sensornames);
House.Sensors=Sensors;


%% Here the time stamp is changed. TotVec contains the whole data now.
unix_time=data(:,1);
TotVec = [stamp2vec(unix_time) data(:,2:3)];

% every in is ???
in = 1;
dag=1


go = true;

% this is the matrix which contains a list of sensors that are open at the
% end of a day (so there hasn't ben a 0 after a 1 for a sensor)
% For now I do not use it, because it may cause some errors if a door is
% not closed for example
over=[];
last=[zeros(1,length(Sensors)) 2];

%% Iterate until you at the end of the data
while go
    dag1=TotVec(in,1:3);
    threeOClock=vec2stamp([dag1 [3,0,0]]); % this is the timestamp
    try
        time = unix_time(in);
    catch
        disp('first try, thats not good')
        go = false;
    end

    % this determs if the first sensor time is before or after 3 o'clock am
    if time >= threeOClock
        House.day{dag}.date=datestr(TotVec(in,1:6),1);
        threeOClock=threeOClock + dagIsec;

    else
        temp = stamp2vec(threeOClock-dagIsec);
        House.day{dag}.date=datestr(temp,1);
    end

    for j=1:length(Sensors)
        House.day{dag}.plo{j}=[];
    end
    
    
    lenData=length(Sensors); % 
    tempData=[]; %year-month-day-hour-min-sec-sensor-value
    
    % in this loop the data for one day is collected
    % one day is until 3 am
    while time < threeOClock
        tempData=[tempData;TotVec(in,:)];
        
        in=in+1;
        try
            time = unix_time(in);
        catch
            disp('2nd try in getplotData, There is no more data for this day')
            go = false;
            break
        end
    end
    
    [a,b]=size(tempData);
    temDa=zeros(a,3);
    first=vec2stamp(tempData(1,1:6));
    
    
    %loop over every entry
    for i=1:a
        temDa(1)=vec2stamp(tempData(i,1:6))-threeOClock+dagIsec;
        temDa(2:3)=tempData(i,7:8);

        for j=1:length(Sensors)
            if (temDa(2)==Sensors{j}.nr)
                if (temDa(3)==1)
                    House.day{dag}.plo{j}=[House.day{dag}.plo{j} [temDa(1) temDa(1); 0 1]];
                elseif (temDa(3)==0)
                    House.day{dag}.plo{j}=[House.day{dag}.plo{j} [temDa(1) temDa(1);1 0]];
                end
            end
        end
    end  
    
    dag=dag+1;
end






end

