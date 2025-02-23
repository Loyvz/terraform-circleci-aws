#!/bin/bash
# Actualizar paquetes e instalar Docker
sudo apt-get update -y
sudo apt-get install -y docker.io

# Habilitar e iniciar Docker
sudo systemctl enable docker
sudo systemctl start docker

# Ejecutar un contenedor Nginx en el puerto 80
sudo docker run -d -p 80:80 nginx
