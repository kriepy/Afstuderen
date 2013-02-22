from time import time

def tic():
    tic.start = time()

def toc():
    print "Duration: ", time() - tic.start
tic.start=0
