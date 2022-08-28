# piComputer Change Log

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