function [data,over,last]=fillData(Mat,data,sens,over,threeOclock,way)
% this function is used in getFlexData. The input herefor is a matrix which
% contains data for only one day. The height of the matrix Mat is variable,
% depending on the amounts of sensor triggers in the plain data.
% the width of the matrix is 8(datum(3),tijd(3),sensor,value)) or
% 3(timestamp,sensor,value)


DaISe=86400;

[a,b]=size(data);


sliLen=DaISe/(a-2); %in seconds
start=threeOclock-DaISe; %start of the day at 3 o'clock in seconds
Stamp=vec2stamp(Mat(:,1:6)); %timestamp of all data in one day
nu=Mat(1,:);
k=1; % initializes the datapoint of the plain sensors (same as in but then for a day)
for i=2:a %loop over every timeslice
    %% first all data for the time slice needs to be captured
    timeNowS=start+(i-1)*sliLen-1; %the start time of the timeslice
    timeNowV=stamp2vec(timeNowS);
    hour=timeNowV(4);
    if vec2stamp(nu(1:6))<=timeNowS
        temp=[];
        while vec2stamp(nu(1:6))<=timeNowS
            temp=[temp; nu];
            k=k+1;
            try
                nu=Mat(k,:);
            catch
                break
            end
        end
        
        %% then the timeslice is filled
        [data(i,1:end-1),~]=fillSlice(temp(:,7:8),sens,[],way); % discrete data is filled
        data(i,end)=i-1; % the time is added at the 6th dim
    else
        % if no sensor data is in the timeslice fill with zeros
        data(i,:)=[zeros(1,length(sens)) i-1];
    end
%     
%     if a==1
%         
%     end
%     
%     [p,q]=size(temp);
%     if p*q<1
%         data(i,:)=compares
%     end
%     
end


% this is the last data which will be used in the next day
last=data(a-1,:);

end