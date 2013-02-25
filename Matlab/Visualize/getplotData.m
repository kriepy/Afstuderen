function getplotData( houseNr, day )
% this function can be used to plot the data. It uses the plain data as
% input and stores it in the same struct as all other files
%% TODO:
% it might be better to seperate the visualization data from the normal
% data. This will always stays the same and can be handy to look at the
% data while debugging LDA.


if nargin<1
    houseNr=254;
    day=1;
end

% constanten
dagIsec = 86400;

data = importdata(strcat('C:\Users\Kristin\UVA\Afstuderen\data\',num2str(houseNr),'\sensorreadings.txt'));
info = importdata(strcat('C:\Users\Kristin\UVA\Afstuderen\data\', num2str(houseNr),'\sensorinfo.txt'));
sensornames = importdata(strcat('C:\Users\Kristin\UVA\Afstuderen\data\',num2str(houseNr),'\sensornames.txt'));


load(strcat(['DataMatlab/House',num2str(houseNr),'.mat']));

%% Get the Sensor fields
% Sensor is a struct which contains the field names and the nr of sensors
% that belongs to this field
% oSens is a Matrix with the sensors on the first column and the fields on
% the second

[Sensor,oSens]=getSens(info);


%% Here the time stamp is changed. TotVec contains the whole data now.
unix_time=data(:,1);
TotVec = [stamp2vec(unix_time) data(:,2:3)];

% every in is a day
in = 1;
dag=1;


go = true;

% this is the matrix which contains a list of sensors that are open at the
% end of a day (so there hasn't ben a 0 after a 1 for a sensor)
% For now I do not use it, because it may cause some errors if a door is
% not closed for example
over=[];
last=[zeros(1,length(Sensor)) 2];

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
        %House.day(dag).date=datestr(TotVec(in,1:6),1);
        threeOClock=threeOClock + dagIsec;

    else
        temp = stamp2vec(threeOClock-dagIsec);
        %House.day(dag).date=datestr(temp,1);
    end

    
    lenData=length(Sensor)+1; % 
    tempData=[];
    
    % in this loop the data for one day is collected
    % one day is until 3 am + 1*sliLen
    while time < threeOClock
        tempData=[tempData;TotVec(in,:)];
        
        in=in+1;
        try
            time = unix_time(in);
        catch
            disp('2nd try')
            go = false;
            break
        end
    end
    
    [a,b]=size(tempData);
    temDa=zeros(a,3);
    first=vec2stamp(tempData(1,1:6));
    
    % reduces the sensor data to the 5 fields
    for i=1:a
        index=find(oSens(:,1)==tempData(i,7));
        temDa(i,1)=vec2stamp(tempData(i,1:6))-threeOClock+dagIsec;
        temDa(i,2)=oSens(index,2);
        temDa(i,3)=tempData(i,8);
    end
    
    % get the data for every field
    for i=1:5
        index=find(temDa(:,2)==i);
        Mat{i}=temDa(index,:);
        plo=[0;0];
        for j=1:size(Mat{i},1)
            if Mat{i}(j,3)==1
                plo=[plo [Mat{i}(j,1) Mat{i}(j,1);0 1]];
            elseif Mat{i}(j,3)==0
                plo=[plo [Mat{i}(j,1) Mat{i}(j,1);1 0]];
            end
        end
        House.day(dag).plo{i}=plo;
    end
    
    % get the data that is needed to be plotted
    
    
    dag=dag+1;
end

save(strcat(['DataMatlab/House',num2str(houseNr),'.mat']),'House');






end

