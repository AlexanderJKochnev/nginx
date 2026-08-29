# файлы настройки fail2ban

## конфигурация (Jail)
sudo nano /etc/fail2ban/jail.local

## фильтр регулярных выражений
sudo nano /etc/fail2ban/filter.d/nginx-noscript.conf

## фильтр плохишей (баним по именам ботов)
sudo nano /etc/fail2ban/filter.d/nginx-badagents.conf


# ПОРЯДОК ДЕЙСТВИЙ ПРИ ОБНАРУЖЕНИИ АТАК

## Шаг 1. Добавить блокировку Exchange-путей в Nginx
    nginx/blockips.conf

## Шаг 2. Обучить Fail2ban ловить этих ботов
    nano /etc/fail2ban/filter.d/nginx-noscript.conf

## Шаг 3. Внести <Имя бота> в черный список плохих ботов
    nano /etc/fail2ban/filter.d/nginx-badagents.conf

## Шаг 4. Перезапуск и проверка
    nginx -t
    systemctl restart fail2ban
