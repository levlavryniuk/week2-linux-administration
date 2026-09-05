# Week 2 Homework — Linux Administration & Shell Scripting

## 1. `backup.sh`

`backup.sh <directory>` validates the argument, then creates a timestamped
`.tar.gz` archive next to the source directory (e.g. `docs_20260905_150141.tar.gz`).

- `set -euo pipefail` — exits on errors, unset variables, and failed pipes
- Every variable is quoted
- Invalid input → clear message on stderr + `exit 1`
- Every run (success **and** failure) is logged with a timestamp to
  `/var/log/backup.log` (falls back to `~/backup.log` when not writable by the user)

## 2. Crontab line

Runs daily at 14:15 (system local time, EEST):

```cron
# ┌───────── minute (0–59)        → 15: run at minute 15
# │ ┌─────── hour (0–23)          → 14: at 14:15 daily (EEST)
# │ │ ┌───── day of month (1–31)  → *: every day
# │ │ │ ┌─── month (1–12)         → *: every month
# │ │ │ │ ┌─ day of week (0–7)    → *: every weekday (0 and 7 = Sunday)
15 14 * * * /home/levi/University/cloud-and-devops-fundamentals/week2-linux-administration/backup.sh /home/levi/Documents
```

To install:

```bash
crontab -e   # paste the line above
crontab -l   # verify it was saved
```

## 3. Sample log output

Produced by testing the script (success, missing directory, missing argument):

```text
[2026-09-05 15:01:41] SUCCESS: backed up '/tmp/demo-src' to '/tmp/demo-src_20260905_150141.tar.gz'
[2026-09-05 15:01:41] FAILED: '/nonexistent' is not an existing directory
[2026-09-05 15:01:41] FAILED: expected exactly 1 argument (a directory path)
```

## 4. Service log analysis (`systemctl` + `journalctl`)

Inspected with `systemctl status NetworkManager.service` and
`journalctl -u NetworkManager.service -n 15`.

Recent `NetworkManager` log entries show the Wi-Fi device `wlan0` cycling
through supplicant states (`disconnected → inactive → interface_disabled`)
and rotating its hardware (MAC) address during scans. This is normal,
expected behaviour: NetworkManager is background-scanning for available
networks with MAC randomisation enabled, and there are no errors or failed
state transitions in the log.
