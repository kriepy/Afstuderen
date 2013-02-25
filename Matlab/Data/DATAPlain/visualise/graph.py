from timefn import *
from Feat import *

def wake(day,events,perSensor,perKeyword,info):
    d = filterBlips(union(union(perKeyword[info.getKWindex("kitchen")], perKeyword[info.getKWindex("exit")]),\
              perKeyword[info.getKWindex("hall")]))
    return (day+.5,timeFirst(d))
def sleep(day,events,perSensor,perKeyword,info):
    d = filterBlips(union(union(perKeyword[info.getKWindex("kitchen")], perKeyword[info.getKWindex("exit")]),\
                  perKeyword[info.getKWindex("hall")]))
    return (day+.5,timeLast(d))


def dur(day,events,perSensor,perKeyword,info):
    d = filterBlips(events,maxNum=1000)
    return (day+.5,duration(events))

def lowpass(lst, minT=1*minute):
    res = []
    prevTS=0.
    for e in lst[1:]:
        if e.ts-prevTS > minT:
            res.append(e)
            
        prevTS=e.ts
    return res

def toilet(day,events,perSensor,perKeyword,info):
    d = filterBlips(union(union(perKeyword[info.getKWindex("kitchen")], \
                        perKeyword[info.getKWindex("exit")]),\
                  perKeyword[info.getKWindex("hall")]))
    l = len(lowpass(before(perSensor[info.getSensorIndex(2)],d)))
    return (day+.5,l)


def outdoors(day,events,perSensor,perKeyword,info):
    door = perSensor[info.getSensorIndex(6)]
    rest = union(perKeyword[info.getKWindex("kitchen")], union(perKeyword[info.getKWindex("bathroom")], perKeyword[info.getKWindex("bedroom")]))
    # I dropped living here, because the workspace seems to catch motion from out the doors...

    d=0
    r=0
    res = 0.;
    try:
        while d<len(door)-1:
            while rest[r].id < door[d].id:
                if r == len(rest):
                    raise Exception("Discarding further outdoors time")
                r+=1
        
            if rest[r].id > door[d+1].id:
                res += door[d+1].ts - door[d].ts
            d += 1
    except:
        pass

    return (day+.5,res)

def anysensor(day,events,perSensor,perKeyword,info):
    return (day+0.5,len(events))

def computeGraphs(feat,data,info):    
    g1 = Graph("Wake time", Graph.TIME, "darkgreen")
    g1.setVals(feat.runDays(wake))
    g1.normalise(0,1.125)

    g2 = Graph("Bedtime", Graph.TIME)
    g2.setVals(feat.runDays(sleep))
    g2.normalise(0,1.125)

    g3 = Graph("#toilet/night", Graph.INT, "darkred")
    g3.setVals(feat.runDays(toilet))
    g3.autoNorm()

    g4 = Graph("outdoors", Graph.TIME, "blue")
    g4.setVals(feat.runDays(outdoors))
    g4.autoNorm()

    g5 = Graph("any", Graph.INT, "orange")
    g5.setVals(feat.runDays(anysensor))
    g5.autoNorm()
    # # g5 = feat.runDays(dur)
    # # g5.normalise(0,1.125)
    # # g5.colour = "magenta"
    

    return [g1,g2,g3,g4,g5]
