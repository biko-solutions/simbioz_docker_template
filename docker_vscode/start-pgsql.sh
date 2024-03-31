#!/bin/bash

WORKSPACE_FOLDER=$1
HOST_PG_PORT=$2

if [ -n "$WORKSPACE_FOLDER" ]; then
  cd "$WORKSPACE_FOLDER"
fi

# Путь к вашему docker-compose.yml
DOCKER_COMPOSE_PATH="docker-compose.yml"

# Проверка, какая команда доступна: docker-compose или docker compose
if command -v docker-compose &>/dev/null; then
    COMPOSE_COMMAND="docker-compose"
elif command -v docker &>/dev/null && docker compose version &>/dev/null; then
    COMPOSE_COMMAND="docker compose"
else
    echo "Neither docker-compose nor docker compose command is available."
    exit 1
fi

echo "Using command: $COMPOSE_COMMAND"

# Проверка, запущен ли уже контейнер PostgreSQL
CONTAINER_RUNNING=$(docker inspect --format="{{.State.Running}}" ams_db 2> /dev/null)

if [ "$CONTAINER_RUNNING" != "true" ]; then
    echo "PostgreSQL container is not running. Starting it..."
    if [ "$COMPOSE_COMMAND" = "docker-compose" ]; then
        docker-compose -f "$DOCKER_COMPOSE_PATH" up -d db
    else
        docker compose -f "$DOCKER_COMPOSE_PATH" up -d db
    fi
else
    echo "PostgreSQL container is already running."
fi

# Ожидание доступности PostgreSQL
python3 ./wait-for-psql.py --db_host=localhost --db_port=$HOST_PG_PORT --db_user=odoo --db_password=odoo --timeout=30
