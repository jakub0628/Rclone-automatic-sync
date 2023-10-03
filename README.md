# About this project

This script used `systemd` to automate bidirectional syncing of Google Drive with a local folder using [Rclone](https://github.com/rclone/rclone). It is only activated after a period of inactivity (10 minutes by default) and displays sync progress using notifications.

## Usage

For Arch Linux:

1. Install all requirements in `requirements.txt` using an appropriate package manager
2. Set up Rclone according to the available documentation
3. Alias the desired sync command, e.g. `rclone bisync -Plv $GDRIVE gdrive:` to `rclone-sync`
4. `cd` into the cloned folder and run `install.sh` (may require `sudo`), which places files in the following locations (make sure `~/.local/bin/` is added to PATH):

| file                       | location               | role                                       |
| -------------------------- | ---------------------- | ------------------------------------------ |
| `rclone-auto-sync.sh`      | `~/.local/bin/`        | script performing the synchronisation      |
| `rclone-auto-sync.service` | `/etc/systemd/system/` | service, which runs the script             |
| `rclone-auto-sync.time`    | `/etc/systemd/system/` | timer, which runs the service every minute |

5. Activate the timer using `systemctl enable rclone-auto-sync.timer`.