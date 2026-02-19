## NGINX для проектов на сервере
порядок запуска:

1. создание внешней сети
   1. docker network create shared_network
2. запуск nginx
   1. docker compose up --build -d
3. во всех docker-compose указать:
   1. в конце файла:
      networks:
         shared_network:
            external: true
   2. в каждом сервисе:
      networks:
      - shared_network
        - aliases:
          - app-2   # наименование сервиса + какое-то id одинаковое для всех в это проекте (у каждого проекта свое) 
4. проверка существования сети:
   1. docker network ls
   2. В конфигурации Nginx вы будете обращаться по алиасам, а не по внутренним именам проектов:
   # Проект 1
   server {
       server_name project1.yourdomain.com;
       location / {
           proxy_pass http://app-1:8000;  # обращение по алиасу
       }
   }

   # Проект 2
   server {
       server_name project2.yourdomain.com;
       location / {
           proxy_pass http://app-2:8000;  # обращение по алиасу
       }
   }