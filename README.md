# KBSW - KeyBoard layout SWitcher for Gnome 

Simple keyboard switcher. Make the change a keyboard layout easy from the shell.  


### Install

Download file `kbsw.sh` and make it exacutable:  
```sh
chmod +x kbsw.sh
```
Optionally you can move it to `/usr/bin` to make it available globally

```sh
mv kbsw.sh /usr/bin/kbsw
```

### Usage

```
kbsw [-h] [-l NAME] [-s [LAYOUTS]] [--layouts]
Options:
  -h, --help                         Show this help
  -l NAME, --layout=NAME             Set keyboard layout
  -s [LAYOUTS], --switch[=LAYOUTS]   Switch keyboard layout between layouts
  --layouts                          Display all available layouts
```
