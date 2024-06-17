#!/usr/bin/env python3
# pip install pynput
import RPi.GPIO as GPIO
import time
from pynput.keyboard import Key, Listener

Num = 8

GPIO.setwarnings(False)

GPIO.setmode(GPIO.BCM)
GPIO.setup(Num, GPIO.OUT)

state = GPIO.input(Num)

if state:
    GPIO.output(Num, False)
    f = open('/sys/class/leds/input0::capslock/brightness', 'w')
    time.sleep(.2)
    f.write('1')
    f.close()

def press(key):
    GPIO.output(Num, True)
    f = open('/sys/class/leds/input0::capslock/brightness', 'w')
    f.write('0')
    time.sleep(3)
    f.close()
    exit()

with Listener(on_press = press) as listener:
    listener.join()
