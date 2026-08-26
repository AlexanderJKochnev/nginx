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
# защита nftables
banaction = nftables[type=multiport]

# Фильтр на частые ошибки 404 (поиск админок, уязвимостей, как в логах с .git/config)
[nginx-noscript]
enabled  = true
port     = http,https
filter   = nginx-noscript
logpath  = /var/log/nginx/access.log
maxretry = 3
banaction = nftables[type=multiport, ports="80,443"]

# Стандартная защита от DDOS / частых запросов
[nginx-http-auth]
enabled  = true
port     = http,https
filter   = nginx-http-auth
logpath  = /var/log/nginx/error.log

# вечные баны для рецидивистов
[recidive]
enabled   = true
logpath   = /var/log/fail2ban.log
filter    = recidive
# Повторный бан на 1 год (31536000 секунд) или поставьте -1 для вечного бана
bantime   = 31536000
# Искать рецидивистов среди тех, кто был забанен за последние сутки
findtime  = 86400
# Если бот попал в бан 2 раза за сутки, отправляем его в долгосрочный бан
maxretry  = 2

# Блокируем ВСЁ для брутфорсеров
[sshd]
enabled  = true
port     = 9229,22
filter   = sshd
logpath  = /var/log/auth.log
maxretry = 3
banaction = nftables[type=multiport]  

# Блокируем агентов-плохишей по имени
[nginx-badagents]
enabled  = true
port     = http,https
filter   = nginx-badagents
logpath  = /var/log/nginx/access.log
# Баним сразу после 1-й попытки
maxretry = 1
banaction = nftables[type=multiport, ports="80,443"]



## Шаг 4. Настройка фильтра регулярных выражений
sudo nano /etc/fail2ban/filter.d/nginx-noscript.conf
[Definition]
failregex = ^<HOST> -.*"GET .*\.(php|asp|aspx|exe|pl|cgi|git|env|yaml|yml).* HTTP/.*" 404
            ^<HOST> -.*"GET /wp-.* HTTP/.*" 404
            ^<HOST> -.*"GET /admin.* HTTP/.*" 404

ignoreregex =
### --- РАСШИРЕННАЯ ВЕРСИЯ ---

[Definition]
failregex = ^<HOST> -.*"GET .*\.(php|asp|aspx|exe|pl|cgi|git|env|yaml|yml|tfstate|npmrc|git-credentials).* HTTP/.*" (200|301|403|404)
            ^<HOST> -.*"GET /(wp-|-query|wp-admin|admin|manager).* HTTP/.*" (200|301|403|404)
            ^<HOST> -.*"POST /(cgi-bin|bin).* HTTP/.*" (400|403|404)

ignoreregex =

## Шаг 4.2. фильтр плохишей (баним по именам ботов)
sudo nano /etc/fail2ban/filter.d/nginx-badagents.conf

Definition]
failregex = ^<HOST> -.*"GET .* HTTP/.*" \d+ \d+ "-" ".*(zgrab|l9explore|l9tcpid|masscan|sqlmap|nmap|python-requests).*"
ignoreregex =


## Шаг 5. Запуск и проверка

sudo systemctl restart fail2ban
sudo systemctl enable fail2ban

## Команды для контроля работы:
### Посмотреть статус и список активных защит (jail):
sudo fail2ban-client status

### Проверить существующий лог на наличие вредителей выяляемых конкретной защитой
fail2ban-regex /var/log/nginx/access.log /etc/fail2ban/filter.d/nginx-noscript.conf
fail2ban-regex /var/log/nginx/access.log /etc/fail2ban/filter.d/nginx-badagents.conf



### Посмотреть детальный статус бана для конкретного фильтра (например, сколько IP сейчас заблокировано в nginx-noscript):
sudo fail2ban-client status nginx-noscript
sudo fail2ban-client status nginx-http-auth
sudo fail2ban-client status nginx-badagents
sudo fail2ban-client status recidive
sudo fail2ban-client status sshd

### посмотреть забаненные ip
sudo grep "Ban" /var/log/fail2ban.log




### Разбанить IP адрес вручную, если вы случайно заблокировали себя при тестах:
sudo fail2ban-client set nginx-noscript unbanip 94.242.168.162

# подключение бота телеграмм
userid 656690295
