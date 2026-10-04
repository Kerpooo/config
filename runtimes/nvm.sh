#!/usr/bin/env bash
# Instala nvm (última versión) y la última versión de Node: https://github.com/nvm-sh/nvm
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$DIR/../lib/common.sh"
ask_os
need_curl_git

NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

if [ -s "$NVM_DIR/nvm.sh" ]; then
  echo "nvm ya está instalado en $NVM_DIR"
else
  # Última versión publicada de nvm (la redirección de /releases/latest apunta a su tag)
  NVM_VERSION="$(curl -fsSLI -o /dev/null -w '%{url_effective}' https://github.com/nvm-sh/nvm/releases/latest | sed 's|.*/||')"
  case "$NVM_VERSION" in v[0-9]*) ;; *) echo "No se pudo averiguar la última versión de nvm"; exit 1 ;; esac
  echo "Instalando nvm $NVM_VERSION"
  # PROFILE=/dev/null evita que el instalador edite ~/.zshrc (nvm ya se carga ahí en modo perezoso)
  curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" | PROFILE=/dev/null NVM_DIR="$NVM_DIR" bash
fi

# nvm.sh no es compatible con `set -u`
set +u
# shellcheck disable=SC1091
. "$NVM_DIR/nvm.sh"
nvm install node            # siempre la última versión de Node (no solo la LTS)
nvm alias default node >/dev/null
set -u
echo "Node $(node -v) / npm $(npm -v)"

echo "nvm listo. Abre una terminal nueva (o ejecuta: exec zsh)."
