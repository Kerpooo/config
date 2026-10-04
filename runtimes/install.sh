#!/usr/bin/env bash
# Instala uv (Python) y nvm + Node LTS (JavaScript).
# Uso: ./install.sh          instala ambos
#      ./install.sh uv       solo uv
#      ./install.sh nvm      solo nvm y Node LTS
# Soporta Ubuntu/WSL y macOS.
set -euo pipefail

NVM_VERSION="v0.40.8"
NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

# --- Qué instalar ---
what="${1:-all}"
case "$what" in all|uv|nvm) ;; *) echo "Uso: $0 [uv|nvm]"; exit 1 ;; esac

# --- Sistema operativo ---
case "$(uname -s)" in Darwin) sugerido=2 ;; *) sugerido=1 ;; esac
echo "¿Qué sistema operativo estás usando?"
echo "  1) Ubuntu / WSL"
echo "  2) macOS"
read -r -p "Elige 1 o 2 [$sugerido]: " opcion
opcion="${opcion:-$sugerido}"

# --- Dependencias: curl y git ---
case "$opcion" in
  1)
    if ! command -v curl >/dev/null || ! command -v git >/dev/null; then
      sudo apt update && sudo apt install -y curl git
    fi
    ;;
  2)
    # En macOS curl viene de fábrica; git llega con las Command Line Tools
    command -v git >/dev/null || { echo "Falta git. Ejecuta: xcode-select --install"; exit 1; }
    ;;
  *) echo "Opción no válida"; exit 1 ;;
esac

# --- uv (https://docs.astral.sh/uv/) ---
install_uv() {
  if command -v uv >/dev/null; then
    echo "uv ya está instalado: $(uv --version)"
  else
    # UV_NO_MODIFY_PATH evita que el instalador edite ~/.zshrc (ya lo gestiona terminal/zshrc)
    curl -LsSf https://astral.sh/uv/install.sh | UV_NO_MODIFY_PATH=1 sh
  fi
  # Autocompletado de zsh, si ya hay configuración de terminal
  if [ -d "$HOME/.zsh/completions" ]; then
    "$HOME/.local/bin/uv" generate-shell-completion zsh > "$HOME/.zsh/completions/_uv" 2>/dev/null || true
  fi
}

# --- nvm + Node LTS (https://github.com/nvm-sh/nvm) ---
install_nvm() {
  if [ -s "$NVM_DIR/nvm.sh" ]; then
    echo "nvm ya está instalado en $NVM_DIR"
  else
    # PROFILE=/dev/null evita que el instalador edite ~/.zshrc (nvm ya se carga ahí en modo perezoso)
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" | PROFILE=/dev/null NVM_DIR="$NVM_DIR" bash
  fi
  # nvm.sh no es compatible con `set -u`
  set +u
  # shellcheck disable=SC1091
  . "$NVM_DIR/nvm.sh"
  nvm install --lts
  set -u
  echo "Node $(node -v) / npm $(npm -v)"
}

[ "$what" = all ] || [ "$what" = uv ]  && install_uv
[ "$what" = all ] || [ "$what" = nvm ] && install_nvm

echo "Listo. Abre una terminal nueva (o ejecuta: exec zsh)."
