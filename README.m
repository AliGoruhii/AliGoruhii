import telebot
from telebot import types
import requests
import os 
TOKEN = '6386699268:AAEyV5x16jmEGM3bo2M46DPKoxGBh3tveaU'
 bot = telebot.TeleBot(TOKEN) 
# Dictionary for language selection
 languages = {
 'en': {'welcome': 'Welcome to the bot!', 'join_chanel': 'Join our sponsor channel:', 'unknown_command': 'Unknown command. Type /help to see available commands.'},
 'fa': {'welcome': 'به ربات خوش آمدید!', 'join_channel': 'برای دسترسی به تمام امکانات، لطفاً به کانال حامی بپیوندید:', 'unknown_command': 'دستور نامشخص. برای مشاهده دستورات موجود، /help را تایپ کنید.'},
 'ar': {'welcome': 'مرحبًا بك في البوت!', 'join_channel': 'انضم إلى قناة الراعي للوصول إلى جميع الميزات:', 'unknown_command': 'أمر غير معروف. اكتب /help لرؤية الأوامر المتاحة.'}
 }
 @bot.message_handler(commands=['start'])
 def choose_language(message):
 markup = types.ReplyKeyboardMarkup(one_time_keyboard=True)
 markup.add(types.KeyboardButton('English'), types.KeyboardButton('فارسی'), types.KeyboardButton('عربي'))
 bot.send_message(message.chat.id, "Please select your language:", reply_markup=markup)
 @bot.message_handler(func=lambda message: True)
 def handle_language_selection(message): 
language = message.text.lower() 
if language in languages:
 bot.send_message(message.chat.id, languages[language]['welcome'])
 show_main_menu(message)
 else:
 bot.send_message(message.chat.id, "Language not recognized. Please select a language from the keyboard.")
 def show_main_menu(message):
 markup = types.ReplyKeyboardMarkup(row_width=2)
 download_button = types.KeyboardButton('/download')
 stats_button = types.KeyboardButton('/stats')
 explore_button = types.KeyboardButton('/explore')
 markup.add(download_button, stats_button, explore_button)
 bot.send_message(message.chat.id, "Main menu:", reply_markup=markup) 
@bot.message_handler(commands=['download'])
 def download_instagram_media(message):
 user_input = message.text.split(' ', 1)
 if len(user_input) == 2:
 insta_link = user_input[1]
 response = requests.get(insta_link)
 if response.status_code == 200:
 file_extension = insta_link.split('.')[-1]
 file_name =f'media.{file_extension}'
 with open(file_name, 'wb') as f:
 f.write(response.content)
 with open(file_name, 'rb') as f:
 bot.send_document(message.chat.id, f)
 os.remove(file_name)
 else:
 bot.reply_to(message, "Couldn't download the media.")
 @bot.message_handler(commands=['stats'])
 def show_bot_stats(message):
 total_users = bot.get_chat_members_count(message.chat.id)
 bot.reply_to(message, f"Total users: {total_users}")
 @bot.message_handler(commands=['explore'])
 def explore(message):
bot.send_message(message.chat.id, "Let's embark on an exciting exploration journey!")
 @bot.message_handler(func=lambda message: True, content_types=['text'])
 def unknown_command(message):
 bot.reply_to(message, languages['en']['unknown_command'])
bot.polling()
