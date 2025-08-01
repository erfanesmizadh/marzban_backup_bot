# Marzban Backup Bot

📦 اسکریپت بکاپ‌گیری خودکار از پنل Marzban و ارسال به ربات تلگرام

## ویژگی‌ها

- بکاپ‌گیری از مسیرهای مهم Marzban (تنظیمات، دیتابیس، گواهینامه‌ها و ...)
- ارسال بکاپ‌ها به ربات تلگرام
- امکان اجرای زمان‌بندی‌شده با Cronjob
- پشتیبانی از Telegram Bot API

## طریقه استفاده
1. فایل Marzban Backup Bot آپلود کنین داخل مسیر Root سرور مجازی خود.
2. فایل `config.env` را با ویرایشگر nano تنظیم کنید.از شما اطلاعات دیتابیس بیش مرزبان شما و میخادش.
3. اسکریپت `backup_and_send.sh` را اجرا کنید.
4. اسکریپت `install.sh` را اجرا کنید.
5. (اختیاری) کرون‌جاب تنظیم کنید برای اجرای خودکار روزانه.

## اجرای سریع

```bash
wget https://github.com/erfanesmizadh/marzban_backup_bot/archive/refs/heads/main.zip
unzip main.zip
cd marzban_backup_bot-main
chmod marzban_backup_bot-main
chmod +x backup_and_send.sh
bash install.sh

