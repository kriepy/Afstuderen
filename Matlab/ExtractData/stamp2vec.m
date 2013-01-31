function vec = stamp2vec(stamp)

vec = datevec(stamp/86400 + datenum(1970,1,1));