# piComputer CHANGELOG

## 0.9.0.4
### 2023-04-17

- **modified:   config/Xresources** : invert green and yellow colors
- **modified:   config/vimrc** : change highlights colors
- **modified:   install.sh** : rofi theme symbolic link changed
- **modified:   system/config.txt** : found better hdmi timings
- **modified:   version** : 0.9.0.4


## 0.9.0.3
### 2022-12-30

- **modified:   config/Xresources** : add one-line scrolling in urxvt (shift+arrow)
- **modified:   config/dunstrc** : cleaner
- **modified:   config/i3** : do not lock after n seconds, small corrections
- **modified:   config/polybar** : disable music module (too unstable)
- **modified:   install.sh** : added xinit in packages installation
- **modified:   scripts/battery.py** : fix messages
- **modified:   version** : 0.9.0.3


## 0.9.0.2
### 2022-11-20

- **modified:   config/polybar** : esthetics changes, fixed lenght
- **modified:   scripts/battery.py** : 2 minutes shutdown warning, cancel shutdown if level > warn_level
- **modified:   scripts/sleepscreen.py** : capslock led turn on if screen turn off, et vice et versa.
- **modified:   version** : 0.9.0.2


## 0.9.0.1
### 2022-09-27

- **modified:   config/Xresources** : changed fontsize to size
- **modified:   scripts/battery.py** : cleaner way to display battery bar, refresh to 10 seconds
- **modified:   version** : 0.9.0.1

## 0.9
### 2022-08-22

- **new file:   CHANGELOG.md** : added (this) changelog to the project
- **modified:   install.sh** : ask you if you want to backup if picomputer folder already exist
- **modified:   config/dunstrc** : reduced notification display time, changed critical border color
- **modified:   config/i3** : added powermenu, corrections
- **modified:   config/picomputer.rasi** : changed rofi theme (no longer in fullscreen, smaller font)
- **modified:   config/polybar** : corrections, changed battery module update
- **modified:   scripts/battery.py** : changed the way the piComputer shutdown, detect AC plug, refresh every 5 seconds...
- **modified:   scripts/lockmode.sh** : changed words
- **deleted:    scripts/log_battery.py** : useless
- **new file:   scripts/powermenu.sh** : new power menu
- **deleted:    scripts/poweroff.sh** : replaced by powermenu.sh
- **modified:   scripts/rofi-bluetooth** : fix height
- **modified:   scripts/volume.sh** : corrections
- **modified:   scripts/wifictl.sh** : corrections, ifconfig up/down, edit wpa
- **modified:   system/config.txt** : cleaner version
- **modified:   version** : 0.9

