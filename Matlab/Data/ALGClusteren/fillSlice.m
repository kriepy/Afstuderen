function [dat,over]=fillSlice(Mat,Sens,over,method)
% this function is used in the function fillData and here for every
% timeslice you receive a matrix which contains all raw sensor values in
% one timeinterval (e.g. half an hour)
% The output is a vector of of length 5 for every field one value.
% CHANGE: there needs to come an option for different kind of sensor
% filling, therefor the sens data also needs to be adjusted. 
if nargin < 3
    method='simple';
end
dat=zeros(1,5);
switch method
    case 'simple'
        % here there is no difference between reed and motion
        over=[];
        for k=1:length(Sens)
            % First voor de Reed Sensor
            Sors=Sens{k}.nr;
            triggers=0;
            ind=find(Mat(:,1)==Sors);
            triggers=triggers+sum(Mat(ind,2));
            FN=Sens{k}.fieldNr;
            dat(FN)=dat(FN)+triggers;
        end

        
        
%%        
    case 'RM'
        % now we distinguish between Reed and motion sensors
        over=[];
        dat=[];
        for k=1:length(Sens)
            % First voor de Reed Sensor
            Sors=Sens(k).sensR;
            triggers=0;
            for p=1:length(Sors);
                ind=find(Mat(:,1)==Sors(p));
                triggers=triggers+length(Mat(ind,2));
            end
            
            % Second for the motion sensors
            Sors=Sens(k).sensM;
            for p=1:length(Sors);
                ind=find(Mat(:,1)==Sors(p));
                triggers=triggers+sum(Mat(ind,2));
            end
            
            dat=[dat triggers];
        end
end