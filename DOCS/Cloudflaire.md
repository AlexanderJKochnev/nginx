# create telegramm bot
## Шаг 1. Создайте бота и получите ID 
### Напишите боту @BotFather в Telegram, выполните команду /newbot и следуйте инструкциям, чтобы получить токен (например, 123456:ABC-def...).
    перейти по ссылке бота и нажать старт
### Напишите боту @userinfobot или @myidbot, чтобы узнать свой персональный ID чата (например, 987654321).

# Так как telegramm заблокирован - работаем через proxy cloudflaire

# create cloudflaire account
## Зарегистрируйтесь или войдите на сайт Cloudflare
### В левом меню нажмите 
    Workers & Pages -> 
    кнопка Create Application -> 
    Create Worker.Задайте имя (например, tg-proxy-abc8888) и нажмите Deploy.
    Нажмите Edit Code и полностью сотрите стандартный скрипт. Вместо него вставьте этот код-транслятор:
export default {
  async fetch(request, env, ctx) {
    const url = new URL(request.url);
    url.hostname = 'api.telegram.org'; 
    url.port = '';
    const newRequest = new Request(url, request);
    return fetch(newRequest);
  }
};

# конфигурация на сервере
sudo nano /etc/fail2ban/action.d/telegram.conf

[Definition]

# Действие при старте Fail2ban
actionstart = curl -s -X POST "https://tg-proxy-abc8888.akochnev66.workers.dev/bot8886710811:AAGFU1MrJDECM-Pt9cmI1P5XsXYhNeRUUsg/sendMessage" -d "chat_id=656690295" -d "text=🚀 >

# Действие при остановке Fail2ban
actionstop = curl -s -X POST "https://tg-proxy-abc8888.akochnev66.workers.dev/bot8886710811:AAGFU1MrJDECM-Pt9cmI1P5XsXYhNeRUUsg/sendMessage" -d "chat_id=656690295" -d "text=🛑 F>

# Действие при бане IP
actionban = curl -s -X POST "https://tg-proxy-abc8888.akochnev66.workers.dev/bot8886710811:AAGFU1MrJDECM-Pt9cmI1P5XsXYhNeRUUsg/sendMessage" -d "chat_id=656690295" -d "parse_mode>

# Действие при разбане IP (оставляем пустым, чтобы не спамить)
actionunban =

[Init]
init = 'Отправка уведомлений в Telegram'


