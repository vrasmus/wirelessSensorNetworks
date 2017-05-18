#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu May 18 16:13:06 2017

@author: rv
"""

import numpy as np
from matplotlib import pyplot as plt

from pylab import rcParams
rcParams['figure.figsize'] = 4, 3
rcParams['axes.labelsize'] = 8
rcParams['axes.titlesize'] = 11
rcParams['axes.grid'] = 'on'
rcParams['xtick.labelsize'] = 8
rcParams['ytick.labelsize'] = 8
rcParams['font.size'] = 7

dataFile = 'DPLC35m.txt'
#dataFile = 'DPLC39m.txt'
#dataFile = 'DPLC_45.txt'


with open(dataFile, 'r') as f:
    data = f.read()
      
data = data[:-1]
data = data.split('\n')
data = [i.strip() for i in data]
data = [i.split(' ') for i in data]
data = [[int(i,16) for i in j] for j in data] #Convert all to ints
data = np.array(data)
data = data[:,8:] # Remove header, so only useful information left

size = data[:,2]
size= size[size<101]
time = np.arange(0,2*len(size),2)

"""
--------------------------------------------------------------------------
--------------------------- Create plot-----------------------------------
--------------------------------------------------------------------------
"""

fig, ax1 = plt.subplots()
ax1.set_ylim([5,105])
ax1.set_xlim([0,360])#len(size)*2])
ax1.set_xlabel('Time [s]')
ax1.set_ylabel('Payload size (bytes)')
ax1.plot(time, size)
plt.savefig('testFig.pdf',bbox_inches='tight', pad_inches=0)

#Histogram
bins = np.bincount(size)
binsUsed = np.where(bins != 0)[0]
frequency = bins[binsUsed]/np.sum(bins[binsUsed])

fig, ax1 = plt.subplots()
ax1.set_xlim([5,105])
ax1.stem(binsUsed, frequency)
ax1.set_xlabel('Payload size (bytes)')
ax1.set_ylabel('Frequency')
plt.savefig('histFig.pdf',bbox_inches='tight', pad_inches=0)