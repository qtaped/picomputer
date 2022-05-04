#!/usr/bin/env python3
# pip3 install adafruit_ads1x15

import time
import datetime
import Adafruit_ADS1x15

adc = Adafruit_ADS1x15.ADS1015()
datenow = str(datetime.datetime.now())

value = adc.read_adc(0, gain=1)
volt = str(round(value/2047*4.096, 2))
level = str(round((value-1599)/4.48, 2))

L = [level, "% ---- ", volt, "V ---- ", datenow, "\n"]

with open("log_ads1015.txt", "a") as file1:
    file1.writelines(L)
