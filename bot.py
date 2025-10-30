from telegram import Update
from telegram.ext import Application, CommandHandler, ContextTypes
import logging

# Конфиги
TOKEN = "8442525621:AAG0zwe_AO6c0fybEjSQrmurQyL-dx0F_ng"
ADMIN_IDS = [425225520]  # Твой ID
WG_WEB_URL = "http://193.42.112.83:51821"

logging.basicConfig(
    filename='/root/wg-easy/bot.log',
    level=logging.INFO,
    format='%(asctime)s - %(message)s'
)

async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text(
        "🔐 *Запасной Выход — VPN*\n\n"
        "Чтобы получить доступ:\n"
        "1. Напиши мне, что тебе нужен тест\n"
        "2. Я дам тебе ссылку и пароль\n"
        "3. Скачаешь конфиг → подключишься\n\n"
        "Работает мгновенно. Без смс.",
        parse_mode="Markdown"
    )

async def getconfig(update: Update, context: ContextTypes.DEFAULT_TYPE):
    user_id = update.effective_user.id
    if user_id not in ADMIN_IDS:
        await update.message.reply_text("❌ Доступ запрещён.")
        return

    await update.message.reply_text(
        f"🛠️ *Для выдачи конфига:*\n"
        f"1. Зайди в панель: [{WG_WEB_URL}]({WG_WEB_URL})\n"
        f"2. Пароль: `8m11Kin8`\n"
        f"3. Создай пира → скачай .conf\n"
        f"4. Отправь клиенту",
        parse_mode="Markdown",
        disable_web_page_preview=True
    )

def main():
    app = Application.builder().token(TOKEN).build()
    app.add_handler(CommandHandler("start", start))
    app.add_handler(CommandHandler("getconfig", getconfig))
    app.run_polling()

if __name__ == "__main__":
    main()
