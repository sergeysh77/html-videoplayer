#!/bin/bash
# /home/linaro/web-player/player_control.sh
# Player control: video or black screen

SCHEDULE_CHECK="/home/linaro/web-player/schedule_check.sh"
START_PLAYER="/home/linaro/web-player/start_player.sh"
START_BLACK_SCREEN="/home/linaro/web-player/start_black_screen.sh"
LOG_FILE="/tmp/player_control.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Check if chromium is running (any)
is_chromium_running() {
    pgrep -f "chromium.*kiosk" > /dev/null
}

# Check if video player is running
is_player_running() {
    pgrep -f "chromium.*player.html" > /dev/null
}

# Check if black screen is running
is_black_screen_running() {
    pgrep -f "chromium.*black_screen.html" > /dev/null
}

# Stop ALL chromium processes
stop_all_chromium() {
    log "Stopping all chromium processes..."
    pkill -f "chromium.*kiosk" 2>/dev/null
    sleep 3
    
    # Double check
    if is_chromium_running; then
        log "Chromium still running, force stopping..."
        pkill -9 -f "chromium.*kiosk" 2>/dev/null
        sleep 2
    fi
    log "All chromium stopped"
}

start_video() {
    log "Starting video player..."
    stop_all_chromium
    sleep 2
    "$START_PLAYER" &
    sleep 5
    
    if is_player_running; then
        log "Video player started successfully"
    else
        log "ERROR: video player failed to start"
    fi
}

start_black_screen() {
    log "Starting black screen..."
    stop_all_chromium
    sleep 2
    "$START_BLACK_SCREEN" &
    sleep 5
    
    if is_black_screen_running; then
        log "Black screen started successfully"
    else
        log "ERROR: black screen failed to start"
    fi
}

# Main logic
log "=== Schedule check ==="

# Check schedule
if "$SCHEDULE_CHECK"; then
    log "Schedule: WORKING TIME"
    
    if is_player_running; then
        log "Video player already running (no change)"
    elif is_black_screen_running; then
        log "Currently black screen -> switching to video player"
        start_video
    else
        log "Nothing running -> starting video player"
        start_video
    fi
    
else
    log "Schedule: NON-WORKING TIME"
    
    if is_black_screen_running; then
        log "Black screen already running (no change)"
    elif is_player_running; then
        log "Currently video player -> switching to black screen"
        start_black_screen
    else
        log "Nothing running -> starting black screen"
        start_black_screen
    fi
fi