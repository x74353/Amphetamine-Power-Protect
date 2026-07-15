#!/bin/zsh

emulate -L zsh
setopt ERR_EXIT NO_UNSET PIPE_FAIL
umask 077

readonly LABEL="com.if.Amphetamine.PowerProtectWatchdog"
readonly SOURCE_DIR="${0:A:h}"
readonly INSTALL_DIR="${POWER_PROTECT_INSTALL_DIR:-$HOME/Library/Application Support/Amphetamine/Power Protect Watchdog}"
readonly LAUNCH_AGENT="${POWER_PROTECT_LAUNCH_AGENT:-$HOME/Library/LaunchAgents/$LABEL.plist}"
readonly LAUNCH_AGENT_DIR="${LAUNCH_AGENT:h}"
readonly AMPHETAMINE_APP="${POWER_PROTECT_AMPHETAMINE_APP:-/Applications/Amphetamine.app}"
readonly POWER_PROTECT_SCRIPT="${POWER_PROTECT_SCRIPT_PATH:-$HOME/Library/Application Scripts/com.if.Amphetamine/powerProtect.scpt}"
readonly PMSET_BIN="${POWER_PROTECT_PMSET:-/usr/bin/pmset}"
readonly SUDO_BIN="${POWER_PROTECT_SUDO:-/usr/bin/sudo}"
readonly LAUNCHCTL_BIN="${POWER_PROTECT_LAUNCHCTL:-/bin/launchctl}"
readonly SLEEP_BIN="${POWER_PROTECT_SLEEP:-/bin/sleep}"
readonly UID_VALUE="${POWER_PROTECT_CURRENT_UID:-$(/usr/bin/id -u)}"
readonly ARCHITECTURE="${POWER_PROTECT_ARCHITECTURE:-$(/usr/bin/uname -m)}"

if [[ "$ARCHITECTURE" != "arm64" ]]; then
  print -u2 -- "Power Protect Watchdog is only intended for Apple Silicon Macs."
  exit 1
fi

if [[ ! -d "$AMPHETAMINE_APP" ]]; then
  print -u2 -- "Install Amphetamine before installing Power Protect Watchdog."
  exit 1
fi

if [[ ! -f "$POWER_PROTECT_SCRIPT" ]]; then
  print -u2 -- "Install Power Protect before installing its watchdog."
  exit 1
fi

if ! "$SUDO_BIN" -n -l "$PMSET_BIN" -a disablesleep 1 >/dev/null 2>&1 ||
   ! "$SUDO_BIN" -n -l "$PMSET_BIN" -a disablesleep 0 >/dev/null 2>&1; then
  print -u2 -- "The installed Power Protect sudoers rule does not authorize both required pmset commands."
  exit 1
fi

"$SOURCE_DIR/power-protect-watchdog.zsh" --validate-config "$SOURCE_DIR/config.plist" >/dev/null
if [[ -f "$INSTALL_DIR/config.plist" ]]; then
  "$SOURCE_DIR/power-protect-watchdog.zsh" --validate-config "$INSTALL_DIR/config.plist" >/dev/null || {
    print -u2 -- "The existing watchdog configuration is invalid. Repair or remove it before reinstalling."
    exit 1
  }
fi

"$LAUNCHCTL_BIN" bootout "gui/$UID_VALUE/$LABEL" >/dev/null 2>&1 || true
old_service_state=$("$LAUNCHCTL_BIN" print "gui/$UID_VALUE/$LABEL" 2>/dev/null) || old_service_state=""
if [[ -n "$old_service_state" ]]; then
  print -u2 -- "The existing Power Protect Watchdog could not be stopped; installation was not changed."
  exit 1
fi
/bin/mkdir -p "$INSTALL_DIR" "$LAUNCH_AGENT_DIR"
/usr/bin/install -m 700 "$SOURCE_DIR/power-protect-watchdog.zsh" "$INSTALL_DIR/power-protect-watchdog.zsh"
/usr/bin/install -m 644 "$SOURCE_DIR/com.if.Amphetamine.PowerProtectWatchdog.plist" "$LAUNCH_AGENT"

if [[ ! -f "$INSTALL_DIR/config.plist" ]]; then
  /usr/bin/install -m 600 "$SOURCE_DIR/config.plist" "$INSTALL_DIR/config.plist"
fi

/usr/bin/plutil -lint "$LAUNCH_AGENT" >/dev/null
"$INSTALL_DIR/power-protect-watchdog.zsh" --validate-config "$INSTALL_DIR/config.plist" >/dev/null
"$LAUNCHCTL_BIN" bootstrap "gui/$UID_VALUE" "$LAUNCH_AGENT"
"$SLEEP_BIN" 3
service_state=$("$LAUNCHCTL_BIN" print "gui/$UID_VALUE/$LABEL" 2>/dev/null) || service_state=""

if [[ "$service_state" != *"state = running"* ]]; then
  "$LAUNCHCTL_BIN" bootout "gui/$UID_VALUE/$LABEL" >/dev/null 2>&1 || true
  "$INSTALL_DIR/power-protect-watchdog.zsh" --cleanup ||
    print -u2 -- "Warning: cleanup after failed launch also failed."
  print -u2 -- "Power Protect Watchdog did not remain running. See Console.app for $LABEL."
  exit 1
fi

if ! health_output=$("$INSTALL_DIR/power-protect-watchdog.zsh" --healthcheck 2>&1); then
  "$LAUNCHCTL_BIN" bootout "gui/$UID_VALUE/$LABEL" >/dev/null 2>&1 || true
  "$INSTALL_DIR/power-protect-watchdog.zsh" --cleanup ||
    print -u2 -- "Warning: cleanup after failed health check also failed."
  print -u2 -- "$health_output"
  print -u2 -- "Power Protect Watchdog failed its health check."
  exit 1
fi

print -r -- "Power Protect Watchdog installed."
"$INSTALL_DIR/power-protect-watchdog.zsh" --status
