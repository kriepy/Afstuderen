function [Sensors,oSens]=getSens(info)

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
                B=[B; str2num(vec{1})];
            case 'kitchen'
                K=[K; str2num(vec{1})];
            case 'bedroom'
                S=[S; str2num(vec{1})];
            case 'living'
                L=[L; str2num(vec{1})];
            case {'hall', 'front'}
                D=[D; str2num(vec{1})];
            otherwise
        end
            
    end
end

% field -> sensorNr
Sensors(1).name='Bathroom'
Sensors(2).name='Kitchen'
Sensors(3).name='Bedroom'
Sensors(4).name='Living'
Sensors(5).name='Hall'


Sensors(1).sens=B; %bathroom 
Sensors(2).sens=K; %kitchen
Sensors(3).sens=S; %bedroom (sleeping)
Sensors(4).sens=L; %living room
Sensors(5).sens=D; %hallway and front door

%% for the other way arround so sensorNr -> field
oSens=[];
for i=1:5
    len=length(Sensors(i).sens);
    oSens=[oSens; [Sensors(i).sens i*ones(len,1)]];
end
oSens
[~,ind]=sort(oSens(:,1));
oSens=oSens(ind,:)

end
