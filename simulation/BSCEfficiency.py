#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu May 25 08:08:51 2017

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

BSCp = 0.01
plen = np.arange(11,127)

PRR = (1-BSCp)**plen
E = ((plen-11)*PRR)/(plen)

fig, ax1 = plt.subplots()
ax2 = ax1.twinx()
ax1.plot(plen,PRR, 'g-',alpha=1)
ax2.plot(plen,E,'b-',alpha=1)
ax1.set_ylim([0.0,1.05])
ax1.tick_params(axis='y', colors='green')
ax1.set_xlabel(u'Packet Size ($l + H$)')
ax1.set_ylabel('Packet reception rate (PRR)', color='g')
ax2.tick_params(axis='y', colors='blue')
ax2.set_ylim([0.0,1.05])
ax2.set_ylabel(r'Transmission efficiency ($\mathcal{E}$)', color='b')
plt.savefig('simFig.pdf',bbox_inches='tight', pad_inches=0)