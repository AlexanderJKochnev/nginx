#!/bin/bash

docker network create --driver bridge --subnet 172.90.10.0/24 shared_network
docker network create --driver bridge --subnet 172.90.20.0/24 clickhouse_network
docker network create --driver bridge --subnet 172.90.30.0/24 clickhousepg_network
docker network create --driver bridge --subnet 172.90.40.0/24 vllm_network
