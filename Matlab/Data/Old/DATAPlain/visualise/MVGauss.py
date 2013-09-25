from numpy import *

class MVGauss:
    def __init__(self, mu, sigma):
        k = mu.shape[0]
        (sign,logdet) = linalg.slogdet(sigma)
        # print "Sign=",sign
        self.logZ = k*log(2*pi) + logdet
        self.iS = linalg.inv(sigma)
        self.S = sigma
        self.mu = mu

    def update(self, mu, sigma):
        assert(self.mu.shape[0] == mu.shape[0])
        k = mu.shape[0]
        (sign,logdet) = linalg.slogdet(sigma)
        # print "Sign=",sign
        self.logZ = k*log(2*pi) + logdet
        self.iS = linalg.inv(sigma)
        self.S = sigma
        self.mu = mu
        
    def logP(self,x):
        diff = x-self.mu
        v = -.5 * (self.logZ + inner(inner(diff, self.iS), diff))
        return v
    

    def P(self,x):
        return exp(self.logP(x))        

    def __repr__(self):
        return "MVGauss(mu="+str(self.mu.transpose())+"," + str(self.S) + ")"

    def sample(self,dim=(1)):
        x = random.multivariate_normal(self.mu, self.S, dim)
        return x
