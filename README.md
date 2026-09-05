# Week 2 - Linux Administration & Shell Scripting

## backup.sh

Usage: ./backup.sh <directory>

Validates the argument, then creates <name>_<timestamp>.tar.gz in the current
directory. set -euo pipefail is on, all variables quoted, invalid input exits 1
with a message on stderr. Every run (success or failure) is logged with a
timestamp to ~/backup.log.

## Crontab

Runs daily at 14:15 (system local time, EEST):

15 14 ** * /home/levi/University/cloud-and-devops-fundamentals/week2-linux-administration/backup.sh /home/levi/Documents

Fields:

- 15       minute (run at :15)
- 14       hour (at 14:15)
- -        every day of month
- -        every month
- -        every weekday

Install with: crontab -e, then verify with crontab -l.

## Sample log output

[2026-09-05 15:07:28] SUCCESS: backed up demo-src to demo-src_20260905_150728.tar.gz
[2026-09-05 15:07:28] FAILED: invalid input
[2026-09-05 15:07:28] FAILED: invalid input

## Service log analysis (systemctl + journalctl)

Inspected NetworkManager.service with systemctl status and
journalctl -u NetworkManager.service -n 15.

The log shows my wifi (wlan0) connecting and disconnecting and changing its
MAC address from time to time. This is normal: NetworkManager regularly scans
for wifi networks and picks a new random MAC address each time, and there are
no errors in the log.
