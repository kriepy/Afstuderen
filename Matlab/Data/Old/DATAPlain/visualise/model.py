#!/usr/bin/python

def getFeatures(file, timestep=3600):
    stream = open(file, "r")
    lines = stream.read().split('\n')
    res = []
    lastTime = 0
    for l in lines:
        data = l.split()
        if len(data) == 4:
            start=float(data[0])
            end = float(data[1])
            sensor = int(data[2])
        elif len(data) == 3:
            start = end = float(data[0])
            sensor = int(data[1])

        if lastTime == 0:
            lastTime = start + timestep
        if end > lastTime:
            
    
