# About this project

This script used `systemd` to automate bidirectional syncing of Google Drive with a local folder using [Rclone](https://github.com/rclone/rclone). It is only activated after a period of inactivity (10 minutes by default) and displays sync progress using notifications.

## Usage

After setting up Rclone sync according to the available documentation and aliasing the desired command, e.g. `rclone bisync -Plv $GDRIVE gdrive:` to `rclone-sync`, files needs to be placed in the following locations (Arch Linux):

| file                       | location               | role                                       |
| -------------------------- | ---------------------- | ------------------------------------------ |
| `rclone-auto-sync.sh`      | `~/.local/bin/`        | script performing the synchronisation      |
| `rclone-auto-sync.service` | `/etc/systemd/system/` | service, which runs the script             |
| `rclone-auto-sync.time`    | `/etc/systemd/system/` | timer, which runs the service every minute |

Afterwards, the timer is activated using `systemctl enable rclone-auto-sync.timer`.