#!/usr/bin/env bash
# Ejecuta los instaladores de herramientas DevOps (contenedores, infraestructura y nube).
# Uso: ./install.sh          instala todo lo de esta carpeta
#      ./install.sh docker   solo uno (docker); también puedes ejecutar ./docker.sh directamente
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$DIR/../lib/common.sh"

what="${1:-all}"
case "$what" in all|docker) ;; *) echo "Uso: $0 [docker]"; exit 1 ;; esac

ask_os   # una sola vez; los scripts hijos reutilizan la respuesta

for tool in docker; do
  if [ "$what" = all ] || [ "$what" = "$tool" ]; then
    "$DIR/$tool.sh"
  fi
done
