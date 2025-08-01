#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_SCRIPT="$SCRIPT_DIR/backup_and_send.sh"
ENV_FILE="$SCRIPT_DIR/config.env"

echo "✅ نصب ابزار مورد نیاز..."
apt update && apt install -y zip curl mysql-client

echo "🔐 تنظیم مجوز اسکریپت‌ها..."
chmod 700 "$BACKUP_SCRIPT"
chmod 600 "$ENV_FILE"

echo "🕒 افزودن به cronjob برای اجرای روزانه ساعت 03:00..."
(crontab -l 2>/dev/null; echo "0 3 * * * /bin/bash $BACKUP_SCRIPT >> /var/log/marzban_backup.log 2>&1") | crontab -

echo "🚀 ارسال بکاپ اولیه همین حالا..."
/bin/bash "$BACKUP_SCRIPT"

echo "🎉 نصب کامل شد."
