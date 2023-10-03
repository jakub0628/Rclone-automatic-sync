#!/bin/bash

cp ./rclone-auto-sync.sh $HOME/.local/bin/rclone-auto-sync.sh
sudo cp ./rclone-auto-sync.service /etc/systemd/user/rclone-auto-sync.service
sudo cp ./rclone-auto-sync.timer /etc/systemd/user/rclone-auto-sync.timer
systemctl --user daemon-reload
systemctl --user start rclone-auto-sync.timer 