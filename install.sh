#!/bin/bash

set -e

# تنظیم آدرس مخزن
REPO_URL="https://github.com/erfan/marzban_backup_bot"
TARGET_DIR="/opt/marzban_backup_bot"

echo "📥 دریافت سورس از GitHub..."
rm -rf "$TARGET_DIR"
git clone "$REPO_URL" "$TARGET_DIR"

cd "$TARGET_DIR"

echo "🚀 اجرای نصب..."
bash internal_install.sh
