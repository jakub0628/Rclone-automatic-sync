#!/bin/bash

rclone_sync="rclone bisync -Plv /run/media/kuba/storage/gdrive gdrive: --dry-run --resync"
sync_after=1000 # 10 minutes

# notify-send "Running!" "$(date +'%F %T')" -a "Rclone automatic sync" -i dialog-ok

connection_check() {
    return ping -q -c1 "google.com" &>/dev/null && echo true || echo false
}


if ! [[ -e /tmp/rclone-synced-flag ]]; then # check if synced since the last time computer was used

    if [[ connection_check ]]; then # check internet connection

        if (( $(xprintidle) > sync_after )); then # check idle time
            touch /tmp/rclone-synced-flag
            NID=$(notify-send "Google Drive sync started" "$(date +'%F %T')" -a "Rclone automatic sync" -i state-sync -u critical -p) # get notification id
            exit_code=$($rclone_sync | tee "$HOME/rclone_sync.log") # perform the actual sync

            if (( $exit_code == 0 )); then # replace notification
                notify-send "Google Drive sync successfully finished" "$(date +'%F %T')" -a "Rclone automatic sync" -i state-ok -u critical -r $NID
            else
                notify-send "Google Drive sync error $exit_code" "$(date +'%F %T')" -a "Rclone automatic sync" -i state-error -u critical -r $NID 
            fi
        fi

    else
        notify-send "Google Drive sync offline" "$(date +'%F %T')" -a "Rclone automatic sync" -i state-offline
    fi

else

    if (( $(xprintidle) < 60000 )); then # computer used after last sync, clear notifications and reset sync status
        notify-send "Cleaning up notifications" -a "Rclone automatic sync" -i edit-clear-history -t 10000
        sleep 10
        notify-send -r $NID " " -t 1
        rm /tmp/rclone-synced-flag
    fi

fi

