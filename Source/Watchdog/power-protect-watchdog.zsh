#!/bin/zsh

emulate -L zsh
setopt NO_UNSET PIPE_FAIL
umask 077

readonly LABEL="com.if.Amphetamine.PowerProtectWatchdog"
readonly STATE_DIR="${POWER_PROTECT_STATE_DIR:-$HOME/Library/Application Support/Amphetamine/Power Protect Watchdog}"
readonly CONFIG_FILE="$STATE_DIR/config.plist"
readonly OWNED_MARKER="$STATE_DIR/sleep-disabled-owned"
readonly ARMED_SESSION="$STATE_DIR/armed-session"
readonly LOW_BATTERY_LATCH="$STATE_DIR/low-battery-latched"
readonly DISABLED_CLEANED_MARKER="$STATE_DIR/disabled-cleaned"
readonly RUN_LOCK="$STATE_DIR/run.lock"
readonly LOG_FILE="$STATE_DIR/activity.log"
readonly PMSET_BIN="${POWER_PROTECT_PMSET:-/usr/bin/pmset}"
readonly SUDO_BIN="${POWER_PROTECT_SUDO:-/usr/bin/sudo}"
readonly LOGGER_BIN="${POWER_PROTECT_LOGGER:-/usr/bin/logger}"
readonly TOUCH_BIN="${POWER_PROTECT_TOUCH:-/usr/bin/touch}"
readonly CURRENT_UID="${POWER_PROTECT_CURRENT_UID:-$(/usr/bin/id -u)}"
readonly POLL_SECONDS=2
readonly MAX_BACKOFF_SECONDS=30
readonly LOG_REPEAT_SECONDS=60
readonly MAX_LOG_BYTES=1048576

typeset -g CONFIG_ENABLED=""
typeset -g CONFIG_RESET_INACTIVE=""
typeset -g CONFIG_LOW_BATTERY_PERCENT=""
typeset -g LAST_LOG_MESSAGE=""
typeset -gi LAST_LOG_EPOCH=0

if ! /bin/mkdir -p "$STATE_DIR"; then
  print -u2 -- "Power Protect Watchdog cannot create its state directory: $STATE_DIR"
  exit 1
fi

rotate_log_if_needed() {
  local size
  [[ -f "$LOG_FILE" ]] || return 0
  size=$(/usr/bin/stat -f '%z' "$LOG_FILE" 2>/dev/null) || return 0
  if [[ "$size" == <-> && "$size" -ge "$MAX_LOG_BYTES" ]]; then
    /bin/mv -f "$LOG_FILE" "$LOG_FILE.1" || return 1
  fi
}

log_message() {
  local message="$1"
  local now
  now=$(/bin/date '+%s') || now=0

  if [[ "$message" == "$LAST_LOG_MESSAGE" ]] &&
     (( now - LAST_LOG_EPOCH < LOG_REPEAT_SECONDS )); then
    return 0
  fi

  LAST_LOG_MESSAGE="$message"
  LAST_LOG_EPOCH="$now"
  rotate_log_if_needed || print -u2 -- "Could not rotate $LOG_FILE"
  print -r -- "$(/bin/date '+%Y-%m-%d %H:%M:%S') $message" >> "$LOG_FILE" ||
    print -u2 -- "Could not write $LOG_FILE"
  "$LOGGER_BIN" -t "$LABEL" -- "$message" 2>/dev/null || true
  return 0
}

load_config_file() {
  local file="$1"
  local enabled reset_inactive low_battery

  [[ -f "$file" ]] || return 1
  enabled=$(/usr/bin/plutil -extract "Enabled" raw -o - "$file" 2>/dev/null) || return 1
  reset_inactive=$(/usr/bin/plutil -extract "ResetSleepWhenInactive" raw -o - "$file" 2>/dev/null) || return 1
  low_battery=$(/usr/bin/plutil -extract "LowBatteryPercent" raw -o - "$file" 2>/dev/null) || return 1

  [[ "$enabled" == "true" || "$enabled" == "false" ]] || return 1
  [[ "$reset_inactive" == "true" || "$reset_inactive" == "false" ]] || return 1
  [[ "$low_battery" == <-> && "$low_battery" -ge 5 && "$low_battery" -le 95 ]] || return 1

  CONFIG_ENABLED="$enabled"
  CONFIG_RESET_INACTIVE="$reset_inactive"
  CONFIG_LOW_BATTERY_PERCENT="$low_battery"
}

load_config() {
  load_config_file "$CONFIG_FILE"
}

amphetamine_assertion_identity() {
  local assertions line identity
  assertions=$("$PMSET_BIN" -g assertions 2>/dev/null) || return 2
  line=$(/usr/bin/grep -Em1 'pid [0-9]+\(Amphetamine\):.*PreventUserIdleSystemSleep' <<< "$assertions") || return 1
  identity=$(/usr/bin/sed -nE 's/.*pid ([0-9]+)\(Amphetamine\):[[:space:]]*\[([^]]+)\].*/\1:\2/p' <<< "$line")
  [[ -n "$identity" ]] || return 2
  print -r -- "$identity"
}

sleep_disabled_value() {
  local settings
  settings=$("$PMSET_BIN" -g 2>/dev/null) || return 1
  /usr/bin/awk '/SleepDisabled/ { print $2; exit }' <<< "$settings"
}

power_source() {
  local battery_status="$1"
  /usr/bin/sed -n "1s/.*'\([^']*\)'.*/\1/p" <<< "$battery_status"
}

battery_percent() {
  local battery_status="$1"
  /usr/bin/sed -nE '/[[:space:]][0-9]+%;/ { s/.*[[:space:]]([0-9]+)%;.*/\1/; p; q; }' <<< "$battery_status"
}

console_user_uid() {
  if [[ -n "${POWER_PROTECT_CONSOLE_UID:-}" ]]; then
    print -r -- "$POWER_PROTECT_CONSOLE_UID"
  else
    /usr/bin/stat -f '%u' /dev/console 2>/dev/null
  fi
}

is_active_console_user() {
  local console_uid
  console_uid=$(console_user_uid) || return 1
  [[ "$console_uid" == "$CURRENT_UID" ]]
}

set_sleep_disabled() {
  local desired="$1"
  local reason="$2"
  local current verified
  current=$(sleep_disabled_value) || current=""

  if [[ "$current" == "$desired" ]]; then
    return 0
  fi

  if ! "$SUDO_BIN" -n "$PMSET_BIN" -a disablesleep "$desired"; then
    log_message "ERROR: could not set SleepDisabled=$desired ($reason)"
    return 1
  fi

  verified=$(sleep_disabled_value) || verified=""
  if [[ "$verified" != "$desired" ]]; then
    log_message "ERROR: SleepDisabled verification failed after requesting $desired ($reason)"
    return 1
  fi

  log_message "SleepDisabled=$desired ($reason)"
}

cleanup_owned_state() {
  local reason="$1"
  if [[ -e "$OWNED_MARKER" ]]; then
    set_sleep_disabled 0 "$reason" || return 1
    /bin/rm -f "$OWNED_MARKER" || return 1
  fi
}

release_sleep_override() {
  local reason="$1"
  set_sleep_disabled 0 "$reason" || return 1
  /bin/rm -f "$OWNED_MARKER" || return 1
}

clear_session_state() {
  /bin/rm -f "$ARMED_SESSION" "$LOW_BATTERY_LATCH" || return 1
}

read_armed_session() {
  local identity
  [[ -f "$ARMED_SESSION" ]] || return 1
  IFS= read -r identity < "$ARMED_SESSION" || return 1
  [[ -n "$identity" ]] || return 1
  print -r -- "$identity"
}

write_armed_session() {
  local identity="$1"
  local temporary="$ARMED_SESSION.tmp.$$"
  print -r -- "$identity" > "$temporary" || return 1
  /bin/mv -f "$temporary" "$ARMED_SESSION" || {
    /bin/rm -f "$temporary"
    return 1
  }
}

arm_session() {
  local identity="$1"
  local marker_created="no"

  if [[ ! -e "$OWNED_MARKER" ]]; then
    if ! "$TOUCH_BIN" "$OWNED_MARKER"; then
      log_message "ERROR: could not create ownership marker while arming session"
      return 1
    fi
    marker_created="yes"
  fi

  if ! write_armed_session "$identity"; then
    [[ "$marker_created" == "yes" ]] && /bin/rm -f "$OWNED_MARKER"
    log_message "ERROR: could not persist armed Amphetamine session"
    return 1
  fi

  log_message "Armed watchdog for Amphetamine assertion $identity"
}

claim_sleep_override() {
  local reason="$1"
  local marker_created="no"

  if [[ ! -e "$OWNED_MARKER" ]]; then
    if ! "$TOUCH_BIN" "$OWNED_MARKER"; then
      log_message "ERROR: could not create ownership marker"
      return 1
    fi
    marker_created="yes"
  fi

  if set_sleep_disabled 1 "$reason"; then
    return 0
  fi

  [[ "$marker_created" == "yes" ]] && /bin/rm -f "$OWNED_MARKER"
  return 1
}

handle_disabled() {
  if [[ -e "$DISABLED_CLEANED_MARKER" ]]; then
    return 0
  fi

  if [[ "$CONFIG_RESET_INACTIVE" == "true" ]]; then
    release_sleep_override "watchdog disabled" || return 1
  else
    cleanup_owned_state "watchdog disabled" || return 1
  fi

  clear_session_state || return 1
  if ! "$TOUCH_BIN" "$DISABLED_CLEANED_MARKER"; then
    log_message "ERROR: could not record disabled cleanup"
    return 1
  fi
}

cleanup_for_exit() {
  local reason="$1"

  if load_config && [[ "$CONFIG_RESET_INACTIVE" == "true" ]]; then
    release_sleep_override "$reason" || return 1
  else
    cleanup_owned_state "$reason" || return 1
  fi

  clear_session_state || return 1
}

reconcile() {
  local assertion_identity assertion_status current_sleep armed_identity
  local battery_status source percent

  if ! load_config; then
    log_message "ERROR: watchdog configuration is invalid or unreadable"
    cleanup_owned_state "invalid watchdog configuration" || return 1
    clear_session_state || return 1
    return 1
  fi

  if ! is_active_console_user; then
    cleanup_owned_state "user is not the active console user" || return 1
    /bin/rm -f "$LOW_BATTERY_LATCH" || return 1
    return 0
  fi

  if [[ "$CONFIG_ENABLED" == "false" ]]; then
    handle_disabled
    return
  fi

  if [[ -e "$DISABLED_CLEANED_MARKER" ]]; then
    /bin/rm -f "$DISABLED_CLEANED_MARKER" || return 1
  fi

  assertion_identity=$(amphetamine_assertion_identity)
  assertion_status=$?

  if [[ "$assertion_status" -eq 1 ]]; then
    if [[ "$CONFIG_RESET_INACTIVE" == "true" ]]; then
      release_sleep_override "Amphetamine session inactive" || return 1
    else
      cleanup_owned_state "Amphetamine session inactive" || return 1
    fi
    clear_session_state || return 1
    return 0
  elif [[ "$assertion_status" -ne 0 ]]; then
    log_message "ERROR: Amphetamine assertion state is unavailable"
    if [[ "$CONFIG_RESET_INACTIVE" == "true" ]]; then
      release_sleep_override "Amphetamine assertion state unavailable" || return 1
    else
      cleanup_owned_state "Amphetamine assertion state unavailable" || return 1
    fi
    clear_session_state || return 1
    return 1
  fi

  current_sleep=$(sleep_disabled_value) || current_sleep=""
  if [[ "$current_sleep" != "0" && "$current_sleep" != "1" ]]; then
    log_message "ERROR: SleepDisabled state is unavailable"
    if [[ "$CONFIG_RESET_INACTIVE" == "true" ]]; then
      release_sleep_override "SleepDisabled state unavailable" || return 1
    else
      cleanup_owned_state "SleepDisabled state unavailable" || return 1
    fi
    clear_session_state || return 1
    return 1
  fi

  armed_identity=$(read_armed_session) || armed_identity=""
  if [[ -n "$armed_identity" && "$armed_identity" != "$assertion_identity" ]]; then
    if [[ "$current_sleep" == "1" ]]; then
      arm_session "$assertion_identity" || {
        release_sleep_override "could not safely transfer armed session"
        return 1
      }
      /bin/rm -f "$LOW_BATTERY_LATCH" || return 1
      armed_identity="$assertion_identity"
    else
      /bin/rm -f "$ARMED_SESSION" "$OWNED_MARKER" "$LOW_BATTERY_LATCH" || return 1
      armed_identity=""
    fi
  fi

  if [[ -z "$armed_identity" && "$current_sleep" == "1" ]]; then
    arm_session "$assertion_identity" || {
      release_sleep_override "could not safely arm session"
      return 1
    }
    armed_identity="$assertion_identity"
  fi

  battery_status=$("$PMSET_BIN" -g batt 2>/dev/null) || battery_status=""
  source=$(power_source "$battery_status")
  percent=$(battery_percent "$battery_status")

  if [[ "$source" != "AC Power" && "$source" != "Battery Power" ]] ||
     [[ "$source" == "Battery Power" && "$percent" != <-> ]]; then
    log_message "ERROR: power state is unavailable"
    release_sleep_override "power state unavailable" || return 1
    return 1
  fi

  if [[ "$source" == "AC Power" ]]; then
    if [[ -e "$LOW_BATTERY_LATCH" ]]; then
      /bin/rm -f "$LOW_BATTERY_LATCH" || {
        log_message "ERROR: could not clear low-battery latch"
        return 1
      }
    fi
  else
    if [[ "$percent" -le "$CONFIG_LOW_BATTERY_PERCENT" ]]; then
      if [[ ! -e "$LOW_BATTERY_LATCH" ]]; then
        log_message "Low-battery protection engaged at ${percent}% (threshold ${CONFIG_LOW_BATTERY_PERCENT}%)"
        if ! "$TOUCH_BIN" "$LOW_BATTERY_LATCH"; then
          log_message "ERROR: could not create low-battery latch"
          release_sleep_override "low-battery protection without latch" || return 1
          return 1
        fi
      fi
      release_sleep_override "low-battery protection"
      return
    fi

    if [[ -e "$LOW_BATTERY_LATCH" ]]; then
      release_sleep_override "low-battery protection latched"
      return
    fi
  fi

  if [[ "$armed_identity" == "$assertion_identity" ]]; then
    claim_sleep_override "armed Amphetamine closed-display session on $source"
    return
  fi

  return 0
}

print_status() {
  local config_state="unreadable" active="unreadable" console="no"
  local assertion_identity assertion_status battery_status source percent sleep_value armed_identity

  if load_config; then
    config_state="$CONFIG_ENABLED"
  fi

  assertion_identity=$(amphetamine_assertion_identity)
  assertion_status=$?
  if [[ "$assertion_status" -eq 0 ]]; then
    active="yes"
  elif [[ "$assertion_status" -eq 1 ]]; then
    active="no"
  fi

  is_active_console_user && console="yes"
  battery_status=$("$PMSET_BIN" -g batt 2>/dev/null) || battery_status=""
  source=$(power_source "$battery_status")
  percent=$(battery_percent "$battery_status")
  sleep_value=$(sleep_disabled_value) || sleep_value="unreadable"
  armed_identity=$(read_armed_session) || armed_identity=""

  print -r -- "AmphetamineSessionActive=$active"
  print -r -- "AmphetamineAssertion=${assertion_identity:-none}"
  print -r -- "WatchdogEnabled=$config_state"
  print -r -- "ResetSleepWhenInactive=${CONFIG_RESET_INACTIVE:-unreadable}"
  print -r -- "ActiveConsoleUser=$console"
  print -r -- "PowerSource=${source:-unreadable}"
  print -r -- "BatteryPercent=${percent:-unreadable}"
  print -r -- "LowBatteryThreshold=${CONFIG_LOW_BATTERY_PERCENT:-unreadable}"
  print -r -- "SleepDisabled=$sleep_value"
  print -r -- "ArmedSession=${armed_identity:-none}"
  print -r -- "WatchdogOwnsState=$([[ -e "$OWNED_MARKER" ]] && print yes || print no)"
  print -r -- "LowBatteryLatched=$([[ -e "$LOW_BATTERY_LATCH" ]] && print yes || print no)"
}

healthcheck() {
  local healthy="yes" battery_status source percent sleep_value

  if ! load_config; then
    print -u2 -- "HealthError=invalid configuration"
    healthy="no"
  fi

  sleep_value=$(sleep_disabled_value) || sleep_value=""
  if [[ "$sleep_value" != "0" && "$sleep_value" != "1" ]]; then
    print -u2 -- "HealthError=SleepDisabled is unreadable"
    healthy="no"
  fi

  battery_status=$("$PMSET_BIN" -g batt 2>/dev/null) || battery_status=""
  source=$(power_source "$battery_status")
  percent=$(battery_percent "$battery_status")
  if [[ "$source" != "AC Power" && "$source" != "Battery Power" ]] ||
     [[ "$source" == "Battery Power" && "$percent" != <-> ]]; then
    print -u2 -- "HealthError=power state is unreadable"
    healthy="no"
  fi

  if ! "$SUDO_BIN" -n -l "$PMSET_BIN" -a disablesleep 1 >/dev/null 2>&1 ||
     ! "$SUDO_BIN" -n -l "$PMSET_BIN" -a disablesleep 0 >/dev/null 2>&1; then
    print -u2 -- "HealthError=pmset authorization is unavailable"
    healthy="no"
  fi

  if [[ "$healthy" == "yes" ]]; then
    print -r -- "Health=healthy"
    return 0
  fi

  print -r -- "Health=unhealthy"
  return 1
}

acquire_run_lock() {
  local existing_pid=""

  if /bin/mkdir "$RUN_LOCK" 2>/dev/null; then
    print -r -- "$$" > "$RUN_LOCK/pid" || return 1
    return 0
  fi

  if [[ -f "$RUN_LOCK/pid" ]]; then
    IFS= read -r existing_pid < "$RUN_LOCK/pid" || existing_pid=""
  fi
  if [[ "$existing_pid" == <-> ]] && /bin/kill -0 "$existing_pid" 2>/dev/null; then
    log_message "ERROR: another watchdog instance is already running (pid $existing_pid)"
    return 1
  fi

  /bin/rm -f "$RUN_LOCK/pid" 2>/dev/null || return 1
  /bin/rmdir "$RUN_LOCK" 2>/dev/null || return 1
  /bin/mkdir "$RUN_LOCK" || return 1
  print -r -- "$$" > "$RUN_LOCK/pid" || return 1
}

release_run_lock() {
  local lock_pid=""
  if [[ -f "$RUN_LOCK/pid" ]]; then
    IFS= read -r lock_pid < "$RUN_LOCK/pid" || lock_pid=""
  fi
  if [[ "$lock_pid" == "$$" ]]; then
    /bin/rm -f "$RUN_LOCK/pid"
    /bin/rmdir "$RUN_LOCK" 2>/dev/null || true
  fi
}

shutdown_handler() {
  trap - TERM INT HUP
  local attempt cleanup_status=1

  for attempt in 1 2 3; do
    if cleanup_for_exit "watchdog stopped"; then
      cleanup_status=0
      break
    fi
    log_message "ERROR: shutdown cleanup attempt $attempt failed"
    /bin/sleep 1
  done

  release_run_lock
  exit "$cleanup_status"
}

case "${1:-run}" in
  run)
    acquire_run_lock || exit 75
    trap shutdown_handler TERM INT HUP
    log_message "Watchdog started"
    integer failures=0 delay=POLL_SECONDS
    while true; do
      if reconcile; then
        failures=0
        delay=POLL_SECONDS
      else
        (( failures++ ))
        if (( failures >= 5 )); then
          delay=MAX_BACKOFF_SECONDS
        else
          delay=$(( POLL_SECONDS * (1 << (failures - 1)) ))
        fi
        log_message "ERROR: reconciliation failed; retrying in ${delay}s"
      fi
      /bin/sleep "$delay"
    done
    ;;
  --once)
    reconcile
    ;;
  --status)
    print_status
    ;;
  --healthcheck)
    healthcheck
    ;;
  --validate-config)
    load_config_file "${2:-$CONFIG_FILE}" || {
      print -u2 -- "Invalid watchdog configuration: ${2:-$CONFIG_FILE}"
      exit 1
    }
    print -r -- "Configuration=valid"
    ;;
  --cleanup)
    cleanup_for_exit "manual cleanup"
    ;;
  *)
    print -u2 -- "Usage: $0 [run|--once|--status|--healthcheck|--validate-config [path]|--cleanup]"
    exit 64
    ;;
esac
