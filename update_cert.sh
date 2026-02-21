#!/bin/bash

# обновление cretificate
docker compose run --rm certbot certonly --standalone \
      --non-interactive --agree-tos --email admin@abc8888.ru \
      -d abc8888.ru \
      -d api.abc8888.ru \
      -d test.abc8888.ru \
      -d kan.abc8888.ru \
      -d api.test.abc8888.ru;
