from string import split

class Invalid:
    def __init__(self, start, end, sensor):
        self.start = start
        self.end = end
        self.sensorID = sensor
        self.type = 0

    def overlaps(self,start,end):
        return (self.start <= start and self.end >= start) or \
            (self.start <= end and self.end >= end)

class InvalidSensors:
    def __init__(self, datafile):
        self.invalids = []
        try:
            f = open(datafile)
            for line in f:
                l = split(line)
                start = float(l[0])
                end = float(l[1])
                sensor = int(l[2],0)

                self.invalids.append(Invalid(start,end,sensor))
            f.close()
        except IOError as (errno, strerror):
            print "Cannot open {0}: {1} (Could not load annotation of invalid sensors)".format(datafile,strerror)

    def add(self, start,end,id):
        self.invalids.append(Invalid(start,end,id))
        self.invalids.sort(key = lambda a: a.start)
        
    def save(self,file):
        try:
            f = open(file, 'w')
            for a in self.invalids:
                f.write(str(a.start)+" "+str(a.end)+" "+str(a.sensorID)+"\n")
        except IOError as (errno, strerror):
            print "Could not save to {0} (I/O error {1}): {2}".format(file,errno, strerror)
        
    def isInvalid(self,sensor,start,end):
        for i in self.invalids:
            if i.sensorID == sensor and i.overlaps(start,end):
                return True
        return False
        
