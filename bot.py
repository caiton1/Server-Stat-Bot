import subprocess
import discord
from discord.ext import commands
import json
import os
import socket
import requests

# ==== BOT ==== #

TOKEN = os.getenv("DISCORD_TOKEN")

intents = discord.Intents.default()
intents.message_content = True

bot = commands.Bot(command_prefix='!', intents=intents)

@bot.command()
async def stats(ctx):
    await ctx.send(get_stats())


# on start up
@bot.event
async def on_ready():
    print(f'{bot.user} is now running!')

# ==== SYS ==== #
def get_stats():
    result = subprocess.run(["./server-stats.sh", "--json"], capture_output=True, text=True)
    stats = json.loads(result.stdout)
    private_ip = get_private_ip()  
    public_ip = get_public_ip()    
    
    result = f"""## Server Stats :desktop:
Private IPv4        : {private_ip}
Public IPv4         : {public_ip}
CPU Usage         : {stats['cpu_usage']}%
Memory Usage  : {stats['memory']['used']} MiB / {stats['memory']['total']} MiB
Uptime                 : {stats['uptime']}

"""

    result += "**Top 5 CPU Usage:**\n```"
    
    for proc in stats['top_cpu_processes']:
        result += f"\n{proc}"

    result += "```**Top 5 Mem Usage:**\n```"
    
    for proc in stats['top_mem_processes']:
        result += f"\n{proc}"
    result += "```"
    return result

def get_private_ip():
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("1.1.1.1", 80))
        private_ip = s.getsockname()[0]
        s.close()
        return private_ip
    except Exception as e:
        return "0.0.0.0"

def get_public_ip():
    try:
        response = requests.get("https://api64.ipify.org?format=text", timeout=10)
        return response.text
    except:
        return f"Error in get_public_ip: {e}"



bot.run(TOKEN)
