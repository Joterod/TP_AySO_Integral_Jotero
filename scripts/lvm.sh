#!/bin/bash

# Creamos los volúmenes físicos
sudo pvcreate /dev/sdb /dev/sdc /dev/sdd

# Creamos grupos de volúmenes
sudo vgcreate vg_datos /dev/sdb /dev/sdc
sudo vgcreate vg_temp /dev/sdd

# Creamos volúmenes lógicos
sudo lvcreate -L 10M -n lv_docker vg_datos
sudo lvcreate -L 2.5G -n lv_workareas vg_datos
sudo lvcreate -L 2.5G -n lv_swap vg_temp

# Formateamos los volúmenes lógicos
sudo mkfs.ext4 /dev/vg_datos/lv_docker
sudo mkfs.ext4 /dev/vg_datos/lv_workareas
sudo mkswap /dev/vg_temp/lv_swap

# Creamos puntos de montaje
sudo mkdir -p /var/lib/docker
sudo mkdir -p /work

# Montamos los volúmenes lógicos
sudo mount /dev/vg_datos/lv_docker /var/lib/docker
sudo mount /dev/vg_datos/lv_workareas /work
sudo swapon /dev/vg_temp/lv_swap

# Añadimos al fstab para montaje automático al reiniciar
echo "/dev/vg_datos/lv_docker /var/lib/docker ext4 defaults 0 0" | sudo tee -a /etc/fstab
echo "/dev/vg_datos/lv_workareas /work ext4 defaults 0 0" | sudo tee -a /etc/fstab
echo "/dev/vg_temp/lv_swap swap swap defaults 0 0" | sudo tee -a /etc/fstab

# Reiniciamos el servicio Docker para reconocer los volúmenes
sudo systemctl restart docker
sudo systemctl status docker

echo "Configuración LVM completada."
