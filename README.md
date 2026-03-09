## NGINX для проектов на сервере
порядок запуска:

1. ~~создание внешней сети~~
   1. ~~docker network create shared_network~~
2. запуск nginx
   1. docker compose up --build -d
3. обновление сертификата после добавления subdomain
   1. добавить subdomain в docker-compose.yaml 
   2. docker-compose -f docker-compose.yaml down 
   3. docker volume rm nginx_gateway_certs_data 
   4. docker-compose -f docker-compose.yaml up -d
4. настройка паролей
   1. sudo apt-get update && sudo apt-get install apache2-utils -y
   2. htpasswd -c .htpasswd <your_username> в директории nginx
   3. добавить в docker-compose - ./.htpasswd:/etc/nginx/.htpasswd:ro # файл паролей
   4. обновить location того что защищаем
      # Авторизация
      auth_basic "Netdata Private Area";
      auth_basic_user_file /etc/nginx/.htpasswd;

5. 


