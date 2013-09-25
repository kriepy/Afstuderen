from numpy import *
import matplotlib.pyplot as plt
from matplotlib.patches import Ellipse, Polygon
import sys

class GP:
    def __init__(self, kfunc, kparam, X, t, s2):
        """ Create a Gaussian Process class. The matrix X contains the
        training data points, where each row is one datapoint. The vector t
        contains the corresponding targets"""
        (r,c) = shape(X)
        assert(shape(t)[0] == r)
        assert(shape(t)[1] == 1)
        self.K = matrix([[0.]*r]*r)

        for i in xrange(r):
            for j in xrange(i,r):
                self.K[i,j] = kfunc(X[i],X[j],kparam)
                self.K[j,i] = self.K[i,j]
        for i in xrange(r):
            self.K[i,i] += s2

        self.L = linalg.cholesky(self.K)
        self.alpha = linalg.solve(self.L.T,linalg.solve(self.L,t))
        self.N = r
        self.X = X
        self.kfunc = kfunc
        self.kgfunc = kgfunc
        self.kparam = kparam

        loglik = -.5 *(t.T*self.alpha + self.N*log(2*pi))
        for n in xrange(self.N):
            loglik -= log(self.L[n,n])
        
        print loglik
        
        # print "L:",self.L
        # print "Alpha:",self.alpha

    def loglikgrad(self, kgfunc):
        """For the current values of the kernel function and of the sigma^2,
        return the gradient of the log-likelihood with respect to the kernel
        parameters and sigma^2"""

        linv = linalg.inv(self.L)
        kinv = linv.T * linv    # THIS IS NOT EFFICIENT
        diag = self.alpha * self.alpha - diagonal(kinv)
        for i in range(N)
        
        
    def optimiseParam(self, kparam, kgrad):
        
        
    def predict(self, xstar):
        kstar = matrix([[0.]] * self.N)
        for i in xrange(self.N):
            kstar[i,0] = self.kfunc(xstar, self.X[i], self.kparam)
        fstar = (kstar.T * self.alpha)[0,0]
        v = linalg.solve(self.L,kstar)
        s2 = (self.kfunc(xstar, xstar,self.kparam) - v.T*v)[0,0]
        return (fstar,s2)


def sqexp(x1, x2, theta, l):
    d = x1-x2    
    return theta * exp(-(d * d.T)/(2*l))

def sqexpgrad(x1, x2, theta, l):
    d = x1-x2    
    return theta * exp(-(d * d.T)/(2*l)) * d/(2*l)

def kf(x1,x2, param):
    return sqexp(x1,x2,param[0],param[1])

def kfg(x1,x2, param):
    return sqexpgrad(x1,x2,param[0],param[1])

if __name__=="__main__":

    X = matrix( [
            [ 19.800 ],
            [14.400],
            [15.500],
            [17.200],
            [16.000],
            [17.000],
            [15.400],
            [16.200],
            [18.400],
            [15.000],
            [17.100],
            [14.700],
            [16.000],
            [17.100],
            [20.000 ] ])
    t = matrix([
            [93.300],
            [76.300],
            [75.200],
            [82.600],
            [80.600],
            [83.500],
            [69.400],
            [83.300],
            [84.300],
            [79.600],
            [82.000],
            [69.700],
            [71.600],
            [80.600],
            [88.600]])


    print sys.argv

    gp = GP(kf, [float(sys.argv[1]), float(sys.argv[2])], X,t,10.)


    xs=[]
    ts=[]
    tp=[]
    tm=[]
    d=13    
    while d<21:
        xs.append(d)
        (v,s) = gp.predict(matrix([d]))
        ts.append(v)
        tp.append(v+s)
        tm.append(v-s)
        d+=.1

    N = len(xs)

    p = ndarray([2*N,2])
    for i in xrange(N):
        p[i,0] = xs[i]
        p[i,1] = tm[i]
    for i in xrange(N):
        p[i+N,0] = xs[N-i-1]
        p[i+N,1] = tp[N-i-1]

    fig = plt.figure()
    ax = fig.add_subplot(111)
    ax.plot(xs,ts)
    # ax.plot(xs,tp)
    # ax.plot(xs,tm)
    ax.plot(X.T,t.T,'ro')

    poly = Polygon(p,closed=True,fill=True,color="Red",alpha=.5)
    ax.add_patch(poly)
    # ax.set_xlim(12,22)
    ax.set_ylim(40,140)
    # plt.draw()
    plt.show()

    fig.show()

