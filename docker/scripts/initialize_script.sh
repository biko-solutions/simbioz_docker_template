#!/bin/sh

# Получаем имя текущего каталога
CURRENT_DIR=$(basename "$PWD")
# Путь к файлу .env
ENV_FILE=".env"

# Проверяем, существует ли файл .env
if [ ! -f "$ENV_FILE" ]; then
    # Если файла нет, создаем его и записываем значение COMPOSE_PROJECT_NAME
    echo "COMPOSE_PROJECT_NAME=$CURRENT_DIR" >"$ENV_FILE"
else
    # Проверяем, задано ли значение для COMPOSE_PROJECT_NAME и корректно ли оно
    if ! awk -F= '/^COMPOSE_PROJECT_NAME=/{exit !($2)}' "$ENV_FILE"; then
        # Если значение не задано или некорректно, обновляем или добавляем его
        if grep -q "^COMPOSE_PROJECT_NAME=" "$ENV_FILE"; then
            # Значение некорректно, обновляем его
            sed -i'' -e "/^COMPOSE_PROJECT_NAME=/c\COMPOSE_PROJECT_NAME=$CURRENT_DIR" "$ENV_FILE"
        else
            # Ключ не найден, добавляем его в конец файла
            echo "COMPOSE_PROJECT_NAME=$CURRENT_DIR" >>"$ENV_FILE"
        fi
    fi
fi

# Создаем папку .vscode-server, для сохранения расширений и настроек VS Code
if [ ! -d ".vscode-server" ]; then
    mkdir .vscode-server
fi

if [ ! -d ".vscode-server-insiders" ]; then
    mkdir .vscode-server-insiders
fi

if [ ! -d ".windsurf-server" ]; then
    mkdir .windsurf-server
fi

if [ ! -d "$HOME/.ssh" ]; then
    echo "Creating folder ~/.ssh"
    mkdir -p "$HOME/.ssh"
fi

if [ -z "$SSH_AUTH_SOCK" ]; then
    touch /tmp/ssh-fake-agent
fi

docker pull bikosolutions/developers_repo:latest
