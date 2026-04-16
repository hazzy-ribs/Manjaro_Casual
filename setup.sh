#!/bin/bash

echo "Buscando os repositórios mais rápidos (Brasil/Global)..."

sudo pacman-mirrors --fasttrack 5

echo "Iniciando atualização completa..."
sudo pacman -Syu --noconfirm

echo "Instalando softwares solicitados..."

sudo pacman -S --noconfirm vlc flatpak
pamac build --no-confirm visual-studio-code-bin

flatpak install flathub org.onlyoffice.desktopeditors -y

echo "Configurando ZRAM (Algoritmo ZSTD)..."
sudo pacman -S --noconfirm zram-generator

sudo bash -c 'cat << EOF > /etc/systemd/zram-generator.conf
[zram0]
zram-size = ram / 1
compression-algorithm = zstd
swap-priority = 100
fs-type = swap
EOF'

sudo systemctl daemon-reload
sudo systemctl start /dev/zram0

echo "Desativando indexador Baloo para poupar CPU..."
balooctl6 disable

echo "Ajustando Swappiness para 10..."
sudo bash -c 'echo "vm.swappiness=10" > /etc/sysctl.d/99-swappiness.conf'
sudo sysctl -p /etc/sysctl.d/99-swappiness.conf

sudo pacman -S --noconfirm preload
sudo systemctl enable --now preload

sudo pamac clean --keep 2

echo "------------------------------------------------"
echo "Setup Concluído! Sistema otimizado e atualizado."
echo "Reinicie para aplicar todas as mudanças de memória."
echo "------------------------------------------------"
