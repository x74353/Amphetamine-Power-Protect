-- ENABLE/DISABLE POWER PROTECT
on enableDisablePowerProtect(inputString)
	
	if powerProtectSudoFileExists() then
		
		set resultString to ""
		
		-- "ENABLE" MEANS TO ENABLE POWER PROTECT
		-- ENABLING POWER PROTECT MEANS DISABLING SLEEP WHEN THE MAC'S BUILT-IN DISPLAY IS CLOSED
		if inputString is "enable" then
			
			try
				
				-- CANCEL A PENDING DEFERRED DISABLE (SEE lidSleepHelper)
				try
					do shell script "/bin/sh -c " & quoted form of lidSleepHelper() & " powerProtect enable"
				end try
				
				-- IF THE SUDO OVERRIDE FILE HAS BEEN INSTALLED
				if powerProtectSudoFileExists() then
					
					-- EXECUTE THE COMMAND USING THE AUTHENTICATION-LESS METHOD
					do shell script "sudo pmset -a disablesleep 1"
					
				else
					
					-- EXECUTE THE COMMAND USING THE AUTHENTICATION METHOD
					do shell script "pmset -a disablesleep 1" with administrator privileges
					
				end if
				
				set resultString to "success"
				
			on error
				
				set resultString to "fail"
				
			end try
			
			-- "DISABLE" MEANS TO DISABLE POWER PROTECT
			-- DISABLING POWER PROTECT MEANS ENABLING SLEEP WHEN THE MAC'S BUILT-IN DISPLAY IS CLOSED
		else if inputString is "disable" then
			
			-- RE-ENABLE SLEEP IN THE BACKGROUND, 20 SECONDS LATER, AND SLEEP NOW IF THE LID IS ALREADY CLOSED (SEE lidSleepHelper)
			try
				
				do shell script "/bin/sh -c " & quoted form of lidSleepHelper() & " powerProtect disable > /dev/null 2>&1 &"
				
				set resultString to "success"
				
			on error
				
				set resultString to "fail"
				
			end try
			
		end if
		
	else
		
		return "success" -- return success if the power protect sudo override is not installed otherwise amphetamine will notify the user of the failure
		
	end if
	
	
end enableDisablePowerProtect

-- INSTALL THE CONFIGURATION FILE TO MAKE POWER PROTECT AUTHENTICATION-LESS
on installPowerProtectSudoOverride(inputString)
	
	try
		
		-- CREATE THE AUTHENTICATION OVERRIDE FILE AND THEN MOVE IT TO /etc/sudoers.d
		do shell script "touch ~/Library/Containers/com.if.Amphetamine/Data/Library/Application\\ Support/Amphetamine/amphetamine_PowerProtect; echo \"Cmnd_Alias PMSET_AMPHETAMINE= /usr/bin/pmset -a disablesleep 1, /usr/bin/pmset -a disablesleep 0" & linefeed & "%admin ALL=(ALL) NOPASSWD: PMSET_AMPHETAMINE\" >> ~/Library/Containers/com.if.Amphetamine/Data/Library/Application\\ Support/Amphetamine/amphetamine_PowerProtect; mv ~/Library/Containers/com.if.Amphetamine/Data/Library/Application\\ Support/Amphetamine/amphetamine_PowerProtect /etc/sudoers.d/amphetamine_PowerProtect || touch ~/Desktop/amphetamine_PowerProtect; echo \"Cmnd_Alias PMSET_AMPHETAMINE= /usr/bin/pmset -a disablesleep 1, /usr/bin/pmset -a disablesleep 0" & linefeed & "%admin ALL=(ALL) NOPASSWD: PMSET_AMPHETAMINE\" >> ~/Desktop/amphetamine_PowerProtect; mv ~/Desktop/amphetamine_PowerProtect /etc/sudoers.d/amphetamine_PowerProtect" with administrator privileges
		
		return "success"
		
	on error
		
		return "fail"
		
	end try
	
end installPowerProtectSudoOverride


-- CHECK TO SEE IF THE POWER PROTECT AUTHENTICATION-LESS CONFIGURATION FILE EXISTS
on powerProtectSudoFileExists()
	
	tell application "System Events"
		
		if exists file "/etc/sudoers.d/amphetamine_PowerProtect" then
			
			return true
			
		else
			
			return false
			
		end if
		
	end tell
	
end powerProtectSudoFileExists


-- SHELL SCRIPT RUN BY enableDisablePowerProtect, ARGUMENT "enable" OR "disable"
-- WHY "disable" IS DEFERRED AND THEN SLEEPS THE MAC:
-- 1. MACOS ONLY EVALUATES CLAMSHELL SLEEP WHEN THE LID CLOSES OR POWER IS ATTACHED. IF THE LID IS CLOSED ON AC (SLEEP DISABLED)
--    AND THE ADAPTER IS THEN UNPLUGGED, "pmset -a disablesleep 0" ALONE LEAVES THE MAC AWAKE WITH THE LID CLOSED, E.G. IN A BAG.
-- 2. POWER ADAPTERS CAN DROP OUT FOR A FEW SECONDS. RE-ENABLING SLEEP IMMEDIATELY MEANS THE MAC CLAMSHELL-SLEEPS WHEN POWER
--    RETURNS, AND AMPHETAMINE DOESN'T DISABLE SLEEP AGAIN. WAITING 20 SECONDS LETS A RESTARTED SESSION CANCEL THE DISABLE.
on lidSleepHelper()
	
	return "# Usage: sh -c \"$script\" powerProtect enable|disable
#
#   enable   Cancel a pending deferred disable.
#   disable  Wait 20 s, then run `pmset -a disablesleep 0` unless Amphetamine has restarted its session
#            (the power adapter came back). Then, if the lid is closed on battery, sleep now: macOS
#            only evaluates clamshell sleep when the lid closes or power is attached, so re-enabling
#            sleep with the lid already closed leaves the Mac awake. If the lid is closed on AC, wait
#            for unplug, lid open or a new session.
#
# Log: log show --last 1h --predicate 'eventMessage CONTAINS \"AmphetaminePowerProtect\"'

GEN_FILE=\"$HOME/Library/Caches/com.if.Amphetamine.PowerProtect.pending\"  # \"<epoch>.<pid>\" of the one pending disable
DELAY=20

log() { /usr/bin/logger \"AmphetaminePowerProtect: $*\"; }  # unified logging drops logger -t tags
lid_closed() { [ \"$(/usr/sbin/ioreg -r -k AppleClamshellState -d 1 | /usr/bin/awk '/AppleClamshellState/{print $3; exit}')\" = \"Yes\" ]; }
on_battery() { /usr/bin/pmset -g batt | /usr/bin/head -1 | /usr/bin/grep -q \"Battery Power\"; }
sleep_disabled() { [ \"$(/usr/bin/pmset -g | /usr/bin/awk '/SleepDisabled/{print $2}')\" = \"1\" ]; }
superseded() { [ \"$(/bin/cat \"$GEN_FILE\" 2>/dev/null)\" != \"$gen\" ]; }
pending_alive() { pid=$(/usr/bin/cut -d. -f2 \"$GEN_FILE\" 2>/dev/null) && [ -n \"$pid\" ] && /bin/kill -0 \"$pid\" 2>/dev/null; }
# Amphetamine skips enable while SleepDisabled is still 1 (as it is during the delay), so a re-plug
# shows up only as an Amphetamine assertion created after the disable call.
session_restarted() {
	age=$(/usr/bin/pmset -g assertions | /usr/bin/awk '/\\(Amphetamine\\):/ && /PreventUserIdleSystemSleep/ {split($4,a,\":\"); s=a[1]*3600+a[2]*60+a[3]; if(m==\"\"||s<m)m=s} END{print m}')
	[ -n \"$age\" ] && [ $(( $(/bin/date +%s) - age )) -ge \"$t0\" ]
}

case \"$1\" in
enable)
	/bin/rm -f \"$GEN_FILE\"
	exit 0 ;;
disable) ;;
*)
	exit 2 ;;
esac

# Amphetamine repeats disable every 5 s while SleepDisabled is still 1; only the first call waits.
pending_alive && exit 0
gen=\"$(/bin/date +%s).$$\"
/bin/mkdir -p \"$(/usr/bin/dirname \"$GEN_FILE\")\"
echo \"$gen\" > \"$GEN_FILE\"
trap '[ \"$(/bin/cat \"$GEN_FILE\" 2>/dev/null)\" = \"$gen\" ] && /bin/rm -f \"$GEN_FILE\"' EXIT
t0=$(/bin/date +%s)
/bin/sleep \"$DELAY\"
superseded && { log \"disable cancelled by enable\"; exit 0; }
session_restarted && { log \"disable cancelled: Amphetamine session restarted (power adapter reconnected)\"; exit 0; }

if sleep_disabled; then
	err=$(/usr/bin/sudo -n /usr/bin/pmset -a disablesleep 0 2>&1)
	sleep_disabled && { log \"disablesleep 0 failed: $err\"; exit 1; }
	log \"disablesleep 0\"
fi

waited=0
while lid_closed && ! on_battery && ! superseded && ! session_restarted && [ $waited -lt 86400 ]; do
	/bin/sleep 15; waited=$((waited + 15))
done

if superseded || session_restarted || ! on_battery || ! lid_closed; then exit 0; fi
log \"lid closed on battery; sleeping\"
# pmset sleepnow can print an error and still exit 0
out=$(/usr/bin/pmset sleepnow 2>&1); rc=$?
case \"$rc:$out\" in
0:*rror*|[1-9]*) /usr/bin/osascript -e 'tell application \"System Events\" to sleep' ;;
esac
"
	
end lidSleepHelper
