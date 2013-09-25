import sys
from string import split
from tictoc import tic, toc
from timefn import *

class UnsortedEvent:
    def __init__(self, timestamp, sensor, val):
        self.ts = timestamp
        self.sid = sensor
        self.val = val

    def __eq__(self,other):
        return self.ts==other.ts
    def __ne__(self,other):
        return self.ts!=other.ts
    def __lt__(self,other):
        return self.ts<other.ts
    def __gt__(self,other):
        return self.ts>other.ts
    def __le__(self,other):
        return self.ts<=other.ts
    def __ge__(self,other):
        return self.ts>=other.ts    

class SensorEvent:
    nextEventID=0
    def __init__(self, timestamp, val):
        self.id = SensorEvent.nextEventID
        SensorEvent.nextEventID+=1
        self.ts = timestamp
        self.val = val

    def __eq__(self,other):
        return self.id==other.id
    def __ne__(self,other):
        return self.id!=other.id
    def __lt__(self,other):
        return self.id<other.id
    def __gt__(self,other):
        return self.id>other.id
    def __le__(self,other):
        return self.id<=other.id
    def __ge__(self,other):
        return self.id>=other.id
    
    def __repr__(self):
        return "(%d %s)" % (self.id,strTimeOfDay(self.ts))

    def __hash__(self):
        return self.id

class SensorData:
    def __init__(self, info, datafile, isHeart=False):
        self.startTime = 1e100                      # Time of the first event
        self.endTime = 0                            # Time of the last event
        self.sensorEvents = []                      # List of lists of events, per sensor
        self.perSensorCount = {}
        self.sensorinfo = info
        self.isHeart = isHeart

        eventList = []
        try:
            f = open(datafile)
            
            for line in f:
                l = split(line)
                if len(l) == 4:
                    start = float(l[0])
                    end = float(l[1])
                    id = int(l[2])
                    # print line, ": ", start, ",", end, ",", id;

                    eventList.append(UnsortedEvent(start,id,1))
                    eventList.append(UnsortedEvent(end,id,0))
                    self.incSensorCnt(id,2)
                elif len(l) == 3:   # keyzer format
                    t = unix2time(float(l[0]))
                    id = int(float(l[1]))
                    eventList.append(UnsortedEvent(t,id,int(l[2])))
                    self.incSensorCnt(id)
                else:
                    print "Can't parse",line
            f.close()
        except IOError as (errno, strerror):
            print >>sys.stderr, "Cannot open %s: %s (no sensor data)" % (datafile, strerror)

        # ensure that we know of the sensors with no data but with info:
        for i in info.getSensorIDs():
            if not i in self.perSensorCount:
                self.perSensorCount[i] = 0
        
        numSensors = len(self.perSensorCount) 
        self.sensorEvents = [0] * numSensors
        for id in self.perSensorCount:
            idx = info.getSensorIndex(id)
            l = self.perSensorCount[id]
            self.sensorEvents[idx] = [0] * l
                
        eventList.sort()
        if len(eventList)>0:
            self.startTime = eventList[0].ts
            self.endTime = eventList[-1].ts
        idxs = [0] * numSensors
        for e in eventList:
            idx = info.getSensorIndex(e.sid)
            self.sensorEvents[idx][idxs[idx]] = SensorEvent(e.ts,e.val)
            idxs[idx] += 1
            # self.addEvent(e.sid,e.ts,e.val)                            

    def incSensorCnt(self,id,val=1):
        try:
            self.perSensorCount[id] += val
        except:
            self.perSensorCount[id] = val

    # def addEvent(self, ID, time, value):
    #     self.checkAndAddID(ID)
    #     idx = self.sensorinfo.getSensorIndex(ID)
    #     if not self.isHeart or len(self.sensorEvents[idx]) == 0 or \
    #             time != self.sensorEvents[idx][-1].ts:
    #         self.sensorEvents[idx].append(SensorEvent(time, value))

    # def checkAndAddID(self,ID):
    #     idx = self.sensorinfo.getSensorIndex(ID)
    #     while len(self.sensorEvents) <= idx:
    #         self.sensorEvents.append([])
    #     # if not ID in self.sensorIdx:
    #     #     idx = len(self.sensorEvents)
    #     #     self.sensorIdx[ID] = idx
    #     #     self.sensorEvents.append([])
    #     #     self.sensorIDs.append(ID)
                
    def getEventList(self, sensorId):
        return self.sensorEvents[self.sensorinfo.getSensorIndex(sensorId)]
    
    def getEventListStartingAt(self, sensorId, t):
        idx = self.sensorinfo.getSensorIndex(sensorId)
        lst = self.sensorEvents[idx]
        if len(lst)==0:
            return lst
        if t<lst[0].ts:# or t > lst[-1].ts:
            return self.sensorEvents[idx]
        if t > lst[-1].ts:
            return lst[-1:]
        
        up = len(lst)
        low = 0;
        c = (low+up)/2

        while True:
            # print "t=%d, low=%d ts=%d, up=%d up-1.ts=%d, c=%d" % (t, low, lst[low].ts, up, lst[up-1].ts, c)
            # print "c.ts=%d, c+1.ts=%d" %(lst[c].ts, lst[c+1].ts)
            if lst[c].ts > t:
                up = c
            elif lst[c+1].ts < t:
                low = c
            else:
                return lst[c:]

            c = (low+up)/2

            
    def getEventListFromTo(self, sensorID, start, end):
        idx = self.sensorinfo.getSensorIndex(sensorID)
        lst = self.sensorEvents[idx]
        if len(lst)==0:
            return lst
        if start<lst[0].ts and end > lst[-1].ts:
            return self.sensorEvents[idx]
        if start > lst[-1].ts:
            return lst[-1:]
        
        up = len(lst)
        low = 0;
        c = (low+up)/2

        while True:
            # print "t=%d, low=%d ts=%d, up=%d up-1.ts=%d, c.ts=%d, c+1.ts=%d" % (start, low, lst[low].ts, up, lst[up-1].ts, lst[c].ts, lst[c+1].ts)
            if low==up:  
                break
            if lst[c].ts > start:
                up = c
            elif lst[c+1].ts < start:
                low = c
            else:
                break

            c = (low+up)/2

        startIdx = c               # Found the start element

        if end>lst[-1].ts:
            return lst[startIdx:]
        up = len(lst)
        low = 0;
        c = (low+up)/2

        while True:
            # print "t=%d, low=%d ts=%d, up=%d up-1.ts=%d, c.ts=%d, c+1.ts=%d" % (t, low, lst[low].ts, up, lst[up-1].ts, lst[c].ts, lst[c+1].ts)
            if low==up:
                break
            if lst[c].ts > end:
                up = c
            elif lst[c+1].ts < end:
                low = c
            else:
                break

            c = (low+up)/2
        endIdx = c+2
        if endIdx>=len(lst):
            endIdx=-1
        return lst[startIdx:endIdx]
        
    def getFirstTS(self):
        return self.startTime
    
    def getLastTS(self):
        return self.endTime
    
    # def getSensorName(self, sensorID):
    #     if sensorID in self.sensornames:
    #         return self.sensornames[sensorID]
    #     else:
    #         return hex(sensorID)

    # def getSensorID(self, index):
    #     # if index>=len(self.sensors):
    #     #     return None
    #     # else:
    #     return self.sensorIDs[index]
        
    # def getSensorIndex(self, ID):
    #     return self.sensorIdx[ID]

    # def unix2time(self,t):
    #     return t/24./3600.+719529

    # def getNumSensors(self):
    #     return len(self.sensorIDs)
    
