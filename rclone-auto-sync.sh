#!/bin/bash

sync_after=600000 # 10 minutes

connection_check() {
    return ping -q -c1 "google.com" &>/dev/null && echo true || echo false
}

if ! (( $synced )); then # check if synced since the last time computer was used

    if [[ connection_check ]]; then # check internet connection

        if (( $(xprintidle) > sync_after )); then # check idle time
            NID=$(notify-send "Google Drive sync started" "$(date +'%F %T')" -a "Rclone automatic sync" -i state-sync -u critical -p) # get notification id
            exit_code=$(rclone-sync --dry-run --resync | tee "$HOME/rclone_sync.log") # perform the actual sync

            if (( $exit_code == 0 )); then # replace notification
                notify-send "Google Drive sync successfully finished" "$(date +'%F %T')" -a "Rclone automatic sync" -i state-ok -u critical -r $NID
            else
                notify-send "Google Drive sync error $exit_code" "$(date +'%F %T')" -a "Rclone automatic sync" -i state-error -u critical -r $NID 
            fi

            synced=1
        fi

    else
        notify-send "Google Drive sync offline" "$(date +'%F %T')" -a "Rclone automatic sync" -i state-offline
    fi

else

    if (( $(xprintidle) < 60000 )); then # computer used after last sync, clear notifications and reset sync status
        notify-send "Cleaning up notifications" -a "Rclone automatic sync" -i edit-clear-history -t 10000
        sleep 10
        notify-send -r $NID " " -t 1
        synced=0
    fi

fi
