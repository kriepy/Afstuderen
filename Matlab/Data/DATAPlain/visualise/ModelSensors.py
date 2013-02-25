#!/usr/bin/python

from SensorData import *
from InvalidSensors import *
from numpy import *
from helpers import *
from MVGauss import *
from hmm import *
import sys
import os


class ModelSensors:
    """
    Build a model of sensor firings that discriminates between working and broken sensors
    """

    def __init__(self, info, data, invalids, deltaT = 1./24):
        self.info = info
        self.data = data
        self.invalids = invalids
        self.deltaT = deltaT
        self.sum = array([0.])
        cnt = []
        self.lab = []        
        for idx in xrange(info.getNumSensors()):
            (c,l) = self.countEvents(idx)
            cnt.append(c)
            self.lab.append(l)
            # print len(c),array(c)
            # print l
            self.sum = self.sum + array(c)
        self.cnt = array(cnt)
        self.train()
        self.computeInvalids()

    def featLen(self):
        return int((self.data.endTime - int(self.data.startTime))/self.deltaT)+1

    def countEvents(self, idx):
        # idx = self.data.sensorIdx[sensorID]
        sensorID = self.info.getSensorID(idx)
        nextTime = int(self.data.startTime) + self.deltaT
        res = []
        lab = []
        cnt = 0
        for e in self.data.sensorEvents[idx]:
            while e.ts > nextTime:
                res.append(cnt)
                lab.append(self.invalids.isInvalid(sensorID,nextTime-self.deltaT,nextTime))
                cnt = 0
                nextTime += self.deltaT
            cnt += 1
        # print self.featLen(), len(res)
        res += [0] * (self.featLen() - len(res))
        lab += [False] * (self.featLen() - len(res))

        return (res,lab)

    def idx2time(self, idx):
        return int(self.data.startTime) + idx * self.deltaT

    def sumExcept(self, idx):
        return self.sum - self.cnt[idx,:]

    def getFeat(self,idx):
        return array([self.cnt[idx,:],self.sumExcept(idx)])
       
    def train(self):
        """
        Compute the parameter values (ML) of the model
        """
        inval_self = []
        inval_other = []
        self.val = []
        self.val_mu=[]
        self.val_C=[]
        for i in xrange(len(self.lab)):
            val_self = [10, 0, 0, 10]
            val_other = [0, 10, 0, 10]
            sum = self.sumExcept(i)
            for j in xrange(len(self.lab[i])/10):
                if self.lab[i][j]:
                    inval_self.append(self.cnt[i][j])
                    inval_other.append(sum[j])
                else:
                    val_self.append(self.cnt[i][j])
                    val_other.append(sum[j])
            val = array([val_self,val_other])
            self.val.append(MVGauss(mean(val,1), cov(val)))
            self.val_mu.append(mean(val,1)[0])
            self.val_C.append(cov(val)[0,0])
            
        # inval = array([inval_self,inval_other])
        # self.val = MVGauss(mean(val,1), cov(val))
        inval = array(inval_self)
        self.inval_var = cov(inval)
        # print "Variance:",self.inval_var
        # self.inval = MVGauss(mean(inval,1), cov(inval))    

    def states(self, idx):
        h = Hmm(2,1)
        h.transP[0,0] = 5
        h.transP[1,1] = 10
        for i in range(3):
            logNormalise(h.transP[i])
        h.obsP[0] = MVGauss(array([self.val_mu[idx]]),array([[self.val_C[idx]]]))
        h.obsP[1] = MVGauss(array([0]),array([[1]]))
        
        return h.viterbi(self.cnt[idx])

    def logValidP(self,idx):
        h = Hmm(2,1)
        h.transP[0,0] = 5
        h.transP[1,1] = 10
        for i in range(3):
            logNormalise(h.transP[i])
        h.obsP[0] = MVGauss(array([self.val_mu[idx]]),array([[self.val_C[idx]]]))
        h.obsP[1] = MVGauss(array([0]),array([[1]]))

        return h.logPost(self.cnt[idx])[:,0]
        
    
    # def logValidP(self, idx):
    #     res = [0] * len(self.cnt[idx])
    #     sum = self.sumExcept(idx)
    #     for i in xrange(len(self.cnt[idx])):
    #         f = array([self.cnt[idx][i], sum[i]])
    #         num = logGauss(self.cnt[idx][i],self.val_mu[idx],self.val_C[idx])
    #         # self.val[idx].logP(f[0])
    #         denom = log_sum_exp(num,logGauss(self.cnt[idx][i],0,1))
    #         res[i] = num - denom
    #     return res
            
    def computeInvalids(self):
        res = []
        for i in xrange(len(self.lab)):
            st = self.states(i)
            active = False
            for j in xrange(len(st)):
                if st[j] > .5: # -0.693147: # log(1/2)
                    if not active:
                        active = True
                        start = self.idx2time(j)
                    end = self.idx2time(j+1)
                elif active:
                    active = False
                    res.append(Invalid(start,end,self.info.getSensorID(i)))
            if active:
                res.append(Invalid(start,end,self.info.getSensorID(i)))
        self.invalids = res    
        
# dir = os.getcwd()
# if len(sys.argv) == 2:
#     dir = sys.argv[1]
# if dir[-1] == '/':
#     dir = dir[:-1]

# sensors = SensorData(dir + "/sensorreadings.txt", dir+"/sensornames.txt")
# invalids = InvalidSensors(dir+"/invalid.txt")

# model = ModelSensors(sensors, invalids, 1)

        
