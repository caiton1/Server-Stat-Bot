#!/bin/bash

SERVICE_NAME="discord-bot"
ENV_FILE="/etc/environment"

echo "Stopping systemd service..."
sudo systemctl stop "$SERVICE_NAME"
sudo systemctl disable "$SERVICE_NAME"

echo "Removing systemd service..."
sudo rm -f "/etc/systemd/system/$SERVICE_NAME.service"

echo "Reloading systemd daemon..."
sudo systemctl daemon-reload
sudo systemctl reset-failed

echo "Removing DISCORD_TOKEN from /etc/environment..."
sudo sed -i '/^DISCORD_TOKEN=/d' "$ENV_FILE"

echo "Uninstallation complete!"
echo "verify using: sudo systemctl list-units --type=service | grep discord"
