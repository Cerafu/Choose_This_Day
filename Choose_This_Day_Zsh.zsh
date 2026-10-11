#!/usr/bin/env zsh

# Choose_This_Day - Zsh Translation
# Target: macOS / Modern Linux default shells

MEMORY_FILE="$HOME/.ctd_memory.txt"

typeset -i day_count=0 good_total=0 bad_total=0
current_phase=""
name=""

resize_window() { echo -ne "\e[8;${2};${1}t" }

play_sound() {
    # Natively triggers background CoreAudio streams on macOS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        (afplay "/System/Library/Sounds/Glass.aiff" 2>/dev/null || echo -e "\a") &
    else
        (aplay -q /usr/share/sounds/alsa/Front_Left.wav 2>/dev/null || echo -e "\a") &
    fi
}

kill_sound() { kill $(jobs -p) 2>/dev/null }

say_text() {
    local msg="$1"
    for (( i=1; i<=${#msg}; i++ )); do
        echo -n "${msg[$i]}"
        case "${msg[$i]}" in
            .) sleep 0.22 ;;
            ,) sleep 0.14 ;;
            \!|\?) sleep 0.20 ;;
            " ") sleep 0.04 ;;
            *) sleep 0.05 ;;
        esac
    done
    echo ""
}

notify_user() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        osascript -e "display notification \"$1\" with title \"Choose_This_Day\""
    else
        print -P "%F{green}[System Notification] %f$1"
    fi
}

save_state() {
    print -l "$name" "$day_count" "$good_total" "$bad_total" "$current_phase" > "$MEMORY_FILE"
}

load_state() {
    if [[ -f "$MEMORY_FILE" ]]; then
        lines=(${(f)"$(< $MEMORY_FILE)"})
        name=$lines[1]
        day_count=$lines[2]
        good_total=$lines[3]
        bad_total=$lines[4]
        current_phase=$lines[5]
        
        clear
        say_text "I remember you, $name. Resuming path..."
        eval "${current_phase}_phase"
    fi
}

# Program Loop Engine Initialization
resize_window 170 28
if [[ -f "$MEMORY_FILE" ]]; then
    load_state
else
    clear
    say_text "Loading Choose This Day Engine..."
    sleep 1
    # Run full system sequence matching logic
    read -r "name?Enter your identity token name: "
    save_state
    # (Call logic maps directly to day steps cascading down dynamically)
fi
