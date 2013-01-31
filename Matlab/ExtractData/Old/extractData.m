function extractData
%% This Function will extract the data in time slice of half an hour
% the data will be stored in a struct HouseNR which is an array.
% Every entery of the struct has the following fields:
% date:= gives the date of entery
% data:= gives the plain data in a matrix of size 48 x 6


%%
% Define the variables first
housenr = 247


% Load the files
data = importdata(strcat('C:\Users\Kristin\UVA\Afstuderen\data\',num2str(housenr),'\sensorreadings.txt'));
info = importdata(strcat('C:\Users\Kristin\UVA\Afstuderen\data\', num2str(housenr),'\sensorinfo.txt'))
sensornames = importdata(strcat('C:\Users\Kristin\UVA\Afstuderen\data\',num2str(housenr),'\sensornames.txt'));

%% the location vectors will contain the sensor numbers that are located in this room
B=[]; %bathroom 
K=[]; %kitchen
S=[]; %bedroom (sleeping)
L=[]; %living room
D=[]; %hallway and front door

for i=1:length(info)
    vec=regexp(info(i),'\s','split');
    vec=vec{1};
    for j=1:length(vec)
        strng = vec{j};
        switch strng
            case 'bathroom'
                B=[B str2num(vec{1})];
            case 'kitchen'
                K=[K str2num(vec{1})];
            case 'bedroom'
                S=[S str2num(vec{1})];
            case 'living'
                L=[L str2num(vec{1})];
            case {'hall', 'front'}
                D=[D str2num(vec{1})];
            otherwise
        end
            
    end
end

Sensors.B=B; %bathroom 
Sensors.K=K; %kitchen
Sensors.S=S; %bedroom (sleeping)
Sensors.L=L; %living room
Sensors.D=D; %hallway and front door


% To half hour seperation the data is looked at.
% Here the time stamp is changed. TotVec contains the whole data now.
unix_time=data(:,1);
TotVec = [datevec(unix_time/86400 + datenum(1970,1,1)) data(:,2:3)];

Mat=zeros(48,6);
over=zeros(1,5);
hours=[1:24]-1;
num=0;

monthes=unique(TotVec(:,2));
for i = 1:length(monthes)
    %fprintf('The month is %d .\n',monthes(i));
    ind1=find(TotVec(:,2)==monthes(i),1,'first');
    ind2=find(TotVec(:,2)==monthes(i),1,'last');
    mon=TotVec(ind1:ind2,:);

    days=unique(mon(:,3));
    for j = 1:length(days)
        num=num+1;
        %fprintf('The day is %d .\n',days(j));
        in1=find(mon(:,3)==days(j),1,'first');
        in2=find(mon(:,3)==days(j),1,'last');
        day=mon(in1:in2,:);
        
        % This is creating a variable
        dayName=strcat(datestr(day(1,1:6),29));
        
        
        for k=1:length(hours)
            %fprintf('The hour is %d .\n',hours(k));
            i1=find(day(:,4)==hours(k),1,'first');
            i2=find(day(:,4)==hours(k),1,'last');
            Hour=day(i1:i2,:);
            
            
            amtSens=size(Hour,1); % the length of the sensordata for 1 hr
            ix1=find(Hour(:,5)<30,1,'first');
            ix2=find(Hour(:,5)<30,1,'last');
            iy1=find(Hour(:,5)>=30,1,'first');
            iy2=find(Hour(:,5)>=30,1,'last');
           
            [v,~]=size(ix1);
            [w,~]=size(iy1);
            if v>0 && w>0
                hourCase='both';
                
                [BB,KK,SS,LL,DD,newover]=compares(Sensors,Hour(ix1:ix2,:));
                Mat=toevoegen(BB,KK,SS,LL,DD,Mat,hours(k),1,over);
                over=newover;
                [BB,KK,SS,LL,DD,newover]=compares(Sensors,Hour(iy1:iy2,:));
                Mat=toevoegen(BB,KK,SS,LL,DD,Mat,hours(k),2,over);
                over=newover;
            elseif v>0 && w==0
                hourCase='first';
                [BB,KK,SS,LL,DD,newover]=compares(Sensors,Hour(ix1:ix2,:));
                Mat=toevoegen(BB,KK,SS,LL,DD,Mat,hours(k),1,over);
                over=newover;
                Mat=toevoegen(0,0,0,0,0,Mat,hours(k),2,over);
            elseif v==0 && w>0
                hourCase='second';
                [BB,KK,SS,LL,DD,newover]=compares(Sensors,Hour(iy1:iy2,:));
                Mat=toevoegen(0,0,0,0,0,Mat,hours(k),1,over);
                Mat=toevoegen(BB,KK,SS,LL,DD,Mat,hours(k),2,over);               
                over=newover;
            else
                hourCase='none';
                Mat=toevoegen(0,0,0,0,0,Mat,hours(k),1,over);
                Mat=toevoegen(0,0,0,0,0,Mat,hours(k),2,over);
            end
        end
        
        % Here the data for every day is added to the struct
        House.day(num).date=dayName;
        House.day(num).data=Mat;
        
        
    end
    
end

% This is creating the words data
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
    
    % Here the words are added to the struct
    House.day(i).Words=Words;
end

% Here the House Data is stored into a mat-file
save(strcat(['DataMatlab/House',num2str(housenr),'.mat']),'House');


end

function Mat=toevoegen(BB,KK,SS,LL,DD,Mat,hour,half,over)
hour=hour+1;
    if half==1
        Mat(hour*2-1,1)=BB+over(1);
        Mat(hour*2-1,2)=KK+over(2);
        Mat(hour*2-1,3)=SS+over(3);
        Mat(hour*2-1,4)=LL+over(4);
        Mat(hour*2-1,5)=DD+over(5);
        Mat(hour*2-1,6)=hour-1;
    end
    if half==2
        Mat(hour*2,1)=BB+over(1);
        Mat(hour*2,2)=KK+over(2);
        Mat(hour*2,3)=SS+over(3);
        Mat(hour*2,4)=LL+over(4);
        Mat(hour*2,5)=DD+over(5);
        Mat(hour*2,6)=hour-1;
    end
end













