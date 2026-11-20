## NGINX для проектов на сервере

РУЧНОЙ ПЕРЕВЫПУСК СЕРТИФИКАТА (ЕСЛИ НЕ СРАБОТАЛА АВТОМАТИКА)
source .env && docker run --rm \
  -v "${BIND_VOLUMES}/nginx/certs_data:/etc/letsencrypt" \
  -v "${BIND_VOLUMES}/nginx/certbot_www:/var/www/certbot" \
  certbot:local certonly --webroot \
  -w /var/www/certbot \
  --cert-name abc8888.ru \
  --expand \
  --non-interactive --agree-tos --email admin@abc8888.ru \
  -d abc8888.ru \
  -d api.abc8888.ru \
  -d test.abc8888.ru \
  -d kan.abc8888.ru \
  -d mmx1.abc8888.ru \
  -d mmx2.abc8888.ru \
  -d mmx3.abc8888.ru \
  -d api.test.abc8888.ru \
  -d tat.abc8888.ru \
  && docker exec nginx_gateway nginx -s reload


порядок запуска:

1. ~~создание внешней сети~~
   1. ~~docker network create shared_network~~
2. запуск nginx
   1. docker compose up --build -d
3. обновление сертификата после добавления subdomain
   1. добавить subdomain в docker-compose.yaml 
   2. docker-compose -f docker-compose.yaml down 
   3. sudo rm /mnt/hdd_data/@named_volumes/nginx/certs_data
   4. docker-compose -f docker-compose.yaml up -d
4. настройка паролей
   1. sudo apt-get update && sudo apt-get install apache2-utils -y
   2. htpasswd -c .htpasswd <your_username> в директории nginx
   3. добавить в docker-compose - ./.htpasswd:/etc/nginx/.htpasswd:ro # файл паролей
   4. обновить location того что защищаем
      # Авторизация
      auth_basic "Netdata Private Area";
      auth_basic_user_file /etc/nginx/.htpasswd;
## TROUBLESHOOTING
5. Проверка настроек:
   1. docker exec -it nginx_gateway sh
   2. cat /etc/nginx/nginx.conf
   3. cat /etc/nginx/conf.d/default.conf
6. Проверка сетей
   1. docker network ls 
   2. docker inspect nginx_gateway | grep Networks -A 10
   3. docker inspect test-app-1 | grep Networks -A 10
