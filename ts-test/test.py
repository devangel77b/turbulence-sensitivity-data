#!\usr\bin\python
"""Load force and anemometer data and make some plots to examine turbulence

Dennis Evangelista
October 2011
"""

from scipy import *
#import numpy as np
#import matplotlib.pyplot as plt

# load sonic anemometer and force sensor data
sonic = genfromtxt("fixed_canna-6ms-med.txt")
# construct time vector
t = arange(size(sonic[:,1]))*1.0/32.0

# Predict vortex shedding frequency
V = abs(mean(sonic[:,1]))
D = 0.038
Re = V*D/15e-6
St = 0.198*(1-19.7/Re)
freq = St*V/D


#figure 1
#plot(t,sonic[:,1])
#xlabel("Time, s")
#ylabel("Velocity, m/s")
#show()

#figure 2
vtwiddle = sonic[:,1]-mean(sonic[:,1])
psd(vtwiddle,Fs=32,NFFT=1024,noverlap=512)
semilogx()





# For some reason genfromtxt is failing on this csv file?!
nano = genfromtxt("canna-6ms-med.csv",delimiter=',',skip_header=1)
tf = arange(size(nano[:,0]))*1.0/625.0
ftwiddle = nano[:,0]-mean(nano[:,0])
psd(ftwiddle,Fs=625)


