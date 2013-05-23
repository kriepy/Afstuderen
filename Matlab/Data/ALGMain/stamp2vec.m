function vec = stamp2vec(stamp)
% function to change between timestamp given in the plaine data to time
% vector

vec = datevec(stamp/86400 + datenum(1970,1,1));