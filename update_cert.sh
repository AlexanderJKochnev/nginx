#!/bin/bash

# обновление cretificate
docker compose run --rm certbot_init certonly --webroot --webroot-path=/var/www/certbot \
      -d abc8888.ru \
      -d api.abc8888.ru \
      -d test.abc8888.ru \
      -d kan.abc8888.ru \
      -d api.test.abc8888.ru \
      --expand;
