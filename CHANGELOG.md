## 0.9.5
### 2024-06-17

- **modified:   README.md** : added 3D render
- **modified:   assets/_images_**: mv images to assets, optimized compression
- **new file:   assets/shortcuts.md** : shortcuts list (win + F1)
- **modified:   config/i3** : daemonize urxvt, corrections
- **modified:   config/polybar** : adding weather module (optionnal)
- **modified:   config/vimrc** : toggle crosshair, line number
- **modified:   install.sh** : check for vim as default (RIP Bram), mkdir ~/images, fzf package
- **modified:   scripts/battery.py** : refresh status every second when plug
- **modified:   scripts/sleepscreen.py** : add delays
- **modified:   system/config.txt** : overcloking by default, remove i2c (added by install)
- **modified:   version** : 0.9.5


## 0.9.4
### 2023-06-12

- **new file:   setup.sh** : script to run before install (see [wiki](https://github.com/qtaped/picomputer/wiki/installation))
- **modified:   version** : 0.9.4


## 0.9.3.1
### 2023-06-05

- **modified:   scripts/wifictl.sh** : adjustments, check if network is already in conf file
- **modified:   version** : 0.9.3.1


## 0.9.3
### 2023-06-03

- **modified:   config/i3** : add floating wifi manager
- **modified:   config/rofi** : picomputer > picomputer.rasi
- **modified:   install.sh** : change log location
- **modified:   scripts/wifictl.sh** : complete redesign using native tools
- **modified:   version** : 0.9.3


## 0.9.2.3
### 2023-05-23

- **modified:   scripts/powermenu.sh** : add dpms toggle with xset
- **modified:   version** : 0.9.2.3


## 0.9.2.2
### 2023-05-20

- **modified:   install.sh** : check if i2c is enabled
- **modified:   version** : 0.9.2.2


## 0.9.2.1
### 2023-05-18

- **modified:   config/i3** : fix permissions for capslock led state
- **new file:   config/urxvt-keyboard-select** : add keyboard selection like vim in terminal
- **modified:   config/zshrc** : merged with zshrc.local
- **deleted:    config/zshrc.local** : you can now use ~/.zshrc.local for your own customisations
- **modified:   install.sh** : update, corrections, check if urxvt is set as default terminal
- **modified:   README.md** : add a simple message
- **modified:   version** : 0.9.2.1


## 0.9.2
### 2023-05-17

- **renamed:    config/picomputer.rasi -> config/rofi.rasi**
- **modified:   install.sh** : complete redesign of the interface using whiptail as dialog box
- **modified:   version** : 0.9.2


## 0.9.1
### 2023-04-29

- **modified:   install.sh** : added urxvt in packages installation
- **modified:   version** : 0.9.1


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
