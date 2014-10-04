from parser import Parser
from time import time

if __name__ == '__main__':
    start = time()
    Parser().start_parser()
    print "Elapsed time: %s" % (time() - start)
