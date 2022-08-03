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
    GPIO.output(Num, False)

def press(key):
    GPIO.output(Num, True)
    exit()
with Listener(on_press = press) as listener:
    listener.join()

