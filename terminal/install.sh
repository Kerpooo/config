#!/usr/bin/env bash
# Instala zsh, Spaceship y plugins, y enlaza (symlink) la configuración de este directorio en ~
# Soporta Ubuntu/WSL (apt) y macOS (Homebrew).
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Sistema operativo ---
case "$(uname -s)" in
  Darwin) sugerido=2 ;;
  *)      sugerido=1 ;;
esac
echo "¿Qué sistema operativo estás usando?"
echo "  1) Ubuntu / WSL"
echo "  2) macOS"
read -r -p "Elige 1 o 2 [$sugerido]: " opcion
opcion="${opcion:-$sugerido}"

# --- Paquetes: zsh, git, fzf, eza, zoxide ---
case "$opcion" in
  1)
    OS=ubuntu
    if ! command -v zsh >/dev/null || ! command -v git >/dev/null || ! command -v fzf >/dev/null \
       || ! command -v eza >/dev/null || ! command -v zoxide >/dev/null; then
      sudo apt update && sudo apt install -y zsh git fzf curl eza zoxide
    fi
    ;;
  2)
    OS=mac
    if ! command -v brew >/dev/null; then
      echo "Homebrew no está instalado. Instálalo desde https://brew.sh y vuelve a ejecutar este script."
      exit 1
    fi
    brew install zsh git fzf eza zoxide
    ;;
  *)
    echo "Opción no válida"; exit 1 ;;
esac

# Definir zsh como shell por defecto (en macOS ya lo es; en Ubuntu pide contraseña)
if [ "$OS" = ubuntu ] && [ "$(basename "${SHELL:-}")" != "zsh" ]; then
  chsh -s "$(command -v zsh)" || echo "No se pudo cambiar el shell; hazlo con: chsh -s \$(which zsh)"
fi

mkdir -p "$HOME/.zsh/completions"
clone() { [ -d "$HOME/.zsh/$3" ] || git clone --depth 1 "https://github.com/$1/$2" "$HOME/.zsh/$3"; }

# --- Spaceship (https://spaceship-prompt.sh/) ---
clone spaceship-prompt spaceship-prompt spaceship

# --- Plugins ---
clone zsh-users zsh-autosuggestions zsh-autosuggestions
clone zsh-users zsh-syntax-highlighting zsh-syntax-highlighting
clone zsh-users zsh-completions zsh-completions
clone Aloxaf fzf-tab fzf-tab

# Completados generados (requieren uv y pnpm instalados)
command -v uv   >/dev/null && uv generate-shell-completion zsh > "$HOME/.zsh/completions/_uv" || true
command -v pnpm >/dev/null && pnpm completion zsh > "$HOME/.zsh/completions/_pnpm" || true

# --- Enlaces ---
link() { [ -e "$2" ] && [ ! -L "$2" ] && mv "$2" "$2.bak"; ln -sfn "$DIR/$1" "$2"; }
link zshrc "$HOME/.zshrc"
link spaceshiprc.zsh "$HOME/.spaceshiprc.zsh"
link zshenv "$HOME/.zshenv"

echo "Listo. Abre una terminal nueva (o ejecuta: exec zsh)."
