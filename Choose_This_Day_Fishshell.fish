#!/usr/bin/env fish

# Choose_This_Day - Fish Shell Version
# Original narrative by Cerafin C F (2026)

set memory_file "$HOME/.ctd_memory.txt"

# Initialize global tracking states
set -g day_count 0
set -g good_total 0
set -g bad_total 0
set -g current_phase "intro"
set -g user_name ""

function resize_window
    echo -ne "\e[8;"$argv[2]";"$argv[1]"t"
end

function say_text
    set -l msg $argv[1]
    # Split string into individual characters natively in Fish
    for i in (seq (string length $msg))
        set -l char (string sub -s $i -l 1 $msg)
        echo -n $char
        
        switch $char
            case '.'
                sleep 0.22
            case ','
                sleep 0.14
            case '!' '?'
                sleep 0.20
            case ' '
                sleep 0.04
            case '*'
                # Random range tracking delay emulator
                sleep 0.05
        end
    end
    echo ""
end

function save_state
    echo $user_name > $memory_file
    echo $day_count >> $memory_file
    echo $good_total >> $memory_file
    echo $bad_total >> $memory_file
    echo $current_phase >> $memory_file
end

# Engine Launch Block
resize_window 170 28
clear

if test -f $memory_file
    set -l lines (cat $memory_file)
    set user_name $lines[1]
    set day_count $lines[2]
    say_text "Footprint detected. Welcome back to the loop, $user_name."
else
    say_text "every day starts the same way."
    sleep 1
    say_text "small choices. small delays."
    
    echo ""
    read -p "echo 'your name: '" user_name
    set current_phase "day_flow"
    save_state
end

sleep 1
clear
say_text "Watch closely what happens next..."
