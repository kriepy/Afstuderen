function [Sensors,oSens]=getSensRM(info)
% this function gives a struct and a matrix with sensor matching to sensor
% fields. There are always 5 fields.

%% the location vectors will contain the sensor numbers that are located in this room
BM = []; %bathroom 
KM = []; %kitchen
SM = []; %bedroom (sleeping)
LM = []; %living room
DM = []; %hallway and front door

BR = []; %bathroom 
KR = []; %kitchen
SR = []; %bedroom (sleeping)
LR = []; %living room
DR = []; %hallway and front door

for i=1:length(info)
    vec=regexp(info(i),'\s','split');
    vec=vec{1};
    for j=1:length(vec)
        strng = vec{j};
        switch strng
            case 'bathroom'
                indR=find(ismember(vec,'reed'));
                indM=find(ismember(vec,'motion'));
                
                if ~isempty(indR)
                    BR=[BR; str2num(vec{1})];
                end
                if ~isempty(indM)
                    BM=[BM; str2num(vec{1})];
                end
            case 'kitchen'
                indR=find(ismember(vec,'reed'));
                indM=find(ismember(vec,'motion'));
                
                if ~isempty(indR)
                    KR=[KR; str2num(vec{1})];
                end
                if ~isempty(indM)
                    KM=[KM; str2num(vec{1})];
                end
            case 'bedroom' %S komt van sleep
                indR=find(ismember(vec,'reed'));
                indM=find(ismember(vec,'motion'));
                
                if ~isempty(indR)
                    SR=[SR; str2num(vec{1})];
                end
                if ~isempty(indM)
                    SM=[SM; str2num(vec{1})];
                end                
            case 'living'
                indR=find(ismember(vec,'reed'));
                indM=find(ismember(vec,'motion'));
                
                if ~isempty(indR)
                    LR=[LR; str2num(vec{1})];
                end
                if ~isempty(indM)
                    LM=[LM; str2num(vec{1})];
                end                
            case {'hall', 'front'}
                indR=find(ismember(vec,'reed'));
                indM=find(ismember(vec,'motion'));
                
                if ~isempty(indR)
                    DR=[DR; str2num(vec{1})];
                end
                if ~isempty(indM)
                    DM=[DM; str2num(vec{1})];
                end                
            otherwise
        end
            
    end
end

% field -> sensorNr
Sensors(1).name='Bathroom';
Sensors(2).name='Kitchen';
Sensors(3).name='Bedroom';
Sensors(4).name='Living';
Sensors(5).name='Hall';


Sensors(1).sensR=BR; %bathroom 
Sensors(2).sensR=KR; %kitchen
Sensors(3).sensR=SR; %bedroom (sleeping)
Sensors(4).sensR=LR; %living room
Sensors(5).sensR=DR; %hallway and front door

Sensors(1).sensM=BM; %bathroom 
Sensors(2).sensM=KM; %kitchen
Sensors(3).sensM=SM; %bedroom (sleeping)
Sensors(4).sensM=LM; %living room
Sensors(5).sensM=DM; %hallway and front door

%% for the other way arround so sensorNr -> field
oSens=0;
% oSens=[];
% for i=1:5
%     len=length(Sensors(i).sens);
%     oSens=[oSens; [Sensors(i).sens i*ones(len,1)]];
% end
% [~,ind]=sort(oSens(:,1));
% oSens=oSens(ind,:);

end
