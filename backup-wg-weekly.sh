#!/bin/bash
PROJECT_DIR="/root/wg-easy"
BACKUP_DIR="$PROJECT_DIR/backups/weekly"
DATE=$(date +%Y%m%d)
BACKUP_FILE="$BACKUP_DIR/wg-full_$DATE.tar.gz"

mkdir -p "$BACKUP_DIR"

# Полный бэкап всего проекта
tar -czf "$BACKUP_FILE" -C "$PROJECT_DIR" .

# Удаление старых (>28 дней)
find "$BACKUP_DIR" -name "wg-full_*.tar.gz" -type f -mtime +28 -delete

# Отправка в Яндекс.Диск
/usr/bin/rclone copy "$BACKUP_FILE" yandex:vpn-backups/weekly/
