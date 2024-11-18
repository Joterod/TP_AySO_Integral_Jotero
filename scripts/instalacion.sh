#!/bin/bash

# Actualizar y configurar la máquina
if [ -f /etc/debian_version ]; then
    # Ubuntu
    sudo apt-get update -y
    sudo apt-get install -y lvm2 ansible docker.io tree git
elif [ -f /etc/fedora-release ]; then
    # Fedora
    sudo dnf update -y
    sudo dnf install -y lvm2 ansible docker tree git
fi
