# установка  fail2ban
ставится на хост
## Шаг 1. Настройка логов Nginx в Docker
- /var/log/nginx:/var/log/nginx

## Шаг 2. Установка Fail2ban на хост-сервер 
sudo apt update && sudo apt install fail2ban -y

## Шаг 3. Создание конфигурации (Jail)
sudo nano /etc/fail2ban/jail.local
[DEFAULT]
# Время блокировки (в секундах). 3600 = 1 час
bantime  = 3600
# Окно времени, за которое считаются совпадения (10 минут)
findtime = 600
# Количество разрешенных ошибок перед баном
maxretry = 5

# Фильтр на частые ошибки 404 (поиск админок, уязвимостей, как в ваших логах с .git/config)
[nginx-noscript]
enabled  = true
port     = http,https
filter   = nginx-noscript
logpath  = /var/log/nginx/access.log
maxretry = 3

# Стандартная защита от DDOS / частых запросов
[nginx-http-auth]
enabled  = true
port     = http,https
filter   = nginx-http-auth
logpath  = /var/log/nginx/error.log

## Шаг 4. Настройка фильтра регулярных выражений
sudo nano /etc/fail2ban/filter.d/nginx-noscript.conf
[Definition]
failregex = ^<HOST> -.*"GET .*\.(php|asp|aspx|exe|pl|cgi|git|env|yaml|yml).* HTTP/.*" 404
            ^<HOST> -.*"GET /wp-.* HTTP/.*" 404
            ^<HOST> -.*"GET /admin.* HTTP/.*" 404

ignoreregex =

## Шаг 5. Запуск и проверка

sudo systemctl restart fail2ban
sudo systemctl enable fail2ban

## Команды для контроля работы:
### Посмотреть статус и список активных защит (jail):
sudo fail2ban-client status

### Посмотреть детальный статус бана для конкретного фильтра (например, сколько IP сейчас заблокировано в nginx-noscript):
sudo fail2ban-client status nginx-noscript

### Разбанить IP адрес вручную, если вы случайно заблокировали себя при тестах:
sudo fail2ban-client set nginx-noscript unbanip НАШ_IP_АДРЕС
