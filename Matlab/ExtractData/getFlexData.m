function getFlexData(len)
% INPUT: is the length of the timeslices given in minutes

if nargin < 1
    len=30; %dafualt length of the 
end

%%
% Define the variables first
housenr = 247
dagIsec = 86400;


%% Load the files
data = importdata(strcat('C:\Users\Kristin\UVA\Afstuderen\data\',num2str(housenr),'\sensorreadings.txt'));
info = importdata(strcat('C:\Users\Kristin\UVA\Afstuderen\data\', num2str(housenr),'\sensorinfo.txt'))
sensornames = importdata(strcat('C:\Users\Kristin\UVA\Afstuderen\data\',num2str(housenr),'\sensornames.txt'));

%% Get the Sensor fields
% Sensor is a struct which contains the field names and the nr of sensors
% that belongs to this field
% oSens is a Matrix with the sensors on the first column and the fields on
% the second

[Sensor,oSens]=getSens(info);


%% Here the time stamp is changed. TotVec contains the whole data now.
unix_time=data(:,1);
TotVec = [stamp2vec(unix_time) data(:,2:3)];
in = 1;
go = true;

%% Iterate until you at the end of the data
while go
    dag1=TotVec(in,1:3)
    threeOClock=vec2stamp([dag1 [3,0,0]]); % this is the timestamp
    try
        time = unix_time(in);
    catch
        go = false;
    end

    % this determs if the first sensor time is before or after 3 o'clock am
    if time >= threeOClock
        House.day(in).date=datestr(TotVec(1,1:6),1);
        threeOClock=threeOClock + dagIsec;

    else
        temp = stamp2vec(threeOClock-dagIsec);
        House.day(in).date=datestr(temp,1);
    end

    % the slice length in seconds
    sliceLen=len*60;
    lenDag=dagIsec/sliceLen+2;
    lenData=length(Sensor)+1;
    data=zeros(lenDag,lenData);
    tempData=[];
    
    while time < threeOClock+sliceLen
        tempData=[tempData;TotVec(in,:)];
        
        
        
        in=in+1;
        try
            time = unix_time(in);
        catch
            go = false;
            break
        end
    end
    
    [a,b]=size(tempData);
    
    if a*b>0
        
        
    end
    
    
end


%% Store the struct

% Here the House Data is stored into a mat-file
save(strcat(['DataMatlab/House',num2str(housenr),'.mat']),'House');