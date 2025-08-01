#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_SCRIPT="$SCRIPT_DIR/backup_and_send.sh"
ENV_FILE="$SCRIPT_DIR/config.env"

echo "📦 شروع نصب Marzban Backup Bot..."

# بررسی وجود فایل‌ها
if [[ ! -f "$BACKUP_SCRIPT" ]]; then
  echo "❌ فایل $BACKUP_SCRIPT یافت نشد."
  exit 1
fi

if [[ ! -f "$ENV_FILE" ]]; then
  echo "❌ فایل $ENV_FILE یافت نشد."
  exit 1
fi

echo "✅ نصب ابزار مورد نیاز..."
apt update && apt install -y zip curl mysql-client

echo "🔐 تنظیم مجوز اسکریپت‌ها..."
chmod 700 "$BACKUP_SCRIPT"
chmod 600 "$ENV_FILE"

# جلوگیری از تکرار کرون‌جاب
echo "🕒 افزودن کرون‌جاب هر ساعت..."
CRON_JOB="0 */1 * * * /bin/bash $BACKUP_SCRIPT >> /var/log/marzban_backup.log 2>&1"
(crontab -l 2>/dev/null | grep -v "$BACKUP_SCRIPT"; echo "$CRON_JOB") | crontab -

echo "📝 لطفاً تنظیمات فایل config.env را بازبینی و ویرایش کنید:"
nano "$ENV_FILE"

echo "🚀 اجرای اولین بکاپ..."
/bin/bash "$BACKUP_SCRIPT"

echo "🎉 نصب کامل شد."
