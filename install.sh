#!/bin/bash

cp ./rclone-auto-sync.sh ~/.local/bin/rclone-auto-sync.sh
cp ./rclone-auto-sync.service /etc/systemd/system/rclone-auto-sync.service
cp ./rclone-auto-sync.timer /etc/systemd/system/rclone-auto-sync.timer