#!/usr/bin/env bash
# Funciones compartidas por los scripts de instalación del repo (se cargan con `source`, no se ejecutan).

# Pregunta el sistema operativo y deja el resultado en $opcion (1 = Ubuntu/WSL, 2 = macOS).
# Si ya viene definido en OPCION (por ejemplo desde install.sh), no vuelve a preguntar.
ask_os() {
  if [ -n "${OPCION:-}" ]; then opcion="$OPCION"; return; fi
  local sugerido
  case "$(uname -s)" in Darwin) sugerido=2 ;; *) sugerido=1 ;; esac
  echo "¿Qué sistema operativo estás usando?"
  echo "  1) Ubuntu / WSL"
  echo "  2) macOS"
  read -r -p "Elige 1 o 2 [$sugerido]: " opcion
  opcion="${opcion:-$sugerido}"
  case "$opcion" in 1|2) ;; *) echo "Opción no válida"; exit 1 ;; esac
  export OPCION="$opcion"
}

# Asegura que existan curl y git. Ubuntu: los instala con apt. macOS: curl viene de fábrica
# y git llega con las Command Line Tools.
need_curl_git() {
  command -v curl >/dev/null && command -v git >/dev/null && return 0
  if [ "$opcion" = 1 ]; then
    sudo apt update && sudo apt install -y curl git
  else
    echo "Falta curl o git. Ejecuta: xcode-select --install"; exit 1
  fi
}
