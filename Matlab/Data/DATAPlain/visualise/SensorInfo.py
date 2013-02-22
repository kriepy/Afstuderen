from SensorData import SensorEvent, SensorData
from string import split
from time import strftime, gmtime, time
import sys

class SensorInfo:
    def __init__(self, namefile="sensornames.txt", infofile="sensorinfo.txt"):
        self.sensorID = []
        self.sensorIndex = {}        
        self.keywords = {}
        self.allKWsensors = []
        self.sensornames = {}
                
        try:
            f = open(infofile)
            for line in f:
                l = split(line)
                if len(l) < 2:
                    continue
                sensorID = int(l[0],0)
                self.getSensorIndex(sensorID) # to add it to the known sensors
                
                for w in l[1:]:
                    if w in self.keywords:
                        kid = self.keywords[w]                        
                    else:
                        kid = len(self.allKWsensors)
                        self.allKWsensors.append([])
                        self.keywords[w] = kid
                        
                    self.allKWsensors[kid].append(sensorID)
            f.close()
            # print self.keywords, self.allKWsensors
        except IOError as (errno, strerror):
            print "Could not open %s (%s)" % (infofile,strerror)
            pass                # silently ignore

        try:
            f = open(namefile)
            for line in f:
                l = split(line,maxsplit=1)
                if len(l) == 2:
                    id = int(eval(l[0]))
                    self.getSensorIndex(id) # Make sure the sensor is known...
                    self.sensornames[id] = l[1][:-1]
            f.close()
        except IOError as (errno, strerror):
            print >>sys.stderr, "Cannot open %s: %s (Sensor names unknown)" % (namefile, strerror)
        

    def getSensorIndex(self, id):
        if not id in self.sensorIndex:
            self.sensorIndex[id] = len(self.sensorID)
            self.sensorID.append(id)
        
        return self.sensorIndex[id]

    def getKWSensorIDs(self, kw):
        return self.allKWsensors[self.keywords[kw]]

    def getKWIDSensorIDs(self, kwid):
        return self.allKWsensors[kwid]
    
    def getSensorID(self, index):
        return self.sensorID[index]

    def getSensorIDs(self):
        return self.sensorID
        
    def getNumSensors(self):
        return len(self.sensorID)

    def getNumKW(self):
        return len(self.keywords)

    def getKWindex(self,k):
        return self.keywords[k]

    def getSensorName(self, sensorID):
        if sensorID in self.sensornames:
            return self.sensornames[sensorID]
        else:
            return hex(sensorID)
    
    def getKeywordList(self):
        return list(self.keywords)

        
