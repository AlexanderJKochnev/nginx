# настройки NGINX защита
после git push/pull выполнить
docker compose restart nginx_gateway

## block_scanners.conf: 
    Общие правила блокировки сканеров для всех доменов и субдоменов

## blockips.conf
    Запрет доступа к любым скрытым файлам и папкам (.git, .env и т.д.)

## rate_limits.conf
    лимиты на частоту запросов

## robots_shared.conf
    Общие правила для отдачи robots.txt на всех доменах