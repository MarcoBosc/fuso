#!/bin/bash

# Verificar se o parâmetro foi passado
if [ -z "$1" ]; then
    echo "Erro: Você deve informar a pasta do cliente como parâmetro."
    echo "Uso: $0 <pasta-do-cliente>"
    exit 1
fi

# Diretório do cliente passado como argumento
CLIENT_DIR="$1"

# Verificar se o diretório existe
if [ ! -d "$CLIENT_DIR" ]; then
    echo "Erro: O diretório '$CLIENT_DIR' não existe."
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

# Entrar na pasta "docker" dentro do diretório do cliente e reiniciar os containers
if [ -d "/docker" ]; then
    echo "Acessando a pasta do gestão web..."
    cd "/docker" || { echo "Erro ao acessar a pasta '$CLIENT_DIR/docker'"; exit 1; }
    
    echo "Reiniciando os containers Docker na pasta '/docker'..."
    docker compose down && docker compose up -d || echo "Erro ao reiniciar os containers em '$CLIENT_DIR/docker', ignorando..."
else
    echo "Pasta '$CLIENT_DIR/docker' não encontrada, pulando etapa..."
fi

# Entrar na pasta do sincronizador do cliente e reiniciando os containers
echo "Acessando a pasta do cliente: $CLIENT_DIR"
cd "$CLIENT_DIR" || { echo "Erro ao acessar a pasta '$CLIENT_DIR'"; exit 1; }

echo "Reiniciando os containers Docker na pasta '$CLIENT_DIR'..."
docker compose down && docker compose up -d || echo "Erro ao reiniciar os containers em '$CLIENT_DIR', ignorando..."

# Encerrar o script
echo "Script concluído com sucesso."
exit 0
