import RPi.GPIO as GPIO

Num = int(input("GPIO number: "))
State = input("on/off ")

GPIO.setwarnings(False)

GPIO.setmode(GPIO.BCM)
GPIO.setup(Num, GPIO.OUT)
if State == ("on"):
    GPIO.output(Num, True)
elif State == ("off"):
    GPIO.output(Num,False)

