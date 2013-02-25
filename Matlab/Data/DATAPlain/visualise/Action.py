

class Action:

    _MAX_LEN = 10              # At most 10 events
    
    def __init__(self):
        self.p = [ 0 for x in range(1,_MAX_LEN) ]

    def logProb(self,events):
        return sum([x * p for x in events, p in self.logp])

