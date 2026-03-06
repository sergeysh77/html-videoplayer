# html-videoplayer

To start the system, add these tasks to crontab:<br>
<pre>
@reboot sleep 90 && /home/linaro/web-player/player_control.sh
*/15 * * * * /home/linaro/web-player/player_control.sh
</pre>

How the System Works?<br/>
The system operates based on a smart schedule that determines when to broadcast videos and when to show a black screen.

Operating Schedule Overview:<br><pre>
Day                 Working Hours	      Status
Monday - Friday	    8:00 - 19:00	  Full working day
Saturday	        8:00 - 13:00	  Shortened working day
Sunday	               Closed	      Non-working day
</pre>
<br/>
Special Cases That Override Normal Schedule:<pre>
Case	                  Effect	                                    Example
Holidays	System does NOT work even if it's a weekday	    January 1st (New Year) - even if Monday
Duty Days	System DOES work even if it's a weekend	        Working on a Sunday when duty calls
</pre>
Core Logic Explained:
1. Normal Weekday Operation (Monday-Friday)<br>
Calendar shows: Monday, 10:00 AM<br>
System CHECK: Is it a holiday? → NO<br>
System CHECK: Is it a duty day? → NO<br>
System CHECK: Is it within 8:00-19:00? → YES<br>
RESULT: VIDEO BROADCAST ACTIVE<br>

2. Normal Saturday Operation<br>
Calendar shows: Saturday, 10:00 AM<br>
System CHECK: Is it a holiday? → NO<br>
System CHECK: Is it a duty day? → NO<br>
System CHECK: Is it within 8:00-13:00? → YES<br>
RESULT: VIDEO BROADCAST ACTIVE<br>

3. Normal Sunday Operation<br>
Calendar shows: Sunday, 12:00 PM<br>
System CHECK: Is it a duty day? → NO<br>
RESULT: BLACK SCREEN (non-working)<br>

4. Holiday Example (Non-working)<br>
Calendar shows: Monday, January 1st, 10:00 AM<br>
System CHECK: Is it a holiday? → YES (New Year)<br>
RESULT: BLACK SCREEN (even though it's Monday)<br>

5. Duty Day Example (Working on Weekend)<br>
Calendar shows: Saturday, January 3rd, 10:00 AM<br>
System CHECK: Is it a holiday? → NO<br>
System CHECK: Is it a duty day? → YES (listed in duty.txt)<br>
System CHECK: Duty day hours 9:00-14:00? → YES<br>
RESULT: VIDEO BROADCAST ACTIVE (even though it's Saturday)<br>

Why Black Screen During Non-Working Hours?
The TV Problem.
Some TV models automatically turn off when they lose HDMI signal. This creates two problems:
- TV powers off completely
- No picture at all
- Manual intervention needed, someone has to turn TV back on

The Solution: Black Screen Broadcast.<br>
During non-working hours, the system continues broadcasting - but broadcasts a pure black screen.
