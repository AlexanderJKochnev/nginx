#!/bin/bash

docker network create --driver bridge --subnet 172.90.20.0/24 clickhouse_network
docker network create --driver bridge --subnet 172.90.30.0/24 clickhousepg_network
docker network create --driver bridge --subnet 172.90.40.0/24 vllm_network

# Создаём сети, если их нет
# docker network inspect clickhouse_network &>/dev/null || docker network create --driver bridge --subnet 172.90.20.0/24 clickhouse_network
# docker network inspect clickhousepg_network &>/dev/null || docker network create --driver bridge --subnet 172.90.30.0/24 clickhousepg_network
# docker network inspect vllm_network &>/dev/null || docker network create --driver bridge --subnet 172.90.40.0/24 vllm_network