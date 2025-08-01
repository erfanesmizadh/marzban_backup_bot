#!/bin/bash

# بارگذاری تنظیمات
ENV_PATH="$(dirname "$0")/config.env"
if [ ! -f "$ENV_PATH" ]; then
  echo "❌ فایل config.env پیدا نشد!"
  exit 1
fi
source "$ENV_PATH"

# تنظیم مسیرها
BACKUP_DIR="/root/marzban_backups"
NOW=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_NAME_1="marzban_backup_${NOW}.sql"
BACKUP_NAME_2="marzhelp_backup_${NOW}.sql"
ZIP_NAME="Backp_Erfan_${NOW}.zip"

# مسیر فقط-فایل‌ها
FILES_TO_BACKUP=(
  "/var/lib/marzban/xray_config.json"
)

# مسیرهایی که باید به‌صورت کامل (دایرکتوری) بکاپ گرفته شوند
DIRS_TO_BACKUP=(
  "/var/lib/marzban/certs/"
  "/opt/marzban/"
  "/var/lib/marzban/mysql/marzhelp/"
  "/var/lib/marzban/mysql/marzban/"
)

# ایجاد پوشه بکاپ
mkdir -p "$BACKUP_DIR"
cd "$BACKUP_DIR" || exit

# گرفتن بکاپ دیتابیس marzban
if ! mysqldump -u "$DB_USER" -p"$DB_PASS" -h "$DB_HOST" "marzban" > "$BACKUP_NAME_1"; then
  echo "❌ خطا در گرفتن بکاپ دیتابیس marzban!"
  exit 2
fi

# گرفتن بکاپ دیتابیس marzhelp
if ! mysqldump -u "$DB_USER" -p"$DB_PASS" -h "$DB_HOST" "marzhelp" > "$BACKUP_NAME_2"; then
  echo "❌ خطا در گرفتن بکاپ دیتابیس marzhelp!"
  exit 2
fi

# ساخت فایل zip شامل هر دو بکاپ دیتابیس
zip "$ZIP_NAME" "$BACKUP_NAME_1" "$BACKUP_NAME_2"

# افزودن فایل‌های تکی
for file in "${FILES_TO_BACKUP[@]}"; do
  if [ -f "$file" ]; then
    zip -j "$ZIP_NAME" "$file"
  else
    echo "⚠️ فایل پیدا نشد: $file"
  fi
done

# افزودن دایرکتوری‌ها
for dir in "${DIRS_TO_BACKUP[@]}"; do
  if [ -d "$dir" ]; then
    zip -r "$ZIP_NAME" "$dir"
  else
    echo "⚠️ پوشه پیدا نشد: $dir"
  fi
done

# ارسال به تلگرام
RESPONSE=$(curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendDocument" \
  -F chat_id="$CHAT_ID" \
  -F document=@"$ZIP_NAME" \
  -F caption="📦 Marzban + Marzhelp Backup - $NOW")

# بررسی موفقیت ارسال
if [[ "$RESPONSE" != *'"ok":true'* ]]; then
  echo "❌ ارسال بکاپ به تلگرام با خطا مواجه شد!"
  exit 3
fi

# پاکسازی فایل‌ها
rm -f "$BACKUP_NAME_1" "$BACKUP_NAME_2" "$ZIP_NAME"

