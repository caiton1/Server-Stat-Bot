# Server-Stat-Bot
A simple and easy to use Ubuntu/Linux utility with discord bot integration that can be used to display various server statistics (memory, cpu, disk) to a discord server. 

## How to use
```./server-stats.sh [--json]```
- Main script for output server stats
- --json optionally outputs the data in json format

```python3 bot.py```
- Runs a bot to report sys statistics to discord channel/chat assuming python3-discord is installed via apt or in python environment
- Need to go to discord developer portal and create a new bot with "Message Content Intent" enabled and copy the Token on the Bot tab

```./install.sh```
- Automated installation script for Debian/Ubuntu based systems
  
```./sysd_uninstall.sh```
- Automated uninstall script for Debian/Ubuntu based systems

## How to install Discord-Python integration
First you will need a discord application:
1. Go to the [Discord developer portal](https://discord.com/developers/applications) and click new application
2. Go to the bot tab and get the token (obtained by clicking copy and/or reset token)
3. Scroll down and enable message content intent
4. Click save changes

If you are on Ubuntu/Debian, I have an installation script that will automate the process and also automatically install the project to systemd:
- run ```./install.sh```

You can manually run the bot by:
1. go into your bash/terminal profile, in ubuntu this will be ~/.bashrc and append ```export DISCORD_TOKEN="YOUR_TOKEN"``` to the end, on startup, this will export your discord token to env
2. run ```python3 bot.py```
3. (optional) if you wish to make your own systemd service, will need to append ```DISCORD_TOKEN="YOUR_TOKEN"``` to /etc/environment on a new line so systemd can see it



### Liscence 
[GPL-3.0 license](https://github.com/caiton1/Server-Stat-Bot/blob/main/LICENSE)
