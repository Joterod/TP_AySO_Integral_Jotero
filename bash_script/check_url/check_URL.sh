#!/bin/bash
###############################
# Parametros:
#  - Lista Dominios y URL
# Tareas:
#  - Crear directorios y archivos según estado HTTP.
###############################

LISTA=$1
LOG_FILE="/var/log/status_URL.log"
DIRECTORIO="/tmp/head-check/"

# Validar entrada
if [[ -z "$LISTA" ]]; then
    echo "Error: No se proporcionó una lista de dominios."
    echo "Uso: $0 <archivo_lista_dominios>"
    exit 1
fi

if [[ ! -f "$LISTA" ]]; then
    echo "Error: El archivo $LISTA no existe."
    exit 1
fi

# Crear log si no existe
if [[ ! -f $LOG_FILE ]]; then
    sudo touch $LOG_FILE
    echo "Se creó el archivo $LOG_FILE"
fi

# Crear directorios si no existen
if [[ ! -d $DIRECTORIO ]]; then
    mkdir -p /tmp/head-check/{Error/{cliente,servidor},ok}
    echo "Se creó el directorio $DIRECTORIO"
fi

IFS=$'\n'
for LINEA in $(cat "$LISTA" | grep -v ^#); do
    URL=$(echo "$LINEA" | awk '{print $2}')
    DOMINIO=$(echo "$LINEA" | awk '{print $1}')

    STATUS_CODE=$(curl -LI -o /dev/null -w '%{http_code}' -s "$URL" 2>/dev/null)
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    
    if [[ -z $STATUS_CODE || $STATUS_CODE == "000" ]]; then
        echo "$TIMESTAMP - Error al conectar con la URL: $URL" | sudo tee -a $LOG_FILE
        continue
    fi
    
    echo "$TIMESTAMP - Code:$STATUS_CODE - URL:$URL" | sudo tee -a $LOG_FILE

    if [[ $STATUS_CODE == 200 ]]; then
        touch "$DIRECTORIO/ok/$DOMINIO.com"
        echo "$TIMESTAMP - Code:$STATUS_CODE - URL:$URL" >> "$DIRECTORIO/ok/$DOMINIO.com"
    elif [[ $STATUS_CODE -ge 400 && $STATUS_CODE -le 499 ]]; then
        touch "$DIRECTORIO/Error/cliente/$DOMINIO.com"
        echo "$TIMESTAMP - Code:$STATUS_CODE - URL:$URL" >> "$DIRECTORIO/Error/cliente/$DOMINIO.com"
    elif [[ $STATUS_CODE -ge 500 && $STATUS_CODE -le 599 ]]; then
        touch "$DIRECTORIO/Error/servidor/$DOMINIO.com"
        echo "$TIMESTAMP - Code:$STATUS_CODE - URL:$URL" >> "$DIRECTORIO/Error/servidor/$DOMINIO.com"
    fi
done
IFS=$'\n'
