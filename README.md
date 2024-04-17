Set Up Your Bot:

Replace "your_bot_token_here" with your Telegram bot's API token.
Replace "your_chat_id_here" with the chat ID where you want to receive alerts. This can be your personal chat with the bot or a group chat.
Configure the Load Threshold:

Set the LOAD_THRESHOLD variable to a value that is appropriate for your server. When the 1-minute load average exceeds this value, the script will send an alert.
Deployment:

Save this script in a file on your server, for example, load_monitor.sh.
Make the script executable with chmod +x load_monitor.sh.
Run the script manually to check if it works correctly.
Automate the Monitoring:

To continuously monitor the load, you can run this script at regular intervals using cron.
Edit your crontab with crontab -e and add a line to run the script every 5 minutes:
javascript
Copy code
```cron */5 * * * * /path/to/monitor.sh```
Adjust the interval according to how frequently you want to check the load.
Note:
Ensure that curl is installed on your server to use it for sending HTTP requests. You can install it using package managers like apt (Debian/Ubuntu) or yum (CentOS).
This script assumes you are familiar with basic shell scripting and cron jobs. If you encounter any permissions issues or have specific configuration requirements, you might need to adjust the script accordingly.
The awk command is used to read the load average directly from /proc/loadavg and compare it to your set threshold. This method is lightweight and generally reliable across different Linux distributions.

Running the Script:
Set the script as executable: ```bash chmod +x script_name.sh ```
Run the script manually or schedule with cron to monitor at regular intervals.
This refactored script ensures that each check is performed correctly and provides clear, actionable alerts via Telegram when thresholds are exceeded. Adjust the thresholds as needed to match your server's operational parameters.

⚠️ High Disk Usage: % ⚠️ Detailed System Usage:

| Название | Объем      | Использовано           |
|----------|------------|------------------------|
| CPU      |            | 0.5%                   |
| RAM      |7825 MB     | 1434 MB (18.3%        )|
| DISK     |            |                        |
