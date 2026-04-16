# 🚀 Manjaro Extreme Optimization & Setup

Este script automatiza a configuração inicial e a otimização de performance do **Manjaro KDE**, com foco especial em hardware com **4GB de RAM** e armazenamento limitado. Ele transforma uma instalação limpa em um ambiente de desenvolvimento e uso casual ágil e fluido.

## 🛠️ O que o script faz?

O script está dividido em 6 etapas estratégicas:

1.  **Otimização de Espelhos (Mirrors):** Localiza os 5 servidores mais rápidos no Brasil e no mundo para que seus downloads e atualizações voem.
2.  **Atualização Total:** Garante que o sistema e a base de dados do Pacman estejam na versão mais recente.
3.  **Setup de Softwares:** Instala ferramentas essenciais de trabalho e lazer:
    * **VS Code** (via AUR/Pamac).
    * **OnlyOffice** (via Flatpak, garantindo compatibilidade total com arquivos MS Office).
    * **VLC Player** (o canivete suíço dos vídeos).
4.  **ZRAM (O segredo da fluidez):** Configura a compressão de memória RAM em tempo real usando o algoritmo **ZSTD**. Isso permite que seus 4GB de RAM rendam como se fossem quase o dobro, evitando travamentos ao abrir muitas abas.
5.  **Ajustes de Performance (KDE Fokus):**
    * **Desativa o Baloo:** Desliga o indexador de arquivos do KDE que costuma "fritar" o processador em segundo plano.
    * **Swappiness 10:** Faz o Linux usar a RAM ao máximo antes de tentar usar o disco.
    * **Preload:** Um serviço que "prevê" o que você vai abrir e pré-carrega na memória.
6.  **Manutenção de Disco:** Limpa o cache de pacotes antigos para preservar espaço nos seus 120GB de armazenamento.

## 🚀 Como usar

Para rodar o setup no seu Manjaro, siga estes passos no terminal:

1. **Crie o arquivo do script:**
   ```bash
   nano setup.sh
   ```
**Ou baixe o arquivo e use o passo 2 e 3**

2. **Cole o código do script dentro dele:**
  
  ```bash
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

   ```
  
3. **Salve e saia (No nano: `Ctrl+O`, `Enter`, `Ctrl+X`).**

4. **Dê permissão de execução:**
   ```bash
   chmod +x setup.sh
   ```

5. **Execute o script:**
   ```bash
   ./setup.sh
   ```

6. **Reinicie o sistema:**
   Após o término, reinicie o computador para que as configurações de memória (ZRAM e Swappiness) entrem em vigor corretamente.

---

## 📋 Requisitos
* Sistema Operacional: **Manjaro Linux** (Preferencialmente KDE Plasma).
* Conexão com a internet.
* Senha de administrador (`sudo`).

---
**Desenvolvido por:** [hazzy.ribs](https://www.instagram.com/hazzy.ribs?igsh=MW1qNG1vOGJuNndwbw==) 🛠️
