# html-videoplayer
This is an automated video playback system designed for Asus TinkerBoard.

To start the system, add these tasks to crontab:<br/>

@reboot sleep 90 && /home/linaro/web-player/player_control.sh<br/>
*/15 * * * * /home/linaro/web-player/player_control.sh
