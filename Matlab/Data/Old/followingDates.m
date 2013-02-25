function isit = followingDates(timestamp1,timestamp2)
% This function returns true if the two timestamps are on consecutive
% days.
% the difference between to timestamps should be max 1
%INPUT:
% timestamp1/2:= a date and time given in vector form , the vector
% [2004,10,24,12,00,00] presents the date 24-oct-2004 12:00:00
t1=datenum(timestamp1);
t2=datenum(timestamp2);


dif=abs(t1-t2);

if dif<=1
    isit = true;
else
    isit = false;
end


end