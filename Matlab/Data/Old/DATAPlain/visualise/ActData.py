from string import split

class Activity:
    def __init__(self, parent, start, end, id):
        self.start = start
        self.end = end        
        self.id = id
        self.actNames = parent.actNames
        self.elt = None
        self.type = 1

    def getName(self):
        return self.actNames[self.id]
    
class ActData:
    def __init__(self, datafile, namelist):
        self.startTime = 1e100
        self.endTime = 0
        self.activities = []
        self.actNames = ["","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""]
        
        try:
            f = open(datafile)
            for line in f:
                l = split(line)
                start = eval(l[0])
                end = eval(l[1])
                id = int(eval(l[2]))

                if start < self.startTime:
                    self.startTime = start
                if end > self.endTime:
                    self.endTime = end

                self.activities.append(Activity(self,start,end,id))

            f.close()
        except IOError as (errno, strerror):
            print "Cannot open %s: %s (Could not load list of activities)" % (datafile,strerror) 
        try:
            f = open(namelist)
            for line in f:
                l = split(line,maxsplit=1)
                if len(l) == 2:
                    id = int(eval(l[0]))
                    s = l[1]
                    if s[-1] == '\n':
                        s = s[:-1]
                    self.actNames[id] = s
        except IOError as (errno, strerror):
            print "Cannot open %s: %s (Could not load activity names)" % (namelist,strerror);
            
    def add(self, start, end, id):
        self.activities.append(Activity(self,start,end,id))
        self.activities.sort(key=lambda a: a.start)
    def getFirstTS(self):
        return self.startTime
    def getLastTS(self):
        return self.endTime
    def getAct(self, name):
        return self.actNames.index(name)
    def printAct(self, file):
        f = open(file, 'w')
        for a in self.activities:
            f.write(str(a.start)+" "+str(a.end)+" "+str(a.id)+"\n")
