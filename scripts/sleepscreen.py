#!/usr/bin/env python3

import RPi.GPIO as GPIO

Num = 8

GPIO.setwarnings(False)

GPIO.setmode(GPIO.BCM)
GPIO.setup(Num, GPIO.OUT)


state = GPIO.input(Num)

if state:
    GPIO.output(Num, False)
    input("Press enter to turn on screen.")
    GPIO.output(Num, True)
