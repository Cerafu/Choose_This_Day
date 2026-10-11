#!/usr/bin/sh

# Highly portable POSIX implementation eliminating arrays and bashisms
MEMORY_FILE="/tmp/ctd_mem.cfg"

say_portable() {
    # Standard translation framework fallback for printing character loops
    echo "$1" | awk '{
        split($0, chars, "");
        for (i=1; i<=length($0); i++) {
            printf "%s", chars[i];
            system("sleep 0.03");
        }
        printf "\n";
    }'
}

clear
echo "========================================="
echo "   Choose This Day - POSIX Shell Version "
echo "========================================="
echo "System Profile User: $USER"

if [ -f "$MEMORY_FILE" ]; then
    read name < "$MEMORY_FILE"
    echo "Found execution footprint for: $name"
else
    echo "Creating persistent environment profile..."
    echo "$USER" > "$MEMORY_FILE"
fi

say_portable "Processing structural choices..."
