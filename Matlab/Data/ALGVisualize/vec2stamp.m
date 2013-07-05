function stamp = vec2stamp(vec)
% function to change from timevector into timestamp in the same format
% given in the plaine data.

stamp = 86400*(datenum(vec)-datenum(1970,1,1));
