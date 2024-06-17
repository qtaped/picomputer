#!/usr/bin/env python3

# apt install python3-pip
# pip3 install adafruit_ads1x15

import Adafruit_ADS1x15
import subprocess
import os
import time

# Choose a gain of 1 for reading voltages from 0 to 4.09V.
#  –   1 = +/-4.096V
# See table 3 in the ADS1015/ADS1115 datasheet for more info on gain.

# value max 2048 (= 4.096V)
# 3.20V ~ 1599
# 2047 - 1599 = 448
# 448/4.48 = 100 (~ percentage)

default_refresh = 5 #refresh battery status every x seconds
shutdown_level = 1 # shutdown piComputer at x%
warning_level = 5

barWidth, icOn, icOff, warn, plug = 5, '■', '┄', '△', '⚡'

def cancelShutdown(msg):
    subprocess.call('shutdown -c --no-wall', shell=True)
    notification = f'dunstify -t 1500 -h {dunstTag} "{msg}" "Shutdown canceled."'
    subprocess.call(notification, shell=True)

while True:
    adc = Adafruit_ADS1x15.ADS1015()
    adc0 = adc.read_adc(0, gain=1) # battery value
    adc1 = adc.read_adc(1) # is it plug to AC?
    level = round((adc0-1599)/4.48) # battery percentage

    dunstTag = 'string:x-dunst-stack-tag:battery'

    # is a shutdown is scheduled? with no-wall option?
    sched_file = '/run/systemd/shutdown/scheduled'
    shutdown_sched = 0
    if os.path.isfile(sched_file):
        with open(sched_file) as f:
            warn_wall = int(f.readlines()[1].rstrip().split("=")[1])
    if os.path.isfile(sched_file) and warn_wall == 0:
        shutdown_sched = 1

    if adc1 < 1024: # picomputer is not plugged to AC
 
        refresh = default_refresh
        nicOn = round((level + 5) / 100 * barWidth)
        if nicOn < 0:nicOn = 0
        nicOff = barWidth - nicOn

        bar = icOn*nicOn + icOff*nicOff

        if shutdown_sched == 1:
          bar = (barWidth-1)*icOff+warn
          with open(sched_file) as f:
              usec_shutdown = int(f.readline().rstrip().split("=")[1]) / 1000000

          current_time = time.time()
          remain = round(usec_shutdown - current_time)
          notification = f'dunstify -u critical -h {dunstTag} "Low battery" "piComputer will shutdown in <b>{remain}s</b> if you do not plug it."'
          subprocess.call(notification, shell=True)
        elif level < shutdown_level:
            subprocess.call('shutdown -h --no-wall +2 2>/dev/null', shell=True)
            notification = f'dunstify -u critical -h {dunstTag} "Low battery" "piComputer will shutdown in <b>2 minutes</b> if you do not plug it."'
            subprocess.call(notification, shell=True)

        if level >= warning_level and shutdown_sched == 1:
            cancelShutdown("Enough power")

        if level < warning_level or shutdown_sched == 1:
            print("%{B#FF8700}%{F#232323}","{0} bat.{1}".format(bar,level),"%{B-}%{F-}", flush=True)
        else:
            print("{0} bat.{1}".format(bar,level), flush=True)

    else: # picomputer is plugged to AC
        refresh = 1
        if shutdown_sched == 1:
            cancelShutdown("AC plugged")
        print("{0} bat.{1}".format((barWidth-1)*icOff+plug,level), flush=True)

    time.sleep(refresh)
