#!/usr/bin/env python3
# pip install pynput
import RPi.GPIO as GPIO
from pynput.keyboard import Key, Listener

Num = 8

GPIO.setwarnings(False)

GPIO.setmode(GPIO.BCM)
GPIO.setup(Num, GPIO.OUT)

state = GPIO.input(Num)

if state:
    f = open('/sys/class/leds/input0::capslock/brightness', 'w')
    f.write('1')
    GPIO.output(Num, False)
    f.write('1')
    f.close()

def press(key):
    f = open('/sys/class/leds/input0::capslock/brightness', 'w')
    f.write('0')
    GPIO.output(Num, True)
    f.write('0')
    f.close()
    exit()

with Listener(on_press = press) as listener:
    listener.join()
