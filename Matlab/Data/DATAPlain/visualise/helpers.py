import numpy

def logGauss(x,mu,v):
    d = x-mu
    return -.5*(numpy.log(2.*numpy.pi*v) + d*d/v)

    
def log_sum_exp(logA, logB):
    if logA < logB:
        if numpy.isinf(logA) or logB-logA > 50.:
            return logB
        return logB + numpy.log(1 + numpy.exp(logA - logB))
    else:
        if numpy.isinf(logB) or logA-logB > 50:
            return logA
        return logA + numpy.log(1 + numpy.exp(logB - logA))
