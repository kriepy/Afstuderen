from __future__ import print_function
from SensorData import SensorEvent, SensorData
from string import split
from time import strftime, gmtime, time
from timefn import *
from Graph import *
# from Gene import *
import sys
import traceback

class Feat:
    def __init__(self, data, info):
        self.info = info
        self.unkownKW=set([])

        # Organise the events in sets per day
        firstTS = data.getFirstTS()
        lastTS = data.getLastTS()
        # print "First=%f, last=%f, day0=%d, day1=%d" % (firstTS,lastTS,int(firstTS), int(lastTS)+1)
        
        self.firstDay = int(firstTS)
        self.numDays = int(lastTS)-self.firstDay+1        
        numSensors = info.getNumSensors()
        numKW = info.getNumKW()
        
        # self.perDay = [list()] * self.numDays
        # self.perDayPerSensor = [ [list()] * numSensors ] * self.numDays
        # self.perDayPerKeyword = [ [list()] * numKW ] * self.numDays
        self.perDay = []
        self.perDayPerSensor = []
        self.perDayPerKeyword = []
        for d in xrange(self.numDays):
            self.perDay.append([])
            self.perDayPerSensor.append([])
            for s in xrange(numSensors):
                self.perDayPerSensor[d].append([])
            self.perDayPerKeyword.append([])
            for w in xrange(numKW):
                self.perDayPerKeyword[d].append([])

        for idx in xrange(numSensors):
            self.perDayPerSensor.append([])
            id = info.getSensorID(idx)
            lst = data.getEventList(id)
            for e in lst:
                day = int(e.ts - (3./24)) - self.firstDay # new day starts at 3am
                if day < 0:
                    day = 0                
                self.perDay[day].append(e)
                self.perDayPerSensor[day][idx].append(e)        

        for w in xrange(numKW):            
            for s in self.info.getKWIDSensorIDs(w):
                for day in xrange(self.numDays):
                    # print day,w,s,numSensors
                    self.perDayPerKeyword[day][w] = union(\
                        self.perDayPerKeyword[day][w],
                        self.perDayPerSensor[day][info.getSensorIndex(s)])

        for d in xrange(self.numDays):
            self.perDay[d].sort()

    def evtPerKW(self,day, kw):
        try:
            idx = self.info.getKWindex(kw)
            return self.perDayPerKeyword[day-self.firstDay][idx]
        except:
            if not kw in self.unkownKW:
                print("Warning: Keyword '%s' not known" % (kw))
                self.unkownKW.add(kw)                
            return []

    def evtPerSensorID(self,day, id):
        try:
            idx = self.info.getSensorIndex(id)
            return self.perDayPerKeyword[day-self.firstDay][idx]
        except:
            if not id in self.unkownKW:
                print("Warning: Sensor ID %d not known" % (id))
            self.unkownKW.add(id)
            return []
        
    def evtDay(self,day):
        return self.perDay[day-self.firstDay]
                  
    def runDays(self, r):
        timestamps = []
        vals = []
        for day in xrange(1,self.numDays):
            (ts,v) = r(self.firstDay+day, self, self.info)
            timestamps.append(ts)
            vals.append(v)
        return (timestamps,vals)

    def runTree(self, tree):
        timestamps = []
        vals = []
        for day in xrange(1,self.numDays):
            v = tree.execute(self.firstDay+day)
            timestamps.append(self.firstDay+day+.4)
            vals.append(v)
        return (timestamps,vals)
    
def assertsorted(lst):
    if len(lst)==0:
        return
    prev=lst[0]
    for e in lst:
        if e.id<prev.id:            
            print("ERROR!! List is not sorted!")
            traceback.print_stack()
            return
    
def union(lst1,lst2):
    c1=0
    c2=0
    c=0
    l1 = len(lst1)
    l2 = len(lst2)
    res = [0] * (l1+l2)
    while c1<l1 and c2<l2:
        if lst1[c1] < lst2[c2]:
            res[c] = lst1[c1]
            c1 += 1
        else:
            res[c] = lst2[c2]
            c2 += 1
        c += 1
    while c1<l1:
        res[c]=lst1[c1]
        c1+=1
        c+=1
    while c2<l2:
        res[c] = lst2[c2]
        c2+=1
        c+=1

    assertsorted(res)
    return res


def intersection(lst1,lst2):
    c1=0
    c2=0
    l1=len(lst1)
    l2=len(lst2)
    res = []
    while c1<l1 and c2<l2:
        if lst1[c1] < lst2[c2]:
            c1+=1
        elif lst2[c2] < lst1[c1]:
            c2+=1
        else:
            res.append(lst2[c2])
            c1+=1
            c2+=1
        
    return res

def setdiff(lst1,lst2):
    """Return those elements from lst1 that are not in lst2"""
    c1=0
    c2=0
    l1=len(lst1)
    l2=len(lst2)
    res=[]
    while c1<l1 and c2<l2:
        if lst1[c1] < lst2[c2]:
            res.append(lst1[c1])
            c1+=1
        elif lst2[c2]<lst1[c1]: 
            c2+=1
        else:                   # they're identical
            c1+=1
            c2+=1
    res.extend(lst1[c1:])
    assertsorted(res)
    return res
    

def b2i(bool):
    if bool:
        return 1
    return 0

def filterBlips(l, surround = hour, duration = 5*minute,maxNum=10):
    """Remove all groups of events from l which are isolated, in that at no events
    happened at least 'surround' time before the first and after the last event, and
    at most 'duration' time happened between the first and last event"""
    if len(l)==0:
        return l
    
    res = []
    prevTS = l[0].ts - 2*surround
    blipstart = -1
    for i in xrange(len(l)):
        # print("prevTS=%s, ts=%s, blipstart=%d, ts[start]=%s  " % (time2str(prevTS), time2str(l[i].ts), blipstart, ("N/A", time2str(l[blipstart].ts))[b2i(blipstart!=-1)]),end='');
        if l[i].ts-surround>prevTS:
            # this could be the first element of a blip
            # or it could be the first element after the end of a blip
            # In both cases we start a new potential blip (and don't save what came previously)
            # print("Resetting blipstart")
            blipstart=i
        elif blipstart != -1:
            if l[i].ts - duration > l[blipstart].ts or i-blipstart>maxNum: # this is not a blip, and we need to add
                # print("Setting blipstart=-1, copying %d:%d",blipstart,i+1)
                res.extend(l[blipstart:i+1])
                blipstart = -1
            # else:
            #     print("skipping")
        else:                   # we're not in a potential blip.
            # print("Appending")
            res.append(l[i])
        prevTS = l[i].ts
    # if blipstart!=-1:           # it's not a blip if we don't know what follows
    #     res.extend(l[blipstart:])
    return res

def lowpass(lst, minT=1*minute):
    res = []
    prevTS=(0.,0.)
    for e in lst[1:]:
        if e.ts-prevTS[e.val] > minT:
            res.append(e)
    return res


def before(lst1, lst2):
    """ Return the elements from set1 that happen before the first element from set2"""
    if len(lst2)==0:
        return lst1

    res = []    
    id=lst2[0].id
    for e in lst1:
        if e.id<id:
            res.append(e)
    return res
        
def after(lst1, lst2):
    """ Return the elements from set1 that happen after the last element from set2"""
    if len(lst2)==0:
        return lst1
    res = []
    id=lst2[-1].id
    for e in set1:
        if e.id>id:
            res.append(e)
    return res

def duration(s):
    """Return the time span between the first and last element in the set"""
    if len(s)==0:
        return 0.

    return s[-1].ts-s[0].ts
    
def timeFirst(s):
    """Return the time of day of the first element in the set"""
    if len(s)==0:
        return 0.
    
    return s[0].ts - int(s[0].ts)


def timeLast(s):
    """Return the time of day of the last element in the set"""
    if len(s)==0:
        return 0.
    
    t = s[-1].ts-int(s[0].ts)
    if t <= 3./24:               # day changes at 3am
        t +=1.
    return t

def timeIntervals(s1,s2):
    """Return the duration of intervals between sensor firings of set s1, during which no
    events happened in set s2"""

    l1=len(s1)
    if l1==0:
        return 0.
    l2 = len(s2)
    if l2==0:
        return s1[-1].ts-s1[0].ts
    c2=0
    res = 0.
    for c1 in xrange(l1-1):     # if l1==1, res=0
        while c2<l2 and s2[c2].id<s1[c1].id:
            c2+=1
        if c2==l2:
            return res + s1[-1].ts - s1[c1].ts
        if c1+1<l1 and s2[c2].id>s1[c1+1].id:
            res += s1[c1+1].ts-s1[c1].ts
    return res
        

def time2str(t):
    res = ""
    # if int(t) != 0:
    #     res += "%d days " % int(t)
    t -= int(t)
    t *= 24*3600
    res += "%02d:%02d:%02d" % (int(t/3600), (int(t)%3600)/60, int(t)%60 )
    return res

# def time2str(t):
#     return str(t) + " - " + strftime("%a, %d %b %Y %H:%M:%S", gmtime((t-719529)*24*3600))
