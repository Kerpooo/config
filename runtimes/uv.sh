#!/usr/bin/env bash
# Instala uv (Python): https://docs.astral.sh/uv/
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$DIR/../lib/common.sh"
ask_os
need_curl_git

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

echo "uv listo. Abre una terminal nueva (o ejecuta: exec zsh)."
