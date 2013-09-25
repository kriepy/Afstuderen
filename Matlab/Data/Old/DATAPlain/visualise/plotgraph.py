from timefn import *
from Feat import *
from Gene import *

def wake(day,feat,info):
    d = filterBlips(union(union(feat.evtPerKW(day,"kitchen"), feat.evtPerKW(day,"exit")),\
                              feat.evtPerKW(day,"hall")))
    return (day+.5,timeFirst(d))

# def timeLast(s):
#     """Return the time of day of the last element in the set"""
#     if len(s)==0:
#         return 0.
    
#     t = s[-1].ts-int(s[0].ts)
#     if t <= 3./24:               # day changes at 3am
#         t += 1.
#     return t


def sleep(day,feat,info):
    d = filterBlips(union(union(union( \
                feat.evtPerKW(day,"kitchen"), feat.evtPerKW(day,"exit")),\
                        feat.evtPerKW(day,"hall")),feat.evtPerKW(day,"living")))
    # d = filterBlips(union(union(union( \
    #                 feat.evtPerKW(day,"kitchen"), feat.evtPerKW(day,"exit")),\
    #                                 feat.evtPerKW(day,"hall")),feat.evtPerKW(day,"living")))
    return (day+.5,timeLast(d))


def dur(day,feat,info):
    d = filterBlips(feat.evtDay(day),maxNum=1000)
    return (day+.5,duration(events))

def lowpass(lst, minT=1*minute):
    res = []
    prevTS=0.
    for e in lst[1:]:
        if e.ts-prevTS > minT:
            res.append(e)
            
        prevTS=e.ts
    return res

def toilet(day,feat,info):
    d = filterBlips(union(union(feat.evtPerKW(day,"kitchen"), \
                                    feat.evtPerKW(day,"exit")),\
                              feat.evtPerKW(day,"hall")))
    l = len(lowpass(before(feat.evtPerKW(day,"toilet"),d)))
    return (day+.5,l)


def outdoors(day,feat,info):
    door = feat.evtPerKW(day,"exit")
    rest = filterBlips(setdiff(feat.evtDay(day),union(door,feat.evtPerKW(day,"hall"))))
    
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

def anysensor(day,feat,info):
    return (day+0.5,len(feat.evtDay(day)))

def computeGraphs(feat,data,info):    
    # # Crap for making trees possible:
    # setfn3 = []
    # setfn2 = []
    # featfn1 = []
    # featfn2 = []

    # unionfnc = TwoArgFunction(feat,setfn2,union)
    # intersectionfnc = TwoArgFunction(feat,setfn2,intersection)
    # setdifffnc = TwoArgFunction(feat,setfn2,setdiff)
    # beforefnc = TwoArgFunction(feat,setfn2,before)
    # afterfnc = TwoArgFunction(feat,setfn2,after)
    # setfn2.extend([unionfnc, intersectionfnc, setdifffnc, beforefnc, afterfnc])

    # filterblipsfnc = ThreeArgFunction(feat, setfn3, filterBlips)
    # setfn3.extend([filterblipsfnc])

    # tffnc = OneArgFunction(feat,featfn1,timeFirst)
    # tlfnc = OneArgFunction(feat,featfn1,timeLast)
    # featfn1.extend([tffnc,tlfnc])

    # tifnc = TwoArgFunction(feat,featfn2,timeIntervals)
    # featfn2.extend([tifnc])
    # # Ok, here starts the real stuff


    g1 = Graph("Wake time", Graph.TIME, "darkgreen")
    g1.setVals(feat.runDays(wake))
    g1.normalise(0,1.125)

    # g11 = Graph("Wake tree", Graph.TIME, "orange")
    # g11tree = Fn(tffnc,[Fn(filterblipsfnc,
    #                        [Fn(unionfnc,
    #                            [Fn(unionfnc,
    #                                [Set(feat,"kitchen"),
    #                                 Set(feat,"exit")]),
    #                             Set(feat,"hall")]),
    #                         Scalar(1*hour, 10*minute),
    #                         Scalar(5*minute, 10*minute)])])
    # g11.setVals(feat.runTree(g11tree))
    # g11.normalise(0,1.125)    
    
    g2 = Graph("Bedtime", Graph.TIME)
    g2.setVals(feat.runDays(sleep))
    g2.normalise(0,1.125)

    # g12 = Graph("Sleep tree", Graph.TIME, "darkred")
    # g12tree = Fn(tlfnc,[Fn(filterblipsfnc,
    #                        [Fn(unionfnc,
    #                            [Fn(unionfnc,
    #                                [Fn(unionfnc,
    #                                    [Set(feat,"kitchen"),
    #                                     Set(feat,"exit")]),
    #                                 Set(feat,"hall")]),
    #                             Set(feat,"living")]),
    #                         Scalar(1*hour, 10*minute),
    #                         Scalar(5*minute, 10*minute)])])
    # g12.setVals(feat.runTree(g12tree))
    # g12.normalise(0,1.125)

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
