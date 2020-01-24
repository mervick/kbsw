#!/bin/bash


COMMAND="HELP"
DEF_LAYOUTS=2


while test $# -gt 0; do
    case "$1" in
        -h|--help)
            echo "kbsw - keyboard layout switcher for Gnome"
            echo " "
            echo "Usage: "
            echo "  kbsw [-h] [-l NAME] [-s [NUM]] [--layouts]"
            echo "Options: "
            echo "  -h, --help                         Show this help"
            echo "  -l NAME, --layout=NAME             Set keyboard layout"
            echo "  -s [LAYOUTS], --switch[=LAYOUTS]   Switch keyboard layout between layouts"
            echo "  --layouts                          Display all available layouts"
            echo " "
            echo "Author: Andrey Izman <izmanw@gmail.com>"
            echo "License: LGPL 3"
            exit 0
            ;;
        -l)
            shift
            if test $# -gt 0; then
                export LAYOUT=$1
                COMMAND="LAYOUT"
            else
                echo "no layout specified"
                exit 1
            fi
            shift
            ;;
        --layout=*)
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
        --switch=*)
            export DEF_LAYOUTS=$((`echo $1 | sed -e 's/^[^=]*=//g'`))
            COMMAND="SWITCH"
            shift
            ;;
        --switch)
            COMMAND="SWITCH"
            shift
            ;;
        --layouts)
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

function getLayoutIndex {
    args=("$@")
    res=-1
    for i in "${!args[@]}"; do
        for index in "${!LAYOUTS[@]}"; do
            if test "${LAYOUTS[index]}" == "${args[i]}"; then
                res=$index
                break 2
            fi
        done
    done
    echo $res
}


if test $COMMAND == "SWITCH"; then
    if test $DEF_LAYOUTS -lt 2; then
        DEF_LAYOUTS=2
    fi
    if test $DEF_LAYOUTS -gt ${#LAYOUTS[@]}; then
        DEF_LAYOUTS=${#LAYOUTS[@]}
    fi

    xkb_symbols=`setxkbmap -print | grep xkb_symbols | awk '{print $4}'`
    xkb_symbols_2=`echo "${xkb_symbols}" | awk -F"+" '{print $2}'`
    xkb_symbols_3=`echo "${xkb_symbols}" | awk -F"+" '{print $3}' | sed -e 's/[^a-zA-Z]\+//g'`

    INDEX=$(gsettings get org.gnome.desktop.input-sources current | sed -e 's/.*\s//g')

    if test $INDEX -ge $((${DEF_LAYOUTS}-1)); then
        INDEX=0
    else
        INDEX=$((${INDEX}+1))
    fi
    `gsettings set org.gnome.desktop.input-sources current ${INDEX}`
elif test $COMMAND == "LAYOUT"; then
    INDEX=`getLayoutIndex "${LAYOUT}"`
    if test $INDEX -eq -1; then
        echo "no available layout ${LAYOUT}"
        exit 2
    else
        `gsettings set org.gnome.desktop.input-sources current ${INDEX}`
    fi
elif test $COMMAND == "INFO"; then
    echo "[ `printf "'%s' " "${LAYOUTS[@]}"`]"
    exit 0
else # show help
    bash ${0} -h
fi
