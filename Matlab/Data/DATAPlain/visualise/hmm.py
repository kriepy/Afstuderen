
from numpy import *
from helpers import *
from MVGauss import *
import cProfile
import pstats


REG = 1e-2

def logNormalise(a):
    s = -inf
    for n in a:
        s = log_sum_exp(s,n)
    for i in range(len(a)):
        a[i] -= s


class Hmm:
    def __init__(self, N, dim=1):
        """
        Initialise an HMM with random mean (Sampled from zero-mean, unit variance Gauss)
        and identity covariance matrix
        """
        self.N = N
        self.dim = dim
        self.transP = zeros((N+1,N+1))             # last row: start -> state, last col: state -> end
        self.transP[N,N] = -inf                    # no transition from start to end
        for i in range(N+1):
            logNormalise(self.transP[i])
        self.obsP   = []
        for i in xrange(N):
            self.obsP.append(MVGauss(random.multivariate_normal(zeros(dim),1e3*eye(dim)),1e3*eye(dim)))

    def logForward(self, obs):
        T = len(obs)
        logP = array([[-inf]*self.N ] * T)
        for n in xrange(self.N):
            logP[0,n] = self.transP[self.N,n] + self.obsP[n].logP(obs[0])
        for t in xrange(1,T):
            t1=t-1
            for n in range(self.N):
                for m in range(self.N):
                    logP[t,n] = log_sum_exp(logP[t,n], logP[t1,m] + self.transP[m,n])
                logP[t,n] += self.obsP[n].logP(obs[t])
        logFW = -inf
        T1=T-1
        for n in xrange(self.N):
            logFW = log_sum_exp(logFW, logP[T1,n] + self.transP[n,self.N])
        return (logFW, logP)

    def logBackward(self,obs):
        T = len(obs)
        T1=T-1
        logP = array([[-inf]*self.N ] * T)
        for n in xrange(self.N):
            logP[T1,n] = self.transP[n,self.N]
        for t in xrange(T-2,-1,-1):
            for n in range(self.N):
                for m in range(self.N):
                    logP[t,n] = log_sum_exp(logP[t,n], self.transP[n,m] +
                                            self.obsP[m].logP(obs[t+1]) + logP[t+1,m])
        logBW = -inf
        for n in xrange(self.N):
            logBW = log_sum_exp(logBW, self.transP[self.N,n] +
                                self.obsP[n].logP(obs[0]) + logP[0,n])
        return (logBW, logP)

    def logPost(self,obs):
        T = len(obs)
        (fw,logP) = self.logForward(obs)
        logBW = array([-inf] *self.N)
        prevBW = array(logBW)
        for n in xrange(self.N):
            logBW[n] = self.transP[n,self.N]
        logP[T-1] += logBW - fw
        for t in xrange(T-2,-1,-1):
            (prevBW,logBW) = (logBW,prevBW)
            logBW.fill(-inf)
            for n in range(self.N):
                for m in range(self.N):
                    logBW[n] = log_sum_exp(logBW[n], self.transP[n,m] +
                                           self.obsP[m].logP(obs[t+1]) + prevBW[m])
            logP[t] += logBW - fw
        return logP
        
    # def logPost(self,obs):
    #     (fw,logAlpha) = self.logForward(obs)
    #     (bw,logBeta) = self.logBackward(obs)

    #     # print exp(logAlpha + logBeta - fw)
        
    #     return logAlpha + logBeta - fw
    
    def viterbi(self, obs):
        T = len(obs)
        logP = array([ [0.] * self.N ] * T)
        track = array([ [self.N] * self.N ] * T)

        for n in range(self.N):
            logP[0,n] = self.transP[self.N,n] + self.obsP[n].logP(obs[0])
        
        for t in range(1,T):
            for n in range(self.N):
                maxP = -inf
                for m in range(self.N):
                    lp = logP[t-1,m] + self.transP[m,n]
                    if lp > maxP:
                        maxP = lp
                        maxI = m
                logP[t,n] = self.obsP[n].logP(obs[t]) + maxP
                track[t,n] = maxI

        maxP = -inf
        for n in range(self.N):
            p = logP[T-1,n] + self.transP[n,self.N]
            if p > maxP:
                maxP = p
                maxI = n

        res = [ 0 ] * T
        res[T-1] = maxI
        for t in xrange(T-1,0,-1):
            res[t-1] = track[t,res[t]]
        return res
            
    def em(self, obss):
        pll = -inf
        ll = self.stepEM(obss)
        while ll-pll > 1e-3:
            print "prev=",pll, "ll=", ll, "delta=",ll-pll
            pll = ll
            ll = self.stepEM(obs)
        print "prev=",pll, "ll=", ll, "delta=",ll-pll
        # print self.obsP

    def stepEM(self,obss):
        loglik = 0

        # E Step
        trans = array( [ [0.] * (self.N+1) ] * (self.N+1) )
        sumO = []
        sumO2 = []
        for i in range(self.N):
            sumO.append(zeros(self.dim))
            sumO2.append(zeros((self.dim,self.dim)))

            print "shape(sumO)", shape(sumO[i])
        norm = array( [0.] * self.N)
        
        for obs in obss:
            (logFW, alpha) = self.logForward(obs)
            (logBW, beta) = self.logBackward(obs)
            # print "logFW, logBW", logFW, logBW  # Must be identical

            outer0 = outer(obs[0],obs[0])                          
            for i in range(self.N):
                logGamma_i = alpha[0,i] + beta[0,i] - logFW
                gamma_i = exp(logGamma_i)
                # print "gamma", gamma_i
                # print shape(obs[0])
                # print shape(outer(obs[0],obs[0]))
                sumO[i] += gamma_i * obs[0]
                sumO2[i] += gamma_i * outer0
                norm[i] += gamma_i

                trans[self.N,i] = log_sum_exp(trans[self.N,i],logGamma_i)
                # also update the transition from the last state to the end state
                T = len(obs)-1
                logGamma_i = alpha[T,i] + beta[T,i] - logFW
                trans[i,self.N] = log_sum_exp(trans[i,self.N],logGamma_i)
            
            for t in range(1,len(obs)):
                outert = outer(obs[t],obs[t])
                for i in range(self.N):
                    gamma_i = exp(alpha[t,i] + beta[t,i] - logFW)
                    sumO[i] += gamma_i * obs[t]
                    sumO2[i] += gamma_i * outert
                    norm[i] += gamma_i
                    for j in range(self.N):
                        logXi_ij = alpha[t-1,i] + self.transP[i,j] + self.obsP[j].logP(obs[t]) + beta[t,j] - logFW
                        trans[i,j] = log_sum_exp(trans[i,j],logXi_ij)

            loglik += logFW

        # M step
        self.transP = trans
        for i in range(self.N):
            mean = sumO[i] / norm[i]
            sigma = sumO2[i] / norm[i] - outer(mean,mean)
            print "Trace=", trace(sigma)/self.dim
            if trace(sigma)/self.dim < 1e-3: # REGULARISATION
                sigma += REG*eye(self.dim)
            # print "shape(sumO)",shape(sumO[i])
            # print "shape(mean)",shape(mean)
            # print "shape(norm[i])",shape(norm[i])
            # print "shape(sumO2)",shape(sumO2[i])
            self.obsP[i].update(mean, sigma)
            # print "normalise"
            logNormalise(self.transP[i])
        logNormalise(self.transP[self.N])
        print "loglik",loglik
        return loglik

# seterr(all="raise")

# dim = 800
# obs = []
# gen = ( MVGauss(zeros(dim),eye(dim)), MVGauss(5+zeros(dim),eye(dim)) )
# print gen
# for i in range(10):
#     print i
#     obs.append([])
#     g0 = gen[0].sample((100))
#     g1 = gen[1].sample((200))
#     for o in range(100):
#         obs[i].append(g0[o])
#         obs[i].append(g1[o])
#         obs[i].append(g1[100+o])
#         # print "Added observation "
#         # print o,obs[i]
# h = Hmm(2,dim)
# h.transP[0,0] = 1
# h.transP[1,1] = 1
# for i in range(3):
#     logNormalise(h.transP[i])

# cProfile.run('h.em(obs)','emprof')
# p = pstats.Stats('emprof')
# print p.sort_stats('time').print_stats(20)

# print h.obsP
# print exp(h.transP)
# # print h.obsP
# # print h.transP

