#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri May 12 10:41:13 2017

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


files = ['35m_p7_.txt', 'LoS/35m.txt','LoS/35_2m.txt']
fig, ax1 = plt.subplots()
ax2 = ax1.twinx()

for iFile, dataFile in enumerate(files):
#dataFile = 'LoS/35m.txt'
#dataFile = '../nesC/multipath_closedDoor.txt'

    with open(dataFile, 'r') as f:
        data = f.read()
          
    """
    --------------------------------------------------------------------------
    ----------------------- Process measured data ----------------------------
    --------------------------------------------------------------------------
    """
       
    data = data[:-1]
    data = data.split('\n')
    data = [i.strip() for i in data]
    data = [i.split(' ') for i in data]
    data = [[int(i,16) for i in j] for j in data] #Convert all to ints
    data = np.array(data)
    data = data[:,8:] # Remove header, so only useful information left
    
    dataInd = np.where(np.diff(data[:,2],1)==-10)[0]
    dataInd = [i for i in dataInd if i>np.where(np.diff(data[:,2],1)==-155)[0][0]]
    dataInd = np.append(dataInd,np.shape(data)[0]-1)
    
    dataPoints = data[dataInd]
    dataPoints[:,1] = dataPoints[:,1] + 256*dataPoints[:,0]
    dataPoints = np.delete(dataPoints,0,axis=1)
    dataPoints[1:,0] = np.diff(dataPoints,axis=0)[:,0]
    dataPoints = np.fliplr(np.flipud(dataPoints)) #now col0 is packet len, col1 is packets received
    dataPoints = dataPoints.astype(np.float64)
    
    PayloadLen = dataPoints[:,0]
    PRR = dataPoints[:,1]/1000 #Calculate PRR from num packets received (of 1000)
    TXEff = PayloadLen*PRR/(PayloadLen + 11) #calculate transmission efficiency 11 bytes overhead (PHY+MAC headers)
    if iFile == 0:    
        PRR_ = PRR
        TXEff_ = TXEff
    elif iFile == (len(files)-1):
        PRR_ = PRR_ + PRR
        PRR_ = PRR_ /len(files)
        TXEff_ = TXEff_ + TXEff
        TXEff_ = TXEff_/len(files)
        ax1.plot(PayloadLen,PRR_, 'g-x',alpha=1)
        ax2.plot(PayloadLen,TXEff_,'b-x',alpha=1)
    else:
        PRR_ = PRR_ + PRR
        TXEff_ = TXEff_ + TXEff
        
    """
    --------------------------------------------------------------------------
    --------------------------- Create plot-----------------------------------
    --------------------------------------------------------------------------
    """
        
    ax1.plot(PayloadLen,PRR, 'g-x',alpha=0.20)
    ax2.plot(PayloadLen,TXEff,'b-x',alpha=0.20)

ax1.set_ylim([0.4,1.05])
ax1.tick_params(axis='y', colors='green')
ax1.set_xlabel('Payload Size')
ax1.set_ylabel('Packet reception rate (PRR)', color='g')
ax2.tick_params(axis='y', colors='blue')
ax2.set_ylim([0.4,1.05])
ax2.set_ylabel(r'Transmission efficiency ($\mathcal{E}$)', color='b')
plt.savefig('testFig.pdf',bbox_inches='tight', pad_inches=0)