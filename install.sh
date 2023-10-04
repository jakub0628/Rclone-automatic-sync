#!/bin/bash

cp ./rclone-auto-sync.sh $HOME/.local/bin/rclone-auto-sync.sh
sudo cp ./rclone-auto-sync.service /etc/systemd/user/rclone-auto-sync.service
sudo cp ./rclone-auto-sync.timer /etc/systemd/user/rclone-auto-sync.timer
systemctl --user daemon-reload # reloads systemd
systemctl --user enable rclone-auto-sync.timer # set up autostart
systemctl --user start rclone-auto-sync.timer # start it now