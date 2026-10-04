#!/usr/bin/env bash
# Instala Docker.
# Uso: ./docker.sh
#   Ubuntu: Docker Engine con el script oficial (https://get.docker.com)
#   WSL:    si ya hay un docker (p. ej. Docker Desktop con integración WSL) no se instala otro
#   macOS:  Docker Desktop con Homebrew
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$DIR/../lib/common.sh"
ask_os

if command -v docker >/dev/null; then
  echo "Docker ya está instalado: $(docker --version)"
  exit 0
fi

if [ "$opcion" = 2 ]; then
  command -v brew >/dev/null || { echo "Falta Homebrew (https://brew.sh) para instalar Docker Desktop"; exit 1; }
  brew install --cask docker
  echo "Abre Docker Desktop una vez para completar la instalación."
  exit 0
fi

if grep -qi microsoft /proc/version 2>/dev/null; then
  echo "Estás en WSL. Lo recomendado es Docker Desktop para Windows con la integración WSL activada."
  read -r -p "¿Instalar Docker Engine dentro de WSL de todos modos? [s/N]: " resp
  case "$resp" in s|S|y|Y) ;; *) echo "Docker omitido."; exit 0 ;; esac
fi

need_curl_git
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker "$USER"
echo "Docker listo. Cierra y vuelve a abrir la sesión para usarlo sin sudo."
