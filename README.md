## NGINX для проектов на сервере
порядок запуска:

1. создание внешней сети
   1. docker network create nginx_network
2. запуск nginx
   1. docker compose up --build -d
