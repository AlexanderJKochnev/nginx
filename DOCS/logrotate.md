# ротация логов

# ВАРИАНТ ДЛЯ docker c проброшенными портами
## sudo nano /etc/logrotate.d/nginx
/var/log/nginx/*.log {
    daily
    missingok
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 1000 1000
    sharedscripts
    postrotate
        docker exec nginx_gateway nginx -s reopen >/dev/null 2>&1
    endscript
}

# проверка и принудительный запуск
ls -l /var/log/nginx/
sudo logrotate -f /etc/logrotate.d/nginx
ls -l /var/log/nginx/

