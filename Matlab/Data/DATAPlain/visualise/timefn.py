from time import gmtime

hour=1./24
minute=hour/60.
second=minute/60.


def unix2time(t):
    return t/24./3600.+719529

def time2gmt(t):
    return gmtime((t-719529)*24*3600)

def time2unix(t):
    return (t-719529)*24*3600

def unix2time(t):
    return t/24./3600.+719529


def strTimeOfDay(t):
    t -= int(t)
    t *= 24*3600
    return "%02d:%02d:%02d" % (int(t/3600), (int(t)%3600)/60, int(t)%60 )
    
