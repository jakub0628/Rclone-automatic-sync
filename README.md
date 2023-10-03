# About this project

This script used `systemd` to automate bidirectional syncing of Google Drive with a local folder using [Rclone](https://github.com/rclone/rclone). It is only activated after a period of inactivity (10 minutes by default) and displays sync progress using notifications.

## Usage

For Arch Linux:

1. Install all requirements in `requirements.txt` using an appropriate package manager
2. Set up Rclone according to the available documentation
3. Change `/home/kuba/` to your `$HOME` in `rclone-auto-sync.service` (unfortunately environment variables don't work well there)
4. In the `rclone-auto-sync.sh` file export the desired sync command, e.g. `rclone bisync -Plv $GDRIVE gdrive:`, as `rclone_sync` 
5. `cd` into the cloned folder and run `install.sh`, which automatically :
   1. Places files in the following locations (make sure `~/.local/bin/` is added to PATH)
   
    | file                       | location             | role                                       |
    | -------------------------- | -------------------- | ------------------------------------------ |
    | `rclone-auto-sync.sh`      | `~/.local/bin/`      | script performing the synchronisation      |
    | `rclone-auto-sync.service` | `/etc/systemd/user/` | service, which runs the script             |
    | `rclone-auto-sync.time`    | `/etc/systemd/user/` | timer, which runs the service every minute |

   2. Activates the timer using `systemctl start rclone-auto-sync.timer --user`.