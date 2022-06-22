#!/usr/bin/env python3

# apt install python3-pip
# pip3 install adafruit_ads1x15

import time
import datetime
import Adafruit_ADS1x15

adc = Adafruit_ADS1x15.ADS1015()

# Choose a gain of 1 for reading voltages from 0 to 4.09V.
#  –   1 = +/-4.096V
# See table 3 in the ADS1015/ADS1115 datasheet for more info on gain.

# value max 2048 (= 4.096V)
# 3.20V ~ 1599
# 2047 - 1599 = 448
# 448/4.48 = 100 (~ percentage)

value = adc.read_adc(0, gain=1)
level = round((value-1599)/4.48, 2)

if level > 80:
  bar= '▪▪▪▪'
elif level > 60:
  bar= '▪▪▪▫'
elif level > 40:
  bar= '▪▪▫▫'
elif level > 20:
  bar= '▪▫▫▫'
elif level > 5:
  bar= '▫▫▫▫'
elif 0 < level < 5:
  bar= '△'
else:
  bar= '▲'

if level < 5:
  print("%{B#FF8700}%{F#232323}","{0} BAT[{1}%]".format(bar,level),"%{B-}%{F-}")
else:
  print("{0} BAT[{1}%]".format(bar,level))
