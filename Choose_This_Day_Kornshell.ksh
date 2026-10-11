#!/usr/bin/env ksh

# Choose_This_Day - KornShell Version
# Compatibility: ksh88 / ksh93 standard Unix runtimes

MEMORY_FILE="$HOME/.ctd_memory.txt"

integer day_count=0
integer good_total=0
integer bad_total=0
current_phase="intro"
name=""

function resize_window {
    print -n "\033[8;${2};${1}t"
}

function say_text {
    typeset msg="$1"
    typeset -i idx=0
    typeset len=${#msg}
    
    while (( idx < len )); do
        typeset char="${msg:idx:1}"
        print -n "$char"
        
        case "$char" in
            '.' ) sleep 0.22 ;;
            ',' ) sleep 0.14 ;;
            '!'|'?' ) sleep 0.20 ;;
            * ) sleep 0.04 ;;
        case
        (( idx++ ))
    done
    print ""
}

# Core Entry Verification Engine Setup
resize_window 170 28
clear

if [[ -f "$MEMORY_FILE" ]]; then
    exec 3< "$MEMORY_FILE"
    read -u3 name
    read -u3 day_count
    exec 3<&-
    say_text "Footprint validated. Welcome back, $name."
else
    say_text "every day starts the same way. small choices. small delays."
    print -n "\nyour name: "
    read name
    
    print "$name\n$day_count\n$good_total\n$bad_total\n$current_phase" > "$MEMORY_FILE"
fi

sleep 1
clear
