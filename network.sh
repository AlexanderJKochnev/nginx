#!/bin/bash

docker network create shared_network
docker network create clickhouse_network
docker network create clickhousepg_network
docker network create vllm_network
