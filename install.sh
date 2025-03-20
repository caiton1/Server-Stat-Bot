#!/bin/bash

echo "Updating package lists..."
sudo apt update -y

if ! command -v python3 &> /dev/null; then
    echo "Installing Python3..."
    sudo apt install python3 -y
fi

echo "Installing python3-discord..."
sudo apt install -y python3-discord

if [ -z "$DISCORD_TOKEN" ]; then
    read -p "Enter your Discord Bot Token: " TOKEN
    echo "export DISCORD_TOKEN=\"$TOKEN\"" >> ~/.bashrc
    source ~/.bashrc
    echo "DISCORD_TOKEN set successfully."
else
    echo "DISCORD_TOKEN already set."
fi

read -p "Want to install bot.py as a systemd service? (y/N): " INSTALL_SERVICE

if [[ "$INSTALL_SERVICE" =~ ^[Yy]$ ]]; then
    SERVICE_NAME="discord-bot"
    SERVICE_PATH="/etc/systemd/system/$SERVICE_NAME.service"
    EXECUTABLE_PATH="$(realpath bot.py)"
    WORKING_DIR="$(pwd)"

    echo "Creating systemd service..."
    echo "DISCORD_TOKEN=$DISCORD_TOKEN" | sudo tee -a /etc/environment

    sudo bash -c "cat > $SERVICE_PATH" <<EOF
[Unit]
Description=Discord Bot
After=network.target

[Service]
ExecStart=/usr/bin/python3 $EXECUTABLE_PATH
Restart=always
User=$(whoami)
EnvironmentFile=/etc/environment
WorkingDirectory=$WORKING_DIR

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl daemon-reload
    sudo systemctl enable $SERVICE_NAME
    echo "Service installed. Start it using: sudo systemctl start $SERVICE_NAME"
else
    echo "Skiped systemd service installation."
fi

echo "Installation complete! To start the bot manually, run: python3 bot.py"
