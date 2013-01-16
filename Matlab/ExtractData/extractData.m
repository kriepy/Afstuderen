function extractData
%% This Function will extract the data in time slice of half an hour


%%
% Define the variables first
housenr = 253


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


% To half hour seperation the data is looked at.
% Here the time stamp is changed. TotVec contains the whole data now.
unix_time=data(:,1);
TotVec = [datevec(unix_time/86400 + datenum(1970,1,1)) data(:,2:3)];

Mat=zeros(48,6);
over=zeros(1,5);

monthes=unique(TotVec(:,2));
for i = 1:length(monthes)
    fprintf('The month is %d .\n',monthes(i));
    ind1=find(date(:,2)==monthes(i),1,'first');
    ind2=find(date(:,2)==monthes(i),1,'last');
    mon=TotVec(ind1:ind2,:);

    days=unique(mon(:,3));
    for j = 1:length(days)
        fprintf('The day is %d .\n',days(j));
        in1=find(mon(:,3)==days(i),1,'first');
        in2=find(mon(:,3)==days(i),1,'last');
        day=mon(in1:in2,:);
        
        % This is creating a variable
        a=strcat(num2str(day(1,1:3)));
        b=genvarname(a);
        
        %eval([b ' = struct([])']) %anders
        
        hours=unique(day(:,4));
        for k=1:length(hours)
            i1=find(day(:,4)==hours(k),1,'first');
            i2=find(day(:,4)==hours(k),1,'last');
            Hour=day(i1:i2,:)
            hoda=dayda(i1:i2,:)
            ix=find(Hour(:,5)<30,1,'last');
            
            % this is for the first half hour
            [v,~]=size(ix)
            if v~=0
                for w=1:5
                    Mat(Hour(1,4)*2-1,i)=Mat(Hour(1,4)*2-1,i)+over(i);
                end            

                [BB,KK,SS,LL,DD,over]=compares(B,K,S,L,D,hoda(1:ix,:));
                Mat(Hour(1,4)*2-1,1)=Mat(Hour(1,4)*2-1,1)+BB;
                Mat(Hour(1,4)*2-1,2)=Mat(Hour(1,4)*2-1,2)+KK;
                Mat(Hour(1,4)*2-1,3)=Mat(Hour(1,4)*2-1,3)+SS;
                Mat(Hour(1,4)*2-1,4)=Mat(Hour(1,4)*2-1,4)+LL;
                Mat(Hour(1,4)*2-1,5)=Mat(Hour(1,4)*2-1,5)+DD;
            end
            
            % this is for the 2nd half hour
            for w=1:5
                Mat(Hour(1,4)*2,i)=Mat(Hour(1,4)*2,i)+over(i);
            end
            
            if v==0
                matse=hoda;
            else
                matse=hoda(ix+1:end,:);
            end
            
            [BB,KK,SS,LL,DD,over]=compares(B,K,S,L,D,matse);
            Mat(Hour(1,4)*2,1)=Mat(Hour(1,4)*2,1)+BB;
            Mat(Hour(1,4)*2,2)=Mat(Hour(1,4)*2,2)+KK;
            Mat(Hour(1,4)*2,3)=Mat(Hour(1,4)*2,3)+SS;
            Mat(Hour(1,4)*2,4)=Mat(Hour(1,4)*2,4)+LL;
            Mat(Hour(1,4)*2,5)=Mat(Hour(1,4)*2,5)+DD;
        end
        
        % Here the data is stored for each day:
        
        
    end
end




end


















