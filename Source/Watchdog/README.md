# Power Protect Watchdog

Power Protect normally calls `pmset -a disablesleep 1` when Amphetamine starts a Closed-Display Mode session. On some Apple Silicon/macOS combinations, macOS resets `SleepDisabled` to `0` after the power source or external-display topology changes, but Amphetamine's session assertion remains active. The Mac can then enter `Clamshell Sleep` even though the session is still running.

This optional watchdog closes that reassertion gap. Every two seconds it checks for an Amphetamine-owned `PreventUserIdleSystemSleep` assertion, but it does not treat that generic assertion alone as permission to force closed-display operation. It arms a specific assertion identity only after observing that Power Protect has set `SleepDisabled=1` for that session. Once armed, it restores `SleepDisabled=1` if macOS resets it.

## Safety behavior

- Records both an assertion identity and an ownership marker before managing `SleepDisabled`.
- Leaves ordinary Amphetamine sessions unarmed when Power Protect has not enabled closed-display operation.
- Restores `SleepDisabled=0` when the Amphetamine session ends or when the watchdog transitions to disabled.
- By default, repairs an unowned `SleepDisabled=1` while Amphetamine is inactive, preventing a stale Power Protect state from leaving the Mac awake.
- Restores system sleep at or below the configured low-battery threshold (35% by default).
- Keeps low-battery protection latched until AC power returns or the Amphetamine session ends.
- Fails safe if power, assertion, configuration, marker, or `pmset` verification becomes unavailable.
- Only the active console user's LaunchAgent may manage the global power state; background fast-user-switching sessions release their managed state and stand down.
- Retries persistent failures with capped exponential backoff, rate-limits duplicate log messages, and rotates `activity.log` at 1 MiB.
- Uses the two exact `pmset` commands already authorized by Power Protect's sudoers file.

Because the watchdog runs outside Amphetamine's sandbox, it has its own explicit configuration instead of attempting to read Amphetamine's protected preferences.

## Install

Install Amphetamine and Power Protect first. Then, from a local checkout of this repository, run:

```shell
Source/Watchdog/install.zsh
```

The installer validates both new and preserved configuration, adds a user LaunchAgent, verifies that it remains running, runs a non-mutating health check, and prints its initial status. It does not modify the existing Power Protect AppleScript or sudoers file.

Start a new Amphetamine Closed-Display Mode session after installing. The watchdog deliberately will not guess that an already-reset `SleepDisabled=0` belonged to a closed-display session; it must observe Power Protect's initial `SleepDisabled=1` before it can reassert that session safely.

## Configure

The configuration file is located at:

```text
~/Library/Application Support/Amphetamine/Power Protect Watchdog/config.plist
```

Set `Enabled` to `false` to stop managing Closed-Display Mode. The enabled-to-disabled transition performs one cleanup, then records that cleanup so the disabled watchdog does not continuously fight another power manager. Change `LowBatteryPercent` to a value from 5 through 95 to adjust the safety threshold. Invalid or unreadable configuration fails the health check and releases watchdog-managed state.

`ResetSleepWhenInactive` defaults to `true`. Set it to `false` only if another tool intentionally uses `pmset disablesleep` while Amphetamine has no active session; watchdog-owned state is still cleaned up.

Changes are read on every reconciliation and do not require restarting the LaunchAgent.

## Status

```shell
~/Library/Application\ Support/Amphetamine/Power\ Protect\ Watchdog/power-protect-watchdog.zsh --status
```

## Uninstall

From the same repository checkout, run:

```shell
Source/Watchdog/uninstall.zsh
```

Uninstalling independently restores and verifies normal system sleep when `ResetSleepWhenInactive` is enabled (or when the watchdog owns the current state), even if the watchdog executable is missing. If cleanup cannot be verified, uninstall stops and preserves the watchdog files for recovery.

## Tests

```shell
Tests/watchdog-tests.zsh
```

The tests use fake `pmset`, `sudo`, `launchctl`, `touch`, and logging implementations and do not change the Mac's real power-management settings. They cover assertion arming, ordinary-session opt-out, reassertion, large assertion output, assertion identity changes, inactive cleanup, low-battery and unreadable-power fail-safe behavior, marker and authorization failures, active-console-user handoff, configuration validation, health checks, installer behavior, and real uninstaller control flow.

> [!WARNING]
> Closed-display operation continues to consume power and generate heat. End the Amphetamine session before putting a MacBook in a bag or other enclosed space.
