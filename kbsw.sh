#!/bin/bash

COMMAND="HELP"
DEF_LAYOUTS=2

while test $# -gt 0; do
	case "$1" in
		-h|--help)
			echo "kbsw - simple keyboard layout switcher"
			echo " "
			echo "Usage: "
			echo "  kbsw [options]"
			echo "Options: "
			echo "  -h, --help          - Show this help"
			echo "  -l, --layout=NAME   - Sets keyboard layout"
			echo "  -s, --switch[=NUM]  - Switches keyboard layouts"
			echo "  --show-layouts      - Display all available keyboard layouts"
			echo " "
			echo "Author: Andrey Izman <777.mail@li.ru>"
			echo "License: LGPL 2"
			exit 1
			;;
		-l)
			shift
			if test $# -gt 0; then
				export LAYOUT=$1
				COMMAND="LAYOUT"
			else
				echo "no layout specified"
				exit -1
			fi
			shift
			;;
		--layout*)
			export LAYOUT=`echo $1 | sed -e 's/^[^=]*=//g'`
			COMMAND="LAYOUT"
			shift
			;;
		-s)
			shift
			if test $# -gt 0; then
				export DEF_LAYOUTS=$1
			fi
			COMMAND="SWITCH"
			shift
			;;
		--switch*)
			export DEF_LAYOUTS=$((`echo $1 | sed -e 's/^[^=]*=//g'`))
			COMMAND="SWITCH"
			shift
			;;
		--switch)
			COMMAND="SWITCH"
			shift
			;;
		--show-layouts)
			COMMAND="INFO"
			shift
			;;
		*)
			break
			;;
	esac
done


SOURCES=`gsettings get org.gnome.desktop.input-sources sources`
IFS=', ' read -a SOURCES <<< "${SOURCES:1:-1}"
LAYOUTS=()

for i in "${!SOURCES[@]}"; do
	if test "${SOURCES[i]}" != "('xkb'"; then
		r="${SOURCES[i]}"
		LAYOUTS+=(${r:1:-2})
	fi
done

CURRENT_LAYOUT=`setxkbmap -print | grep xkb_symbols | awk '{print $4}' | awk -F"+" '{print $2}'`

function getLayoutIndex {
	for index in "${!LAYOUTS[@]}"; do
		if test "${LAYOUTS[index]}" == "$1"; then
			echo "${index}"
			exit
		fi
	done
	echo -1
}


if test $COMMAND == "SWITCH"; then
	if test $DEF_LAYOUTS -lt 2; then
		DEF_LAYOUTS=2
	fi
	if test $DEF_LAYOUTS -gt ${#LAYOUTS[@]}; then
		DEF_LAYOUTS=${#LAYOUTS[@]}
	fi

	INDEX=`getLayoutIndex "${CURRENT_LAYOUT}"`
	if [ ${INDEX} -eq $((${DEF_LAYOUTS}-1)) ] || [ ${INDEX} -gt $((${DEF_LAYOUTS}-1)) ]; then
		INDEX=0
	else
		INDEX=$((${INDEX}+1))
	fi
	`gsettings set org.gnome.desktop.input-sources current ${INDEX}`
	exit 1
	
elif test $COMMAND == "LAYOUT"; then
	INDEX=`getLayoutIndex "${LAYOUT}"`
	if test $INDEX -eq -1; then
		echo "no available layout ${LAYOUT}"
		exit -1
	else
		`gsettings set org.gnome.desktop.input-sources current ${INDEX}`
	fi
	exit 1
	
elif test $COMMAND == "INFO"; then
	echo "[ `printf "'%s' " "${LAYOUTS[@]}"`]"
	exit 1
	
else # show help
	bash ${0} -h
fi
