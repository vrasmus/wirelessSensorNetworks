#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed May 31 08:16:42 2017

@author: rv
"""

import numpy as np
from matplotlib import pyplot as plt
from pylab import rcParams
rcParams['figure.figsize'] = 7, 3
rcParams['axes.labelsize'] = 8
rcParams['axes.titlesize'] = 11
rcParams['axes.grid'] = 'on'
rcParams['xtick.labelsize'] = 8
rcParams['ytick.labelsize'] = 8
rcParams['font.size'] = 7

""" Parameter initiation """
nTimesteps = 10000
p_BSC = 0.01 # Bit error probability in BSC
PPT = [100,10000]  # Packets Per Timestep
compareNum = 3 # number of steps in steady state before search

""" Setup """
np.random.seed(1)
plen = np.zeros((nTimesteps+2,len(PPT)),dtype=int)
PRR = np.zeros((nTimesteps+1,len(PPT)))
E = np.zeros((nTimesteps+1,len(PPT)))

def new_plen(E_new,E_old,plen_new,plen_old, D=0.1):
    """ Determines new packet length according to formula in report """
    d = (E_new-E_old)*(plen_new-plen_old)
    if d < -D and plen_new > 10:
        return plen_new - 10
    elif d > D and plen_new < 100:
        return plen_new + 10
    else:
        return plen_new

""" Initial conditions """
plen[0] = 10
plen[1] = 20
""" Loop through simulation """
for pi, PPT_ in enumerate(PPT):
    for i in range(1,1+nTimesteps):
        BE = np.random.uniform(size=(11+plen[i,pi],PPT_))
        PE = np.sum(BE<p_BSC,axis=0)
        PRR[i,pi] = np.sum(PE==0)/PPT_
        E[i,pi] = ((plen[i,pi])*PRR[i,pi])/(plen[i,pi]+11)
        if (np.diff(plen[i+1-compareNum:i+1,pi])==0).all():
            if plen[i,pi] == 100:
                plen[i+1,pi] = plen[i,pi] - 10
            elif plen[i,pi] < 100:
                plen[i+1,pi] = plen[i,pi] + 10
        else:
            plen[i+1,pi] = new_plen(E[i,pi],E[i-1,pi],plen[i,pi],plen[i-1,pi])
            
            
"""Create histogram """
fig, (ax1,ax2) = plt.subplots(ncols=2,sharex=True,sharey=True)

bins = np.bincount(plen[:,0])
binsUsed = np.where(bins != 0)[0]
frequency = bins[binsUsed]/np.sum(bins[binsUsed])
ax1.stem(binsUsed, frequency,linefmt='b-', markerfmt='bo', basefmt='b-',label=r'$N_{packets} = 100$')

bins = np.bincount(plen[:,1])
binsUsed = np.where(bins != 0)[0]
frequency = bins[binsUsed]/np.sum(bins[binsUsed])
ax2.stem(binsUsed, frequency,linefmt='b-', markerfmt='bo', basefmt='b-',label=r'$N_{packets} = 10000$')

ax1.legend()
ax2.legend()
ax1.set_xlim([5,105])
ax1.set_xlabel('Payload size (bytes)')
ax2.set_xlabel('Payload size (bytes)')
ax1.set_ylabel('Frequency')
plt.savefig('DPLCsim.pdf',bbox_inches='tight', pad_inches=0)