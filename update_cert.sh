#!/bin/bash

# обновление cretificate
docker compose run --rm certbot_init certonly --webroot --webroot-path=/var/www/certbot \
      --force-renewal \
      --expand \
      -d abc8888.ru \
      -d api.abc8888.ru \
      -d test.abc8888.ru \
      -d kan.abc8888.ru \
      -d mmx1.abc8888.ru \
      -d mmx2.abc8888.ru \
      -d mmx3.abc8888.ru \
      -d api.test.abc8888.ru \
      -d tat.abc8888.ru;