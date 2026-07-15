#!/bin/zsh

emulate -L zsh
setopt NO_UNSET PIPE_FAIL

readonly LABEL="com.if.Amphetamine.PowerProtectWatchdog"
readonly INSTALL_DIR="${POWER_PROTECT_INSTALL_DIR:-$HOME/Library/Application Support/Amphetamine/Power Protect Watchdog}"
readonly CONFIG_FILE="$INSTALL_DIR/config.plist"
readonly OWNED_MARKER="$INSTALL_DIR/sleep-disabled-owned"
readonly LAUNCH_AGENT="${POWER_PROTECT_LAUNCH_AGENT:-$HOME/Library/LaunchAgents/$LABEL.plist}"
readonly PMSET_BIN="${POWER_PROTECT_PMSET:-/usr/bin/pmset}"
readonly SUDO_BIN="${POWER_PROTECT_SUDO:-/usr/bin/sudo}"
readonly LAUNCHCTL_BIN="${POWER_PROTECT_LAUNCHCTL:-/bin/launchctl}"
readonly UID_VALUE="${POWER_PROTECT_CURRENT_UID:-$(/usr/bin/id -u)}"

sleep_disabled_value() {
  local settings
  settings=$("$PMSET_BIN" -g 2>/dev/null) || return 1
  /usr/bin/awk '/SleepDisabled/ { print $2; exit }' <<< "$settings"
}

should_restore_sleep() {
  local reset_value=""
  if [[ -e "$OWNED_MARKER" ]]; then
    return 0
  fi
  if [[ ! -f "$CONFIG_FILE" ]]; then
    return 0
  fi
  reset_value=$(/usr/bin/plutil -extract "ResetSleepWhenInactive" raw -o - "$CONFIG_FILE" 2>/dev/null) || return 0
  [[ "$reset_value" != "false" ]]
}

restore_system_sleep() {
  local current verified
  current=$(sleep_disabled_value) || current=""
  if [[ "$current" != "0" ]]; then
    "$SUDO_BIN" -n "$PMSET_BIN" -a disablesleep 0 || return 1
  fi
  verified=$(sleep_disabled_value) || verified=""
  [[ "$verified" == "0" ]]
}

"$LAUNCHCTL_BIN" bootout "gui/$UID_VALUE/$LABEL" >/dev/null 2>&1 || true
service_state=$("$LAUNCHCTL_BIN" print "gui/$UID_VALUE/$LABEL" 2>/dev/null) || service_state=""
if [[ -n "$service_state" ]]; then
  print -u2 -- "Warning: the watchdog is still running; watchdog files were preserved."
  exit 1
fi

if should_restore_sleep && ! restore_system_sleep; then
  print -u2 -- "Warning: SleepDisabled cleanup failed; watchdog files were preserved."
  exit 1
fi

/bin/rm -f "$LAUNCH_AGENT"
/bin/rm -rf "$INSTALL_DIR"

print -r -- "Power Protect Watchdog uninstalled. The original Power Protect installation was not changed."
