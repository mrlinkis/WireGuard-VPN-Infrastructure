#!/bin/bash
PROJECT_DIR="/root/wg-easy"
BACKUP_DIR="$PROJECT_DIR/backups/daily"
DATE=$(date +%Y%m%d)
BACKUP_FILE="$BACKUP_DIR/wg-data_$DATE.tar.gz"

mkdir -p "$BACKUP_DIR"

# Бэкап wg-data
tar -czf "$BACKUP_FILE" -C "$PROJECT_DIR" wg-data

# Удаление старых (>14 дней)
find "$BACKUP_DIR" -name "wg-data_*.tar.gz" -type f -mtime +14 -delete

# Отправка в Яндекс.Диск
/usr/bin/rclone copy "$BACKUP_FILE" yandex:vpn-backups/daily/
