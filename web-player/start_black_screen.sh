#!/bin/bash
# /home/linaro/web-player/start_black_screen.sh
# Start black screen

export DISPLAY=:0

# Kill old processes
pkill chromium 2>/dev/null
sleep 1

# Start black screen
chromium --kiosk \
  --no-first-run \
  --autoplay-policy=no-user-gesture-required \
  --window-size=1280,720 \
  file:///home/linaro/web-player/black_screen.html &

exit 0