#!/usr/bin/env tcsh

# Choose_This_Day - Tcsh Version

set memory_file = "\$HOME/.ctd_memory.txt"

set day_count = 0
set good_total = 0
set bad_total = 0
set current_phase = "intro"
set user_name = ""

# Window sizing ANSI pass-through sequence injection
echo -n "\033[8;28;170t"
clear

# Simulating typewriter display loop framework without modern array support
alias say_text 'echo "\!*"'

if ( -e \$memory_file ) then
    set lines = `cat $memory_file`
    set user_name = \$lines[1]
    say_text "Footprint confirmed. Welcome back, \$user_name."
else
    say_text "every day starts the same way."
    say_text "small choices. small delays."
    
    echo -n "\nyour name: "
    set user_name = \$<
    
    echo "\(user_name" > \)memory_file
    echo "\(day_count" >> \)memory_file
endif

sleep 1
clear
say_text "The script thread resumes..."
