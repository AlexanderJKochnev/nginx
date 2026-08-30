# защита по белым спискам
## ${BIND_VOLUMES}/nginx_shared:/app/shared_nginx_config/auto_routes.conf

1. по указанному выше пути при каждом перезапуске fastapi генерируется список белых путей.
2. доступ к которым разрешен.
3. поcле каждого изменения путей нужно перезапускать fastapi и docker-compose restart nginx-gateway

## три файла настроек
      - ./nginx/swagger_admin.conf:/etc/nginx/swagger_admin.conf:ro
      - .nginx/other_apps.conf:/etc/nginx/other_apps.conf:ro

## Шаг 3. Подключение файла в Nginx
### В самом верху default.conf (вне блока server) создаем карту путей:

map $request_uri $is_allowed {
    default 0;
    
    # 1. То, что разрешено ВСЕГДА и для ВСЕХ сайтов
    "~^/$" 1;                                                            # Корень сайтов
    "~^/ntfy($|/)" 1;                                                    # Наш пуш-сервер ntfy
    "~* \.(js|css|png|jpg|jpeg|gif|svg|ico|json|woff|woff2|webmanifest)$" 1; # Вся статика фронтенда

    # 2. ПОДКЛЮЧАЕМ АВТОМАТИЧЕСКИЙ ФАЙЛ (из FastAPI volume)
    # Укажите ваш правильный путь, по которому Nginx видит этот volume
    include /etc/nginx/auto_routes.conf;

    # 3. ПОДКЛЮЧАЕМ РУЧНЫЕ ФАЙЛЫ
    include /etc/nginx/swagger_admin.conf;
    include /etc/nginx/other_apps.conf;
}
