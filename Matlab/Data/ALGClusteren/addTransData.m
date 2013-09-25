function House = addTransData(House)
% This function adds a field for every day. It takes the PreClustered data
% and adds the transitions for every time slice.
% TODO: This can be extended so that different sizes of dimensions can be
%       gained. (3*nd+1)
%       For now at the end and beginning of a day, the previous/next TS
%       will be zero values, this can be changed according to the
%       previous/next day (there needs to be a function to check if
%       consecutive days are really consecutive


N=size(House{1}.day{1}.PreClusteredData,1);
for HN=1:length(House)
    for i=1:length(House{HN}.day)
        dat=[];
        d=House{HN}.day{i}.PreClusteredData;
        
        % the first timeslice
        slize = [zeros(1,5),d(1,1:5),d(2,1:5),1];
        dat = [dat; slize];
        
        for ts=2:N-1
            slize = [d(ts-1,1:5),d(ts,1:5),d(ts+1,1:5),ts];
            dat = [dat ; slize];
        end
        
        % the last timeslice
        slize = [d(end-1,1:5),d(end,1:5),zeros(1,5),N];
        dat=[dat;  slize];
        
        % add to the struct
        House{HN}.day{i}.TransData = dat;
    end
end

end