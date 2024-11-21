#!/bin/bash

###############################
#
# Parametros:
#  - Lista de Usuarios a crear (en un archivo o como argumento)
#  - Usuario del cual se obtendra la clave
#
# Tareas:
#  - Crear los usuarios segun la lista recibida en los grupos descriptos
#  - Los usuarios deberan de tener la misma clave que el usuario pasado por parametro
#
###############################

# Comprobamos que se hayan pasado los parámetros necesarios
if [ "$#" -ne 2 ]; then
    echo "Uso: $0 <archivo_con_usuarios> <usuario_origen>"
    exit 1
fi

# Asignamos los parámetros a variables
USUARIOS_FILE=$1
USUARIO_ORIGEN=$2

# Verificar si el archivo de usuarios existe
if [ ! -f "$USUARIOS_FILE" ]; then
    echo "El archivo $USUARIOS_FILE no existe."
    exit 1
fi

# Verificar si el usuario origen existe
if ! id "$USUARIO_ORIGEN" &>/dev/null; then
    echo "El usuario $USUARIO_ORIGEN no existe."
    exit 1
fi

# Obtener la clave del usuario origen
CLAVE_ORIGEN=$(sudo grep "^$USUARIO_ORIGEN:" /etc/shadow | cut -d: -f2)

# Verificar si la clave fue obtenida correctamente
if [ -z "$CLAVE_ORIGEN" ]; then
    echo "No se pudo obtener la clave del usuario $USUARIO_ORIGEN."
    exit 1
fi

# Crear usuarios a partir del archivo de usuarios
while IFS=" " read -r USUARIO GRUPO HOME; do
    # Verificar si el usuario ya existe
    if id "$USUARIO" &>/dev/null; then
        echo "El usuario $USUARIO ya existe. Omitiendo creación."
    else
        # Crear el grupo si no existe
        if ! getent group "$GRUPO" &>/dev/null; then
            sudo groupadd "$GRUPO"
            echo "Grupo $GRUPO creado."
        fi

        # Crear el usuario con el grupo y el directorio home especificado
        sudo useradd -m -d "$HOME" -g "$GRUPO" "$USUARIO"
        echo "Usuario $USUARIO creado en el grupo $GRUPO con home $HOME."

        # Establecer la misma contraseña que el usuario origen
        sudo usermod --password "$CLAVE_ORIGEN" "$USUARIO"
        echo "Clave del usuario $USUARIO configurada."
    fi
done < "$USUARIOS_FILE"

echo "Proceso completado."
