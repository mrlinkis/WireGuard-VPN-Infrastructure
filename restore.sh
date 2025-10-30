#!/bin/bash
set -e  # Остановить при любой ошибке

if [ $# -eq 0 ]; then
  echo "Использование: $0 <путь_к_архиву.tar.gz>"
  echo "Пример: ./restore.sh emergency-exit-full-backup-20251019.tar.gz"
  exit 1
fi

ARCHIVE="$1"

if [ ! -f "$ARCHIVE" ]; then
  echo "Ошибка: архив '$ARCHIVE' не найден."
  exit 1
fi

echo "🚀 Восстановление 'Запасного Выхода' из $ARCHIVE..."

# Создаём временную папку
TMP_DIR="/tmp/emergency-exit-restore-$$"
mkdir -p "$TMP_DIR"

# Распаковываем
tar -xzf "$ARCHIVE" -C "$TMP_DIR"

# Находим папку внутри (обычно full-snapshot-YYYYMMDD)
SRC_DIR=$(find "$TMP_DIR" -type d -name "full-snapshot-*" | head -n1)

if [ -z "$SRC_DIR" ]; then
  echo "Ошибка: не найдена папка full-snapshot-* в архиве."
  exit 1
fi

# Копируем всё в текущую директорию
cp -r "$SRC_DIR"/* .

# Восстанавливаем права (на всякий)
chown -R root:root wg-data/
chmod +x backup-wg-daily.sh backup-wg-weekly.sh

# Останавливаем старый контейнер (если есть)
docker-compose down 2>/dev/null || true

# Запускаем
docker-compose up -d

echo "✅ WireGuard запущен. Проверяйте веб-панель: http://$(hostname -I | awk '{print $1}'):51821"

# Проверяем, есть ли бот
if [ -f bot.py ]; then
  echo "🤖 Бот найден. Запустите его вручную или через systemd."
fi

echo "💡 Не забудьте:"
echo "  - Проверить, что порты 51820/udp и 51821/tcp открыты"
echo "  - Восстановить systemd-сервис для бота (если был)"
echo "  - Запустить ./backup-wg-daily.sh для первого бэкапа"

# Удаляем временные файлы
rm -rf "$TMP_DIR"

echo "🔥 Восстановление завершено."