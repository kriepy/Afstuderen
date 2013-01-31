function stamp = vec2stamp(vec)

stamp = 86400*(datenum(vec)-datenum(1970,1,1));
