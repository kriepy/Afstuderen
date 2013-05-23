function getFlexData(houseNr,len)
% INPUT: is the length of the timeslices given in minutes and the houseNr
% This function descretizes the data in timeslices of length "len".
%% TODO:
% It might be necessary to give the starting point of a day as input
% value. So that you can play with different representation of the data.
% Descretizing the data may throw away important patterns if the cut
% between a timeslice is at a bad time.

if nargin < 2
    len=30; %dafualt length of the slices is 30 minutes
end

%% These are the different ways to count the data, 'simple' just counts
% the ones in the data. 'RM' maakt verschil tussen reed en motion sensors
% and counts them in a different way
way='simple'

%%
% Define the variables first
dagIsec = 86400;

%% Path to store the plain data
path='C:\Users\Kristin\UVA\Afstuderen\Afstuderen\Matlab\Data\DATACorpus\plainBewerkt';


%% Load the files
plainData = importdata(strcat('C:\Users\Kristin\UVA\Afstuderen\Afstuderen\Matlab\Data\DATAPlain\',num2str(houseNr),'\sensorreadings.txt'));
info = importdata(strcat('C:\Users\Kristin\UVA\Afstuderen\Afstuderen\Matlab\Data\DATAPlain\', num2str(houseNr),'\sensorinfo.txt'));
sensornames = importdata(strcat('C:\Users\Kristin\UVA\Afstuderen\Afstuderen\Matlab\Data\DATAPlain\',num2str(houseNr),'\sensornames.txt'));

try
    load(strcat([path,'\House',num2str(houseNr),'SL',num2str(len),way,'.mat']));
catch err
    fprintf(1,'the House file not yet exists\n')
end


%% Get the Sensor fields
% Sensor is a struct which contains the field names and the nr of sensors
% that belongs to this field
% oSens is a Matrix with the sensors on the first column and the fields on
% the second

[Sensor,oSens]=getSens(info);


%% Here the time stamp is changed. TotVec contains the whole data now.
unix_time=plainData(:,1);
TotVec = [stamp2vec(unix_time) plainData(:,2:3)];

% every dag is a day index
dag=1;
% the index for each sensor note in the original data
in = 1;


go = true;



%% this is the matrix which contains a list of sensors that are open at the
% end of a day (so there hasn't ben a 0 after a 1 for a sensor)
% For now I do not use it, because it may cause some errors if a door is
% not closed for example
over=[];
last=[zeros(1,length(Sensor)) 0];

%% Iterate until you at the end of the data
while go
    dag1=TotVec(in,1:3)
    threeOClock=vec2stamp([dag1 [3,0,0]]); % this is the timestamp
    try
        time = unix_time(in); %in is the index for each sensor trigger
        
    catch
        disp('first try, thats not good')
        go = false;
    end

    % this determs if the first sensor time is before or after 3 o'clock am
    if time >= threeOClock %after 3am
        House.day{dag}.date=datestr(TotVec(in,1:6),1);
        threeOClock=threeOClock + dagIsec;

    else %before 3am
        temp = stamp2vec(threeOClock-dagIsec);
        House.day{dag}.date=datestr(temp,1);
    end

    
    sliceLen=len*60; % the slice length in seconds
    lenDag=dagIsec/sliceLen+2; % the amount of slices per day
    lenData=length(Sensor)+1; % 
    data=zeros(lenDag,lenData);
    tempData=[];
    
    % in this loop the data for one day is collected
    % one day is until 3 am + 1*sliLen
    while time < threeOClock+sliceLen
        tempData=[tempData;TotVec(in,:)];
        
        in=in+1;
        try
            time = unix_time(in);
        catch
            disp('2nd try. I will stop now')
            go = false;
            break
        end
    end
    
    [a,b]=size(tempData);
    
    if a*b>0
        
        % dit vult alleen de eerste lijn van de discrete data
        if dag>1
            if datenum(House.day{dag-1}.date)==datenum(House.day{dag}.date)-1
                data(1,:)=[last(1:5) 0];
            else
                data(1,:)=[zeros(1,length(Sensor)) 0];
            end
        else
            data(1,:)=last;
        end
        
        % Here is the part where the data is gained
        [data,over,last]=fillData(tempData,data,Sensor,over,threeOClock,way);
        

        House.day{dag}.data=data;

    else
        disp('the matrix is empty for this day, there is no data')
    end
    
    dag=dag+1;
end


%% Store the struct

% Here the House Data is stored into a mat-file
save(strcat([path,'\House',num2str(houseNr),'SL',num2str(len),way,'.mat']),'House');