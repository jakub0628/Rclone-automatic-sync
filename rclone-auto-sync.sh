#!/bin/bash

sync_after=600000 # 10 minutes

connection_check() {
    ping -q -c1 "google.com" &>/dev/null && echo true || echo false
}

rclone_sync(){
    rclone bisync -lv --drive-skip-gdocs "/run/media/kuba/storage/gdrive" gdrive: | tee "$HOME/.rclone_sync.log"
}

get_nid() {
    echo $(cat /tmp/rclone-nid)
}

# notify-send "Running!" "$(date +'%F %T')" -a "Rclone automatic sync" -i dialog-ok
touch /tmp/rclone-running-flag

if ! [[ -e /tmp/rclone-synced-flag ]]; then # check if synced since the last time computer was used

    if [[ connection_check ]]; then # check internet connection

        if (( $(xprintidle) > sync_after )); then # check idle time

            notify-send "Google Drive sync started" "$(date +'%F %T')" -a "Rclone automatic sync" -i state-sync -u critical -p > /tmp/rclone-nid # preserve notification id
            rclone_sync # perform the actual sync
            exit_code=$?

            if (( $exit_code == 0 )); then # replace notification
                notify-send "Google Drive sync successfully finished" "$(date +'%F %T')" -a "Rclone automatic sync" -i state-ok -u critical -r $(get_nid)
            else
                notify-send "Google Drive sync error $exit_code" "$(date +'%F %T')" -a "Rclone automatic sync" -i state-error -u critical -r $(get_nid)
            fi

            touch /tmp/rclone-synced-flag
        fi

    else
        notify-send "Google Drive sync offline" "$(date +'%F %T')" -a "Rclone automatic sync" -i state-offline
    fi

else

    if (( $(xprintidle) < 60000 )); then # computer used after last sync, clear notifications and reset sync status
        notify-send "Cleaning up notifications" -a "Rclone automatic sync" -i edit-clear-history -t 10000
        sleep 10
        notify-send " " -t 1 -r $(get_nid)
        rm /tmp/rclone-synced-flag
    fi

fi

rm /tmp/rclone-running-flag