from Feat import *
from numpy import random as rnd
from Feat import *
from SensorInfo import *
from SensorData import *

class Scalar:
    """Class representing a real-valued scalar"""
    def __init__(self, initval, changestd):
        self.val = initval
        self.std = changestd

    def execute(self, day):
        return self.val

    def modify(self):
        self.val += self.std * rnd.randn()
        return self

    def __repr__(self):
        return "Scalar(%0.1g)" % (self.val)

class Set:
    """Class representing a set of events"""
    def __init__(self, feat, setid):
        self.feat = feat
        self.id = setid
        self.kw = feat.info.getKeywordList()

    def execute(self, day):
        return self.feat.evtPerKW(day,self.id)

    def modify(self):
        idx = rnd.randint(0,len(self.kw))
        self.id = self.kw[idx]
        return self

    def __repr__(self):
        return '"'+self.id+'"'

class FunctionType:
    def modify(self):
        idx = rnd.randint(0,len(self.collection))
        return self.collection[idx]

    def __repr__(self):
        return self.fn.__name__    
    
class OneArgFunction(FunctionType):
    """Class representing a function, keeping track of what 'compatible'
    functions are available for modification. This class is for functions
    with one argument"""
    def __init__(self,feat,collection,function):
        self.feat = feat
        self.collection = collection
        self.fn = function

    def execute(self,day, args):
        # if len(args) != 1:
        #     print "Wrong number of args to ", self, "(",len(args),")"
        # a0 = args[0].execute(day)
        # res =  self.fn(a0)
        # print self,"(",day,",",a0,") -> ",res
        # return res
        return self.fn(args[0].execute(day))


class TwoArgFunction(FunctionType):
    """Class representing a function, keeping track of what 'compatible'
    functions are available for modification"""
    def __init__(self, feat,collection,function):
        self.feat = feat
        self.collection = collection
        self.fn = function

    def execute(self, day, args):
        # if len(args) != 2:
        #     print "Wrong number of args to ", self, "(",len(args),")"
        # a0 = args[0].execute(day)
        # a1 = args[1].execute(day)
        # res =  self.fn(a0,a1)
        # print self,"(",day,",",a0,",",a1,") -> ",res
        # return res
        return self.fn(args[0].execute(day),
                       args[1].execute(day))

class ThreeArgFunction(FunctionType):
    """Class representing a function, keeping track of what 'compatible'
    functions are available for modification. This class is for functions
    with three arguments"""
    def __init__(self,feat,collection,function):
        self.feat = feat
        self.collection = collection
        self.fn = function

    def execute(self,day, args):
        # if len(args) != 3:
        #     print "Wrong number of args to ", self, "(",len(args),")"
        # a0 = args[0].execute(day)
        # a1 = args[1].execute(day)
        # a2 = args[2].execute(day)
        # res =  self.fn(a0,a1,a2)
        # print self,"(",day,",",a0,",",a1,",",a2,") -> ",res
        # return res
        return self.fn(args[0].execute(day),
                       args[1].execute(day),
                       args[2].execute(day))
    

class Fn:
    """A function (any input, any output) with arguments. Modifying the
    function changes the function "class", i.e., what the function does
    which is captured in a OneArgFunction or TwoArgFunction,
    but it leaves the arguments intact"""
    def __init__(self, fnclass, args):
        self.fn = fnclass
        self.args = args

    def execute(self, day):
        return self.fn.execute(day, self.args)

    def modify(self):
        self.fn = self.fn.modify()
        for a in self.args:
            a.modify()

    def __repr__(self):
        res = self.fn.__repr__() + "("
        for a in self.args[:-1]:
            res += a.__repr__() + ","
        res += self.args[-1].__repr__() + ")"
        return res


    

if __name__ == "__main__":

    dir = "./"
    
    info = SensorInfo(dir+"/sensornames.txt", dir+"/sensorinfo.txt")    
    data = SensorData(info, dir + "/sensorreadings.txt")
    feat = Feat(data, info)

    setfn3 = []
    setfn2 = []
    featfn1 = []
    featfn2 = []

    unionfnc = TwoArgFunction(feat,setfn2,union)
    intersectionfnc = TwoArgFunction(feat,setfn2,intersection)
    setdifffnc = TwoArgFunction(feat,setfn2,setdiff)
    beforefnc = TwoArgFunction(feat,setfn2,before)
    afterfnc = TwoArgFunction(feat,setfn2,after)
    setfn2.extend([unionfnc, intersectionfnc, setdifffnc, beforefnc, afterfnc])
    
    filterblipsfnc = ThreeArgFunction(feat, setfn3, filterBlips)
    setfn3.extend([filterblipsfnc])

    tffnc = OneArgFunction(feat,featfn1,timeFirst)
    tlfnc = OneArgFunction(feat,featfn1,timeLast)
    featfn1.extend([tffnc,tlfnc])

    tifnc = TwoArgFunction(feat,featfn2,timeIntervals)
    featfn2.extend([tifnc])
    
    tst = Fn(tffnc,[Fn(filterblipsfnc,
                       [Fn(unionfnc,
                           [Fn(unionfnc,
                               [Set(feat,"kitchen"),
                                Set(feat,"exit")]),
                            Set(feat,"hall")])]),
                    Scalar(1*hour, 10*minute),
                    Scalar(5*minute, 10*minute),3])

    print tst
    tst.modify()
    print tst
    

# fn = {}
    
    
# class Function:
#     IN_SET=1
#     IN_TWO_SET=2

#     IN_TWO

#     OUT_SET=100
#     OUT_SCALAR=101

#     ID=0
    
#     def __init__(self, function, intype, outtype, children):
#         self.id = ID        
#         ID += 1
#         self.intype  = intype
#         self.outtype = outtype
#         self.fn  = function
#         fn[self.id] = self
#         self.children = children

#     def execute(self, feat, day):
#         if self.intype == IN_SET:
#             return self.fn(self.children[0].execute(feat,day))
#         elif self.intype == IN_TWO_SET:
#             return self.fn(self.children[0].execute(feat,day)
#                            self.children[1].execute(feat,day))

# Function(union, Function.IN_TWO_SET, Function.OUT_SET)
# Function(intersection, Function.IN_TWO_SET, Function.OUT_SET)
# Function(setdiff, Function.IN_TWO_SET, Function.OUT_SET)
# Function(before, Function.IN_TWO_SET, Function.OUT_SET)
# Function(after, Function.IN_TWO_SET, Function.OUT_SET)

# Function(filterBlips, Function.IN_SET, Function.OUT_SET)

# Function(duration, Function.IN_SET, Function.OUT_SCALAR)
# Function(timeFirst, Function.IN_SET, Function.OUT_SCALAR)
# Function(timeLast, Function.IN_SET, Function.OUT_SCALAR)

        
# class Gene:
#     def __init__(self):
        
