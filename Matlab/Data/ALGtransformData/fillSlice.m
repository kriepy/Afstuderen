function [dat,over]=fillSlice(Mat,Sens,over)
% this function is used in the function fillData and here for every
% timeslice you receive a matrix which contains all raw sensor values in
% one timeinterval (e.g. half an hour)
if nargin==3
    method='over';
else
    method='simple';
end

switch method
    case 'simple'
        over=[];
        dat=[];
        for k=1:length(Sens)
            Sors=Sens(k).sens;
            triggers=0;
            for p=1:length(Sors);
                ind=find(Mat(:,1)==Sors(p));
                triggers=triggers+sum(Mat(ind,2));
            end
            dat=[dat triggers];
        end

        
        
%%        
    case 'over'
        disp('not yet implemented')
end