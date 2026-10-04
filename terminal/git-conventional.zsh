# gcm: commits con formato conventional commits, con emoji opcional.
#
#   gcm                       modo interactivo (elige tipo con fzf, scope y mensaje)
#   gcm feat "mensaje"        feat: mensaje
#   gcm 'fix(api)' "mensaje"  fix(api): mensaje
#   gcm -e docs "mensaje"     docs: 📝 mensaje   (-e agrega el emoji del tipo)
#
# El emoji va después de los dos puntos para que el mensaje siga cumpliendo la
# especificación (el prefijo `tipo(scope):` debe ir primero).
typeset -gA _gcm_emoji=(
  feat ✨  fix 🐛  docs 📝  style 💄  refactor ♻️  perf ⚡
  test ✅  build 📦  ci 👷  chore 🔧  revert ⏪
)
typeset -gA _gcm_desc=(
  feat "nueva funcionalidad"  fix "corrección de un error"  docs "documentación"
  style "formato, sin cambios de lógica"  refactor "reestructura sin cambiar comportamiento"
  perf "mejora de rendimiento"  test "pruebas"  build "dependencias o sistema de build"
  ci "integración continua"  chore "mantenimiento"  revert "revierte un commit"
)

gcm() {
  local use_emoji=0 type scope msg
  [[ "$1" == -e ]] && { use_emoji=1; shift; }

  if (( $# == 0 )); then
    # Modo interactivo
    command -v fzf >/dev/null || { echo "gcm: se necesita fzf para el modo interactivo"; return 1; }
    local sel
    sel=$(for t in feat fix docs style refactor perf test build ci chore revert; do
            printf '%-9s %s  %s\n' "$t" "${_gcm_emoji[$t]}" "${_gcm_desc[$t]}"
          done | fzf --prompt='tipo> ' --height=40% --reverse) || return 1
    type="${sel%% *}"
    read -r "scope?Scope (opcional, Enter para omitir): "
    read -r "msg?Mensaje: "
    [[ -z "$msg" ]] && { echo "gcm: el mensaje no puede estar vacío"; return 1; }
    read -q "REPLY?¿Agregar emoji ${_gcm_emoji[$type]}? [y/N] " && use_emoji=1
    echo
    [[ -n "$scope" ]] && type="$type($scope)"
  else
    type="$1"; shift
    msg="$*"
    [[ -z "$msg" ]] && { echo "uso: gcm [-e] tipo[(scope)] mensaje"; return 1; }
  fi

  local base="${type%%\(*}"
  if [[ -z "${_gcm_emoji[$base]}" ]]; then
    echo "gcm: tipo desconocido '$base' (usa: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert)"; return 1
  fi

  (( use_emoji )) && msg="${_gcm_emoji[$base]} $msg"
  git commit -m "$type: $msg"
}
