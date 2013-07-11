clear all
close all
%initialize variables
path='../DATAMain/NEW/plotSensors.mat';
HN = 5; %this is HouseNr 251
dag = 50; %this is which day we choose
start = [7,0,0]; %defines the time from where to start to visualize
timeSpan = 60; %defines how long the window is to show the data (given in minutes) 
cmap=colormap(hsv(5));

%Load
House=load(path);
House=House.House{HN};
    
% The data for one day
DayData = House.day{dag}.plo;
siz=length(DayData); %the amount of sensors that needs to be plotted
beginStamp = vec2stamp([1970,1,1,start]);
endStamp = beginStamp + timeSpan*60;

SensNames=cell(length(House.Sensors),1);
for i=1:length(SensNames)
    SensNames{i,1}=[House.Sensors{i}.name, ' (' ,House.Sensors{i}.type,')'];
end
% for i=1:length(House.Sensors)
%     SensNames=[SensNames; strcat(House.Sensors{i}.name, House.Sensors{i}.type)];
% end
%Get data in your timespan
for i=1:siz
        clear a;
        a=DayData{i};
        if (~isempty(a))
            idx = find(a(1,:)>=beginStamp & a(1,:)<endStamp);
            clear b;
            
            b=a(:,idx);
            if (~isempty(b))
                plot(b(1,:),b(2,:)+2*i,'Color',cmap(House.Sensors{i}.fieldNr,:))
                hold on
            end
        end
        plot([beginStamp endStamp],[2*i 2*i],'Color',cmap(House.Sensors{i}.fieldNr,:))
        hold on
end
% This is for setting the y-as and is always the same
set(gca,'YLim',[1 34]);
set(gca,'YTick',2.5:2:32.5);
set(gca,'YTicklabel',SensNames);

% This is for setting the x-as and might be different for different sizes
% of timespans
set(gca,'XLim',[beginStamp endStamp]);
ticky=beginStamp:900:endStamp;
set(gca,'XTick',ticky);
tic=stamp2vec(ticky);
TickLab=[];
for i=1:length(ticky)
    TickLab=[TickLab ;sprintf('%02d:%02d', tic(i,4), tic(i,5))]
end
set(gca,'XTicklabel',TickLab);
% TimeTicks = [];
% TimeTicks = [TimeTicks ; sprintf('%02d:%02d:%02d', c(4), c(5), c(6))];
% set(gca,)