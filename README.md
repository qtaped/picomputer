# README

```
     _ _____                   _           
 ___|_|     |___ _____ ___ _ _| |_ ___ ___ 
| . | |   --| . |     | . | | |  _| -_|  _|
|  _|_|_____|___|_|_|_|  _|___|_| |___|_|  
|_|                   |_|                  

```
<img src="images/piComputer_blender.png" width="100%">

## What the f* is it?
A raspberry Pi Zero 2 with a weird wide screen and a 40% mechanical keyboard in a 3d-printed case, inspired by [lisperati1000](https://github.com/drcode/lisperati-1000-diy).  
I am a graphic designer, not an engineer neither a developer. You have been warn!

> This project is at his early stage. It is not guaranteed to work. But it works. I guess.

## Software

<img src="images/piComputer_screenshot.png" width="100%">

The interface is based on [i3](https://i3wm.org/) + [polybar](https://github.com/polybar/polybar).  
Press _Win + Return_ to open a terminal.  
[Shortcuts list available on the wiki.](https://github.com/qtaped/picomputer/wiki/shortcuts)

### Installation
Install a minimal ~~raspian~~ [Raspberry Pi OS](https://www.raspberrypi.com/software/) on your pi, then clone (or [download](https://github.com/qtaped/picomputer/archive/refs/heads/main.zip)) and run the install bash script.

```
git clone https://github.com/qtaped/picomputer.git
cd picomputer
chmod +X install.sh
./install.sh
```

The script will basically run apt to install some packages (_zsh, vim, xorg-server, i3, polybar, rofi, dunst..._) and link configuration files.  
*It is possible that I forgot some packages...*

### System files
Some tweaks are needed in order to rotate the screen and get the right resolution with graphic acceleration. In both console and graphical mode.  
A GPIO Default State is changed, this allows you to turn on/off the screen by controlling output2 on retroPSU, and always keep it on if piComputer restart.  
Files concerned are in _system_ folder.  
> **At this time, the install script DOES NOT copy those files, you have to do it manually**  
e.g.  
```
sudo cp $HOME/.picomputer/system/00-picomputer.conf /usr/share/X11/xorg.conf.d/

add fbcon=rotate:3 to file: /boot/cmdline.txt (see example)

sudo cp $HOME/.picomputer/system/config.txt /boot/

reboot
```

**Installing _glamor_ drivers may be needed. Run _raspi-config_ to do that.**  
Know what you do, these files can make your screen stop working. Keep a ssh access just in case.

#### You can increase font size in console mode

Edit _/etc/default/console-setup_ to include the following:
```
FONTFACE="TerminusBold"
FONTSIZE="12x24"
```

### Where are the files?
All configuration files and scripts can be found in _$HOME/.picomputer_ once installed (it is a hidden folder). The install script will make symbolic links to standard path.  
_e.g. 	$HOME/.picomputer/config/i3  →  $HOME/.config/i3/config_


## Hardware
### main components
* raspberry pi Zero 2
* 8.8 inch wide screen (IPS 1920x480)
* retroPSU (from[ Helders Game Tech](https://heldergametech.com))
* Vortex CORE mechanical keyboard

### misc.
* USB hub
* lock button (power)
* flat HDMI
* wires & stuff
* 2x 18650

### wiring
_schematic coming soon_


## 3D-Printed Case
_work in progress, STL are coming soon_  
Made using [Blender](https://blender.org). Printed with [PRUSA MINI+](https://www.prusa3d.com/).

## License
[GPL-3.0-or-later](https://www.gnu.org/licenses/gpl-3.0.html) for software, and [CC-BY-4.0](https://creativecommons.org/licenses/by-sa/4.0/) for non-software parts.
