#!/bin/bash
# /home/linaro/web-player/schedule_check.sh
# Schedule check with duty days consideration

HOLIDAYS_FILE="/home/linaro/web-player/holidays.txt"
ON_DUTY_FILE="/home/linaro/web-player/duty.txt"
LOG_FILE="/tmp/player_schedule.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Holiday check
is_holiday() {
    local today=$(date +%Y-%m-%d)
    
    if [ ! -f "$HOLIDAYS_FILE" ]; then
        return 1
    fi
    
    # Search for today's date (ignore comments)
    if grep -q "^$today" "$HOLIDAYS_FILE"; then
        log "Today is holiday: $today"
        return 0
    fi
    
    return 1
}

# Duty day check
is_on_duty() {
    local today=$(date +%Y-%m-%d)
    
    if [ ! -f "$ON_DUTY_FILE" ]; then
        return 1
    fi
    
    # Search for today's date
    if grep -q "^$today" "$ON_DUTY_FILE"; then
        log "Today is duty day: $today"
        return 0
    fi
    
    return 1
}

# Main schedule check
check_schedule() {
    # Current date/time
    local day_of_week=$(date +%u)  # 1-Mon, 2-Tue, 3-Wed, 4-Thu, 5-Fri, 6-Sat, 7-Sun
    local hour=$(date +%H)
    local minute=$(date +%M)
    local current_time=$((10#$hour * 100 + 10#$minute))
    
    log "Check: day of week=$day_of_week, time=$hour:$minute ($current_time)"
    
    # 1. Holiday check (NON-WORKING)
    if is_holiday; then
        log "Holiday - non-working day"
        return 1  # don't work
    fi
    
    # 2. Duty day check (special schedule: 9:00-14:00)
    if is_on_duty; then
        if [ "$current_time" -ge 900 ] && [ "$current_time" -lt 1400 ]; then
            log "Duty day: 9:00-14:00 - working time"
            return 0  # WORK
        else
            log "Duty day: outside 9:00-14:00 - non-working time"
            return 1  # DON'T WORK
        fi
    fi
    
    # 3. Sunday (NON-WORKING)
    if [ "$day_of_week" -eq 7 ]; then
        log "Sunday - non-working day"
        return 1
    fi
    
    # 4. Saturday (work only 8:00-13:00)
    if [ "$day_of_week" -eq 6 ]; then
        if [ "$current_time" -ge 800 ] && [ "$current_time" -lt 1300 ]; then
            log "Saturday: 8:00-13:00 - working time"
            return 0  # WORK
        else
            log "Saturday: outside 8:00-13:00 - non-working time"
            return 1  # DON'T WORK
        fi
    fi
    
    # 5. Mon-Fri (work 8:00-19:00)
    if [ "$day_of_week" -le 5 ]; then
        if [ "$current_time" -ge 800 ] && [ "$current_time" -lt 1900 ]; then
            log "Weekdays: 8:00-19:00 - working time"
            return 0  # WORK
        else
            log "Weekdays: outside 8:00-19:00 - non-working time"
            return 1  # DON'T WORK
        fi
    fi
    
    # Just in case
    log "Unknown day of week - non-working time"
    return 1
}

# Run check and return result
if check_schedule; then
    log "RESULT: WORKING time (video player)"
    exit 0  # 0 = success = working time
else
    log "RESULT: NON-WORKING time (black screen)"
    exit 1  # 1 = failure = non-working time
fi