#!/usr/bin/env bash

# Choose_This_Day - Bash Translation
# Original by Cerafin C F (2026)

# Memory File Location
MEMORY_FILE="$HOME/.ctd_memory.txt"

# State Variables
day_count=0
good_total=0
bad_total=0
current_phase=""
name=""

# OS Detection for Audio / Popups
IS_MAC=false
if [[ "$OSTYPE" == "darwin"* ]]; then
    IS_MAC=true
fi

# Function to resize window (Xterm compatible)
resize_window() {
    echo -ne "\e[8;${2};${1}t"
}

# Function to play audio
play_sound() {
    local sound="$1"
    local loops="${2:-1}"
    # Map Windows sound names to basic system beeps/alerts if files don't exist
    if $IS_MAC; then
        (for i in $(seq 1 $loops); do afplay "/System/Library/Sounds/Tink.aiff" 2>/dev/null || echo -e "\a"; sleep 0.2; done) &
    else
        (for i in $(seq 1 $loops); do aplay -q /usr/share/sounds/alsa/Front_Center.wav 2>/dev/null || echo -e "\a"; sleep 0.2; done) &
    fi
}

# Stop background audio tasks
kill_sound() {
    kill $(jobs -p) 2>/dev/null
}

# Typewriter text effect
say_text() {
    local msg="$1"
    for (( i=0; i<${#msg}; i++ )); do
        echo -n "${msg:$i:1}"
        # Context-aware pause adjustments
        case "${msg:$i:1}" in
            .) sleep 0.22 ;;
            ,) sleep 0.14 ;;
            \!|\?) sleep 0.20 ;;
            :) sleep 0.16 ;;
            " ") sleep 0.04 ;;
            *) sleep 0.06 ;;
        esac
    done
    echo ""
}

# System notification
notify_user() {
    local msg="$1"
    if $IS_MAC; then
        osascript -e "display notification \"$msg\" with title \"Choose_This_Day\"" 2>/dev/null
    else
        notify-send "Choose_This_Day" "$msg" 2>/dev/null
    fi
}

# Graphic dialog box output
box_narrator() {
    echo ""
    echo "+------------------------------------------------+"
    echo "| $1 "
    echo "+------------------------------------------------+"
    echo ""
    sleep 3
}

# System Modal Popup
popup_narrator() {
    local msg="$1"
    if $IS_MAC; then
        osascript -e "display dialog \"$msg\" buttons {\"OK\"} default button \"OK\" with title \"Choose_This_Day\" with icon caution" 2>/dev/null
    </# Linux try zenity
    else
        zenity --warning --title="Choose_This_Day" --text="$msg" 2>/dev/null
    fi
}

# Save memory state
save_state() {
    cat <<EOF > "$MEMORY_FILE"
$name
$day_count
$good_total
$bad_total
$current_phase
EOF
}

# Load memory state
load_state() {
    if [ -f "$MEMORY_FILE" ]; then
        {
            read -r name
            read -r day_count
            read -r good_total
            read -r bad_total
            read -r current_phase
        } < "$MEMORY_FILE"
        
        clear
        sleep 2
        play_sound "Alarm10.wav" 1
        say_text "You have been here before."
        sleep 3
        play_sound "chimes.wav" 2
        say_text "I remember you, $name."
        sleep 2
        echo ""
        echo "   1. Resume from where you left"
        echo "   2. Erase the past"
        echo ""
        read -n 1 -p " choice: " choice
        echo ""
        if [ "$choice" = "2" ]; then
            play_sound "Error" 1
            sleep 1
            say_text "hmm...."
            sleep 2
            say_text "The system will watch more closely this time."
            rm -f "$MEMORY_FILE"
            day_count=0
            good_total=0
            bad_total=0
            sleep 2
            clear
            intro_phase
        else
            clear
            play_sound "Speech On" 1
            say_text "Welcome back, $name. The story continues."
            sleep 2
            eval "${current_phase}_phase"
        fi
    fi
}

# Text randomization helper
get_random_index() {
    local max=$1
    echo $(( RANDOM % max ))
}

# Array Shuffling Logic
shuffle_options() {
    map=(1 2 3)
    # Basic fisher-yates style swap for 3 elements
    for i in 1 2; do
        r1=$(( (RANDOM % 3) ))
        r2=$(( (RANDOM % 3) ))
        tmp=${map[$r1]}
        map[$r1]=${map[$r2]}
        map[$r2]=$tmp
    done
}

# Execution Phases
boot_intro() {
    clear
    play_sound "Speech On" 1
    echo -e "\n\n                .d8888b.\n               d88P  Y88b\n               888\n\n"
    sleep 1
    clear
    echo -e "\n                .d8888b.  888                                                 88888888888\n               d88P  Y88b 888                                                     888"
    sleep 3
    clear
    echo "Welcome to Choose This Day..."
    sleep 2
}

intro_phase() {
    current_phase="intro"
    play_sound "Alarm06" 2
    say_text "every day starts the same way."
    sleep 4
    say_text "small choices."
    sleep 2
    say_text "small delays."
    sleep 1
    say_text "most people never notice the pattern."
    sleep 2
    say_text "but this story does."
    kill_sound
    sleep 3
    read -p " your name: " name
    save_state
    clear
    say_text "all right, $name."
    sleep 2
    say_text "even if the system calls you $USER..."
    sleep 3
    clear
    say_text "now watch what happens. "
    sleep 2
    say_text "this is a story about a teen."
    sleep 1
    say_text "you will make his choices."
    sleep 3
    say_text "choose the way you actually would."
    sleep 4
    day_start
}

day_start() {
    ((day_count++))
    clear
    if [ $day_count -eq 1 ]; then friday_phase; fi
    if [ $day_count -eq 2 ]; then saturday_phase; fi
    if [ $day_count -eq 3 ]; then sunday_phase; fi
    evaluate_end
}

friday_phase() {
    current_phase="friday"
    save_state
    say_text "friday arrives like a door that is already half open."
    sleep 3
    say_text "the week is tired."
    sleep 2
    say_text "the mind is tired too."
    sleep 2
    say_text "school, phone, home, sleep."
    sleep 1
    say_text "nothing about the day seems important yet."
    echo -e "\n\nFRIDAY [Morning | 6.00 AM]"
    weekday_flow_phase
}

weekday_flow_phase() {
    current_phase="weekday_flow"
    save_state
    play_sound "Alarm03" 2
    say_text "morning starts before he is ready for it."
    sleep 2
    say_text "the alarm ends."
    sleep 1
    say_text "the phone begins."
    sleep 3
    say_text "one habit enters before the others can defend themselves."
    sleep 2
    kill_sound
    
    shuffle_options
    opts=(
        ""
        "he gets up before the comfort pulls him back in"
        "he checks his phone for a few more minutes before starting the day"
        "he stays in bed and tells himself he still has time"
    )
    
    echo -e "\nwhat does he do? [type the choice number]"
    echo "    1. ${opts[${map[0]}]}"
    echo "    2. ${opts[${map[1]}]}"
    echo "    3. ${opts[${map[2]}]}"
    
    read -n 1 -p "choice: " pick
    echo ""
    real_choice=${map[$((pick-1))]}
    
    if [ $real_choice -eq 1 ]; then
        ((good_total++))
        say_text "he moves before the excuse can grow."
    else
        ((bad_total++))
        say_text "he stays half-awake and fully delayed."
    fi
    school_phase
}

school_phase() {
    current_phase="school"
    save_state
    echo -e "\n\nschool feels the same from the outside."
    sleep 3
    say_text "inside, a task is waiting."
    sleep 2
    say_text "unfinished things always wait more loudly."
    
    shuffle_options
    opts=(
        ""
        "he finishes the task now so it does not follow him home"
        "he tells himself he will deal with it later"
        "he avoids thinking about it and hopes it won't matter much."
    )
    echo -e "\n1. ${opts[${map[0]}]}\n2. ${opts[${map[1]}]}\n3. ${opts[${map[2]}]}"
    read -n 1 -p "choice: " pick
    echo ""
    day_start
}

saturday_phase() {
    current_phase="saturday"
    save_state
    say_text "saturday comes without a bell."
    echo "SATURDAY [Morning]"
    day_start
}

sunday_phase() {
    current_phase="sunday"
    save_state
    say_text "sunday is quieter than the rest."
    day_start
}

evaluate_end() {
    clear
    if [ $bad_total -ge 5 ]; then
        say_text "nothing broke the pattern."
        # Biblical reference block simulation
        say_text "(Proverbs 6:9-11 NLT)"
    elif [ $good_total -ge 5 ]; then
        say_text "something changed. Discipline arrived."
    else
        say_text "Awareness achieved. It is not fixed, but it is seen."
    fi
    credits_phase
}

credits_phase() {
    rm -f "$MEMORY_FILE"
    say_text "Credits: Designed by Cerafin C F (2026)"
    echo "THE END"
    
    # 10s Shutdown hook
    say_text "You have ten seconds. Press C if you wish to stay."
    read -t 10 -n 1 -p "[C/Y]: " choice
    if [[ "$choice" == "C" || "$choice" == "c" ]]; then
        say_text "Shutdown cancelled. Today is still here. Use it."
        # Self-destruct cleanly
        rm -- "$0"
        exit 0
    else
        echo "Shutting down system..."
        # sudo shutdown -h now # Uncomment to actually enforce system power down
        rm -- "$0"
        exit 0
    fi
}

# Entrypoint Execution Logic
resize_window 170 28
if [ -f "$MEMORY_FILE" ]; then
    load_state
else
    boot_intro
    intro_phase
fi
