#!/bin/bash

# Verificar se o parâmetro foi passado
if [ -z "$1" ]; then
    echo "Erro: Você deve informar a pasta do sincronizador como parâmetro."
    echo "Uso: $0 <pasta-do-sincronizador>"
    exit 1
fi

# Diretório do sincronizador passado como argumento
SYNC_DIR="$1"

# Verificar se o diretório existe
if [ ! -d "$SYNC_DIR" ]; then
    echo "Erro: O diretório '$SYNC_DIR' não existe."
    exit 1
fi

# Define a timezone
TIMEZONE="America/Campo_Grande"

# Configurar o fuso horário
echo "Configurando o fuso horário para $TIMEZONE..."
sudo timedatectl set-timezone "$TIMEZONE"

# Configurar RTC local
echo "Configurando RTC local..."
sudo timedatectl set-local-rtc 1 --adjust-system-clock

# Acessar a pasta /docker e reiniciar os containers
echo "Acessando a pasta '/docker'..."
cd "/docker" || { echo "Erro ao acessar a pasta '/docker'"; exit 1; }

echo "Reiniciando os containers Docker na pasta '/docker'..."
docker compose down && docker compose up -d || echo "Erro ao reiniciar os containers em '/docker', ignorando..."

# Voltar ao diretório anterior
echo "Voltando ao diretório anterior..."
cd - || { echo "Erro ao voltar ao diretório anterior"; exit 1; }

# Entrar na pasta do sincronizador do cliente e reiniciar os containers
echo "Acessando a pasta do sincronizador: $SYNC_DIR"
cd "$SYNC_DIR" || { echo "Erro ao acessar a pasta '$SYNC_DIR'"; exit 1; }

echo "Reiniciando os containers Docker na pasta '$SYNC_DIR'..."
docker compose down && docker compose up -d --remove-orphans || echo "Erro ao reiniciar os containers em '$SYNC_DIR', ignorando..."

# Encerrar o script
echo "Script concluído com sucesso."
exit 0
