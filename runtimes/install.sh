#!/usr/bin/env bash
# Ejecuta los instaladores de runtimes de lenguajes: uv (Python) y nvm + Node (JavaScript).
# Uso: ./install.sh          instala uv y nvm
#      ./install.sh uv       solo uno (uv | nvm); también puedes ejecutar ./uv.sh directamente
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$DIR/../lib/common.sh"

what="${1:-all}"
case "$what" in all|uv|nvm) ;; *) echo "Uso: $0 [uv|nvm]"; exit 1 ;; esac

ask_os   # una sola vez; los scripts hijos reutilizan la respuesta

for tool in uv nvm; do
  if [ "$what" = all ] || [ "$what" = "$tool" ]; then
    "$DIR/$tool.sh"
  fi
done
