#!/bin/bash
# /home/linaro/web-player/start_player.sh
# Start video player

export DISPLAY=:0

# Kill old Chromium processes
pkill chromium 2>/dev/null
sleep 1

# Simply start Chromium and exit
chromium --kiosk \
  --no-first-run \
  --autoplay-policy=no-user-gesture-required \
  --window-size=1280,720 \
  --disable-cursor-handler \
  file:///home/linaro/web-player/player.html &

exit 0