#!/bin/bash

# Verifica se um parâmetro foi fornecido
if [ -z "$1" ]; then
  echo "Uso: $0 <Fuso-Horário>"
  echo "Exemplo: $0 America/Sao_Paulo"
  exit 1
fi

# Define a timezone a partir do parâmetro
TIMEZONE="$1"

# Configurar o fuso horário
echo "Configurando o fuso horário para $TIMEZONE..."
sudo timedatectl set-timezone "$TIMEZONE"

# Configurar RTC local
echo "Configurando RTC local..."
sudo timedatectl set-local-rtc 1 --adjust-system-clock

# Encerrar o script
echo "Script concluído com sucesso."
exit 0
