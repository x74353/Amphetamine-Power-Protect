#!/bin/zsh

emulate -L zsh
setopt ERR_EXIT NO_UNSET PIPE_FAIL

readonly REPO_ROOT="${0:A:h:h}"
readonly WATCHDOG="$REPO_ROOT/Source/Watchdog/power-protect-watchdog.zsh"
readonly INSTALLER="$REPO_ROOT/Source/Watchdog/install.zsh"
readonly UNINSTALLER="$REPO_ROOT/Source/Watchdog/uninstall.zsh"
readonly TEST_ROOT=$(/usr/bin/mktemp -d "${TMPDIR:-/tmp}/power-protect-watchdog-tests.XXXXXX")
readonly TOUCH_REAL=/usr/bin/touch

trap '/bin/chmod -R u+w "$TEST_ROOT" 2>/dev/null || true; /bin/rm -rf "$TEST_ROOT"' EXIT

fail() {
  print -u2 -- "FAIL: $1"
  exit 1
}

assert_equal() {
  local expected="$1"
  local actual="$2"
  local message="$3"
  [[ "$actual" == "$expected" ]] || fail "$message (expected $expected, got $actual)"
}

assert_exists() {
  [[ -e "$1" ]] || fail "$2"
}

assert_not_exists() {
  [[ ! -e "$1" ]] || fail "$2"
}

assert_succeeds() {
  "$@" || fail "command should succeed: $*"
}

assert_fails() {
  if "$@"; then
    fail "command should fail: $*"
  fi
}

write_config_to() {
  local directory="$1"
  local enabled="$2"
  local percent="$3"
  local reset_inactive="${4:-true}"
  local bool="<true/>"
  local reset_bool="<true/>"
  [[ "$enabled" == "false" ]] && bool="<false/>"
  [[ "$reset_inactive" == "false" ]] && reset_bool="<false/>"

  /bin/mkdir -p "$directory"
  /bin/cat > "$directory/config.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Enabled</key>
    $bool
    <key>LowBatteryPercent</key>
    <integer>$percent</integer>
    <key>ResetSleepWhenInactive</key>
    $reset_bool
</dict>
</plist>
EOF
}

write_config() {
  write_config_to "$POWER_PROTECT_STATE_DIR" "$@"
}

set_power_source() {
  local source="$1"
  local percent="$2"
  /bin/cat > "$FAKE_PMSET_BATTERY" <<EOF
Now drawing from '$source'
 -InternalBattery-0 (id=1)  ${percent}%; discharging; present: true
EOF
}

set_power_unavailable() {
  print -r -- "Battery status unavailable" > "$FAKE_PMSET_BATTERY"
}

set_session() {
  local state="$1"
  local assertion_id="${2:-0x1}"
  if [[ "$state" == "active" ]]; then
    /bin/cat > "$FAKE_PMSET_ASSERTIONS" <<EOF
Listed by owning process:
   pid 123(Amphetamine): [$assertion_id] 00:01:00 PreventUserIdleSystemSleep named: "Amphetamine (Single-Use - System)"
EOF
  else
    print -r -- "No assertions." > "$FAKE_PMSET_ASSERTIONS"
  fi
}

append_assertion_noise() {
  local line
  {
    for line in {1..5000}; do
      print -r -- "   pid $line(other): [0x2] 00:00:01 BackgroundTask named: \"test assertion $line\""
    done
  } >> "$FAKE_PMSET_ASSERTIONS"
}

set_sleep_disabled_state() {
  print -r -- "$1" > "$FAKE_PMSET_STATE"
}

set_sudo_failure() {
  "$TOUCH_REAL" "$FAKE_SUDO_FAIL"
}

set_touch_failure() {
  print -r -- "$1" > "$FAKE_TOUCH_FAIL"
}

setup_case() {
  local name="$1"
  local initial_sleep_disabled="$2"
  local case_root="$TEST_ROOT/$name"

  export POWER_PROTECT_STATE_DIR="$case_root/state"
  export POWER_PROTECT_INSTALL_DIR="$case_root/install"
  export POWER_PROTECT_LAUNCH_AGENT="$case_root/LaunchAgents/com.if.Amphetamine.PowerProtectWatchdog.plist"
  export POWER_PROTECT_PMSET="$case_root/bin/pmset"
  export POWER_PROTECT_SUDO="$case_root/bin/sudo"
  export POWER_PROTECT_LOGGER="$case_root/bin/logger"
  export POWER_PROTECT_TOUCH="$case_root/bin/touch"
  export POWER_PROTECT_LAUNCHCTL="$case_root/bin/launchctl"
  export POWER_PROTECT_SLEEP="$case_root/bin/sleep"
  export POWER_PROTECT_CURRENT_UID=501
  export POWER_PROTECT_CONSOLE_UID=501
  export POWER_PROTECT_ARCHITECTURE=arm64
  export POWER_PROTECT_AMPHETAMINE_APP="$case_root/fixtures/Amphetamine.app"
  export POWER_PROTECT_SCRIPT_PATH="$case_root/fixtures/powerProtect.scpt"
  export FAKE_PMSET_STATE="$case_root/fixtures/sleep-disabled"
  export FAKE_PMSET_CHANGES="$case_root/fixtures/changes"
  export FAKE_PMSET_ASSERTIONS="$case_root/fixtures/assertions"
  export FAKE_PMSET_BATTERY="$case_root/fixtures/battery"
  export FAKE_SUDO_FAIL="$case_root/fixtures/sudo-fail"
  export FAKE_PMSET_IGNORE_WRITES="$case_root/fixtures/pmset-ignore-writes"
  export FAKE_TOUCH_FAIL="$case_root/fixtures/touch-fail-pattern"
  export FAKE_LAUNCHCTL_ACTIONS="$case_root/fixtures/launchctl-actions"
  export FAKE_LAUNCHCTL_LOADED="$case_root/fixtures/launchctl-loaded"
  export FAKE_LAUNCHCTL_STUCK="$case_root/fixtures/launchctl-stuck"
  /bin/mkdir -p "$POWER_PROTECT_STATE_DIR" "$POWER_PROTECT_INSTALL_DIR" "$case_root/bin" "$case_root/fixtures" "$POWER_PROTECT_AMPHETAMINE_APP" "${POWER_PROTECT_LAUNCH_AGENT:h}"
  print -r -- "$initial_sleep_disabled" > "$FAKE_PMSET_STATE"
  "$TOUCH_REAL" "$POWER_PROTECT_SCRIPT_PATH"

  /bin/cat > "$POWER_PROTECT_PMSET" <<'EOF'
#!/bin/zsh
case "$*" in
  "-g assertions")
    /bin/cat "$FAKE_PMSET_ASSERTIONS"
    ;;
  "-g batt")
    /bin/cat "$FAKE_PMSET_BATTERY"
    ;;
  "-g")
    print -r -- " SleepDisabled        $(<"$FAKE_PMSET_STATE")"
    ;;
  "-a disablesleep "*)
    print -r -- "$3" >> "$FAKE_PMSET_CHANGES"
    [[ -e "$FAKE_PMSET_IGNORE_WRITES" ]] || print -r -- "$3" > "$FAKE_PMSET_STATE"
    ;;
  *)
    print -u2 -- "Unexpected pmset arguments: $*"
    exit 64
    ;;
esac
EOF

  /bin/cat > "$POWER_PROTECT_SUDO" <<'EOF'
#!/bin/zsh
[[ "${1:-}" == "-n" ]] && shift
if [[ "${1:-}" == "-l" ]]; then
  [[ -e "$FAKE_SUDO_FAIL" ]] && exit 1
  exit 0
fi
[[ -e "$FAKE_SUDO_FAIL" ]] && exit 1
exec "$@"
EOF

  /bin/cat > "$POWER_PROTECT_TOUCH" <<'EOF'
#!/bin/zsh
if [[ -f "$FAKE_TOUCH_FAIL" ]]; then
  pattern=$(<"$FAKE_TOUCH_FAIL")
  [[ "$*" == *"$pattern"* ]] && exit 1
fi
exec /usr/bin/touch "$@"
EOF

  /bin/cat > "$POWER_PROTECT_LOGGER" <<'EOF'
#!/bin/zsh
exit 0
EOF

  /bin/cat > "$POWER_PROTECT_LAUNCHCTL" <<'EOF'
#!/bin/zsh
print -r -- "$*" >> "$FAKE_LAUNCHCTL_ACTIONS"
case "${1:-}" in
  bootout)
    [[ -e "$FAKE_LAUNCHCTL_STUCK" ]] || /bin/rm -f "$FAKE_LAUNCHCTL_LOADED"
    exit 0
    ;;
  bootstrap)
    /usr/bin/touch "$FAKE_LAUNCHCTL_LOADED"
    exit 0
    ;;
  print)
    [[ -e "$FAKE_LAUNCHCTL_LOADED" ]] || exit 1
    print -r -- "state = running"
    ;;
  *)
    exit 64
    ;;
esac
EOF

  /bin/cat > "$POWER_PROTECT_SLEEP" <<'EOF'
#!/bin/zsh
exit 0
EOF

  /bin/chmod 700 "$POWER_PROTECT_PMSET" "$POWER_PROTECT_SUDO" "$POWER_PROTECT_TOUCH" "$POWER_PROTECT_LOGGER" "$POWER_PROTECT_LAUNCHCTL" "$POWER_PROTECT_SLEEP"
  write_config true 35 true
  set_session active
  set_power_source "Battery Power" 78
}

run_watchdog_once() {
  [[ -x "$WATCHDOG" ]] || fail "watchdog implementation is missing or not executable"
  "$WATCHDOG" --once
}

run_watchdog_cleanup() {
  "$WATCHDOG" --cleanup
}

run_uninstaller() {
  "$UNINSTALLER"
}

run_installer() {
  "$INSTALLER"
}

setup_case config_validation 0
assert_succeeds "$WATCHDOG" --validate-config "$POWER_PROTECT_STATE_DIR/config.plist"
write_config true 2 true
assert_fails "$WATCHDOG" --validate-config "$POWER_PROTECT_STATE_DIR/config.plist"

setup_case ordinary_session_unarmed 0
run_watchdog_once
assert_equal 0 "$(<"$FAKE_PMSET_STATE")" "a generic Amphetamine session must not force closed-display mode"
assert_not_exists "$POWER_PROTECT_STATE_DIR/armed-session" "an unobserved closed-display intent must remain unarmed"
assert_not_exists "$POWER_PROTECT_STATE_DIR/sleep-disabled-owned" "an ordinary session must not claim ownership"

setup_case arm_and_reassert 1
run_watchdog_once
assert_equal "123:0x1" "$(<"$POWER_PROTECT_STATE_DIR/armed-session")" "observed Power Protect state should arm this assertion identity"
assert_exists "$POWER_PROTECT_STATE_DIR/sleep-disabled-owned" "arming should claim managed-state ownership"
set_sleep_disabled_state 0
run_watchdog_once
assert_equal 1 "$(<"$FAKE_PMSET_STATE")" "an armed session should repair a reset SleepDisabled value"

setup_case large_assertion_output 1
append_assertion_noise
run_watchdog_once
set_sleep_disabled_state 0
run_watchdog_once
assert_equal 1 "$(<"$FAKE_PMSET_STATE")" "large assertion output must not hide the armed Amphetamine session"

setup_case session_identity_change 1
run_watchdog_once
set_session active 0x9
set_sleep_disabled_state 1
run_watchdog_once
assert_equal "123:0x9" "$(<"$POWER_PROTECT_STATE_DIR/armed-session")" "a replacement assertion should receive a new arm identity"

setup_case unowned_inactive 1
set_session inactive
run_watchdog_once
assert_equal 0 "$(<"$FAKE_PMSET_STATE")" "inactive cleanup should repair leaked SleepDisabled"

setup_case inactive_reset_opt_out 1
write_config true 35 false
set_session inactive
run_watchdog_once
assert_equal 1 "$(<"$FAKE_PMSET_STATE")" "inactive reset opt-out should preserve unowned SleepDisabled"
assert_not_exists "$FAKE_PMSET_CHANGES" "inactive reset opt-out must not call pmset for unowned state"

setup_case owned_inactive 1
run_watchdog_once
set_session inactive
run_watchdog_once
assert_equal 0 "$(<"$FAKE_PMSET_STATE")" "inactive session should clean managed SleepDisabled"
assert_not_exists "$POWER_PROTECT_STATE_DIR/sleep-disabled-owned" "inactive cleanup should remove ownership"
assert_not_exists "$POWER_PROTECT_STATE_DIR/armed-session" "inactive cleanup should clear the assertion identity"

setup_case low_battery 1
run_watchdog_once
set_power_source "Battery Power" 35
run_watchdog_once
assert_equal 0 "$(<"$FAKE_PMSET_STATE")" "low battery should restore system sleep"
assert_exists "$POWER_PROTECT_STATE_DIR/low-battery-latched" "low battery should latch until AC returns"
assert_not_exists "$POWER_PROTECT_STATE_DIR/sleep-disabled-owned" "low battery should release managed ownership"
set_power_source "AC Power" 35
run_watchdog_once
assert_equal 1 "$(<"$FAKE_PMSET_STATE")" "AC power should clear the latch and restore an armed session"
assert_not_exists "$POWER_PROTECT_STATE_DIR/low-battery-latched" "AC power should clear the low-battery latch"

setup_case low_battery_latch_failure 1
run_watchdog_once
set_power_source "Battery Power" 35
set_touch_failure low-battery-latched
assert_fails run_watchdog_once
assert_equal 0 "$(<"$FAKE_PMSET_STATE")" "latch-write failure must still restore system sleep"
assert_not_exists "$POWER_PROTECT_STATE_DIR/low-battery-latched" "failed latch creation must be observable"
assert_not_exists "$POWER_PROTECT_STATE_DIR/sleep-disabled-owned" "failed latch creation must release ownership"

setup_case ownership_marker_failure 1
set_touch_failure sleep-disabled-owned
assert_fails run_watchdog_once
assert_equal 0 "$(<"$FAKE_PMSET_STATE")" "ownership-marker failure must fail safe instead of leaving closed-display mode enabled"
assert_not_exists "$POWER_PROTECT_STATE_DIR/armed-session" "failed ownership must not arm the session"

setup_case unreadable_power 1
run_watchdog_once
set_power_unavailable
assert_fails run_watchdog_once
assert_equal 0 "$(<"$FAKE_PMSET_STATE")" "unreadable power state must fail safe"
assert_not_exists "$POWER_PROTECT_STATE_DIR/sleep-disabled-owned" "power fail-safe should release ownership"
set_power_source "Battery Power" 78
run_watchdog_once
assert_equal 1 "$(<"$FAKE_PMSET_STATE")" "an armed session should recover after power telemetry returns"

setup_case unreadable_assertions 1
run_watchdog_once
/bin/rm -f "$FAKE_PMSET_ASSERTIONS"
assert_fails run_watchdog_once
assert_equal 0 "$(<"$FAKE_PMSET_STATE")" "unreadable assertion state should release managed sleep state"
assert_not_exists "$POWER_PROTECT_STATE_DIR/armed-session" "unreadable assertion state should clear stale intent"

setup_case unreadable_sleep_state 1
run_watchdog_once
print -r -- "unknown" > "$FAKE_PMSET_STATE"
assert_fails run_watchdog_once
assert_equal 0 "$(<"$FAKE_PMSET_STATE")" "unreadable SleepDisabled should attempt and verify a fail-safe reset"

setup_case enable_sudo_failure 1
run_watchdog_once
set_sleep_disabled_state 0
set_sudo_failure
assert_fails run_watchdog_once
assert_equal 0 "$(<"$FAKE_PMSET_STATE")" "failed authorization must not claim that sleep was disabled"
assert_exists "$POWER_PROTECT_STATE_DIR/sleep-disabled-owned" "managed ownership must survive a transient reassertion failure"

setup_case cleanup_sudo_failure 1
run_watchdog_once
set_sudo_failure
assert_fails run_watchdog_cleanup
assert_equal 1 "$(<"$FAKE_PMSET_STATE")" "failed cleanup must preserve the actual state for a later retry"
assert_exists "$POWER_PROTECT_STATE_DIR/sleep-disabled-owned" "failed cleanup must retain ownership"

setup_case pmset_verification_failure 1
run_watchdog_once
set_sleep_disabled_state 0
"$TOUCH_REAL" "$FAKE_PMSET_IGNORE_WRITES"
assert_fails run_watchdog_once
assert_equal 0 "$(<"$FAKE_PMSET_STATE")" "a successful pmset exit without a state change must be rejected"
assert_exists "$POWER_PROTECT_STATE_DIR/sleep-disabled-owned" "verification failure must retain managed ownership"

setup_case disabled_one_time_cleanup 1
write_config false 35 true
run_watchdog_once
assert_equal 0 "$(<"$FAKE_PMSET_STATE")" "disabling should perform one cleanup even for unowned state"
assert_exists "$POWER_PROTECT_STATE_DIR/disabled-cleaned" "disabled cleanup should be recorded"
set_sleep_disabled_state 1
run_watchdog_once
assert_equal 1 "$(<"$FAKE_PMSET_STATE")" "a disabled watchdog must not continuously fight another manager"

setup_case background_disabled 1
write_config false 35 true
export POWER_PROTECT_CONSOLE_UID=502
run_watchdog_once
assert_equal 1 "$(<"$FAKE_PMSET_STATE")" "a background user's disabled cleanup must not alter the active console user's global state"
assert_not_exists "$POWER_PROTECT_STATE_DIR/disabled-cleaned" "background user must defer disabled cleanup until active"

setup_case invalid_config_cleanup 1
run_watchdog_once
print -r -- "not a plist" > "$POWER_PROTECT_STATE_DIR/config.plist"
assert_fails run_watchdog_once
assert_equal 0 "$(<"$FAKE_PMSET_STATE")" "invalid configuration should release managed state"
assert_not_exists "$POWER_PROTECT_STATE_DIR/sleep-disabled-owned" "invalid configuration cleanup should release ownership"

setup_case non_console_user 1
run_watchdog_once
export POWER_PROTECT_CONSOLE_UID=502
run_watchdog_once
assert_equal 0 "$(<"$FAKE_PMSET_STATE")" "a background GUI user should release its managed global state"
assert_not_exists "$POWER_PROTECT_STATE_DIR/sleep-disabled-owned" "background user cleanup should release ownership"
assert_exists "$POWER_PROTECT_STATE_DIR/armed-session" "background user should retain session intent for a safe handoff"
set_sleep_disabled_state 1
run_watchdog_once
assert_equal 1 "$(<"$FAKE_PMSET_STATE")" "a background user must not fight the active console user's state"
set_sleep_disabled_state 0
export POWER_PROTECT_CONSOLE_UID=501
run_watchdog_once
assert_equal 1 "$(<"$FAKE_PMSET_STATE")" "returning console user should restore its still-active armed session"

setup_case healthcheck 0
assert_succeeds "$WATCHDOG" --healthcheck
set_sudo_failure
assert_fails "$WATCHDOG" --healthcheck

setup_case uninstall_missing_watchdog 1
write_config_to "$POWER_PROTECT_INSTALL_DIR" true 35 true
"$TOUCH_REAL" "$POWER_PROTECT_INSTALL_DIR/sleep-disabled-owned" "$POWER_PROTECT_LAUNCH_AGENT"
run_uninstaller
assert_equal 0 "$(<"$FAKE_PMSET_STATE")" "uninstall should restore sleep even when the watchdog executable is missing"
assert_not_exists "$POWER_PROTECT_INSTALL_DIR" "successful uninstall should remove the install directory"
assert_not_exists "$POWER_PROTECT_LAUNCH_AGENT" "successful uninstall should remove the LaunchAgent"

setup_case uninstall_cleanup_failure 1
write_config_to "$POWER_PROTECT_INSTALL_DIR" true 35 true
"$TOUCH_REAL" "$POWER_PROTECT_INSTALL_DIR/sleep-disabled-owned" "$POWER_PROTECT_LAUNCH_AGENT"
set_sudo_failure
assert_fails run_uninstaller
assert_equal 1 "$(<"$FAKE_PMSET_STATE")" "failed uninstall cleanup must not misreport SleepDisabled"
assert_exists "$POWER_PROTECT_INSTALL_DIR" "failed uninstall cleanup must preserve watchdog files"
assert_exists "$POWER_PROTECT_LAUNCH_AGENT" "failed uninstall cleanup must preserve the LaunchAgent file"

setup_case uninstall_reset_opt_out 1
write_config_to "$POWER_PROTECT_INSTALL_DIR" true 35 false
"$TOUCH_REAL" "$POWER_PROTECT_LAUNCH_AGENT"
run_uninstaller
assert_equal 1 "$(<"$FAKE_PMSET_STATE")" "uninstall reset opt-out should preserve an unowned external SleepDisabled state"
assert_not_exists "$POWER_PROTECT_INSTALL_DIR" "reset opt-out should still remove watchdog files"

setup_case uninstall_running_agent 0
write_config_to "$POWER_PROTECT_INSTALL_DIR" true 35 true
"$TOUCH_REAL" "$POWER_PROTECT_LAUNCH_AGENT" "$FAKE_LAUNCHCTL_LOADED" "$FAKE_LAUNCHCTL_STUCK"
assert_fails run_uninstaller
assert_exists "$POWER_PROTECT_INSTALL_DIR" "uninstall must preserve files while the agent is still running"
assert_exists "$POWER_PROTECT_LAUNCH_AGENT" "uninstall must preserve the LaunchAgent while it is still loaded"

setup_case installer_invalid_config 0
export POWER_PROTECT_STATE_DIR="$POWER_PROTECT_INSTALL_DIR"
print -r -- "invalid" > "$POWER_PROTECT_INSTALL_DIR/config.plist"
assert_fails run_installer
assert_not_exists "$FAKE_LAUNCHCTL_ACTIONS" "invalid config should fail before launchctl mutation"

setup_case installer_success 0
export POWER_PROTECT_STATE_DIR="$POWER_PROTECT_INSTALL_DIR"
write_config_to "$POWER_PROTECT_INSTALL_DIR" true 35 true
run_installer
assert_exists "$POWER_PROTECT_INSTALL_DIR/power-protect-watchdog.zsh" "installer should deploy the watchdog"
assert_exists "$POWER_PROTECT_LAUNCH_AGENT" "installer should deploy the LaunchAgent"
assert_succeeds "$POWER_PROTECT_INSTALL_DIR/power-protect-watchdog.zsh" --healthcheck

print -r -- "PASS: Power Protect watchdog regression tests"
