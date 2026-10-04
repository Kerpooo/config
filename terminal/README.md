# terminal

Configuración de zsh con [Spaceship](https://spaceship-prompt.sh/), fzf, zoxide y eza. Funciona en Ubuntu/WSL y macOS.

## Instalación

```bash
./install.sh
```

El script pregunta el sistema operativo, instala los paquetes (`apt` en Ubuntu/WSL, `brew` en macOS), clona Spaceship y los plugins en `~/.zsh`, y enlaza los archivos de esta carpeta en `~` con symlinks:

| Archivo del repo | Enlace en `~` |
|---|---|
| `zshrc` | `~/.zshrc` |
| `zshenv` | `~/.zshenv` |
| `spaceshiprc.zsh` | `~/.spaceshiprc.zsh` |

Edita siempre los archivos de esta carpeta. Algunas herramientas, como `sed -i`, reemplazan un symlink por una copia normal si se usan sobre `~/.zshrc`.

## Atajos de teclado

### Completado y búsqueda

| Tecla | Qué hace |
|---|---|
| `Tab` | Completa comandos, rutas, ramas de git y opciones. Muestra la descripción de cada opción y se navega con las flechas. |
| `Ctrl+R` | Busca en el historial de forma difusa (fzf). |
| `Ctrl+T` | Busca archivos y pega la ruta en la línea (fzf). |

`Ctrl+T` ignora carpetas ocultas, dependencias (`node_modules`, `venv`, `vendor`, `target`, `dist`, `build`, entre otras) y los lockfiles. La lista está en `_fzf_dirs` y `_fzf_locks` dentro de `zshrc`.

### Sugerencias e ayuda

| Tecla | Qué hace |
|---|---|
| `→` | Acepta la sugerencia en gris del historial, con el cursor al final de la línea. |
| `Alt+F` | Acepta solo la siguiente palabra de la sugerencia. |
| `Alt+H` | Abre la página de `man` del comando escrito y, al salir, vuelves a tu línea. |

### Edición de línea (zsh, modo Emacs por defecto)

| Tecla | Qué hace |
|---|---|
| `Ctrl+A` / `Ctrl+E` | Inicio / final de la línea. |
| `Alt+B` / `Alt+F` | Una palabra atrás / adelante. |
| `Ctrl+W` | Borra la palabra anterior. |
| `Ctrl+U` / `Ctrl+K` | Borra hasta el inicio / hasta el final de la línea. |
| `Ctrl+L` | Limpia la pantalla. |
| `↑` / `↓` | Recorren el historial. |

## Comandos y alias

| Comando | Qué hace |
|---|---|
| `z carpeta` | zoxide: salta a una carpeta ya visitada (aprende de tus `cd`). |
| `ls`, `ll`, `lt` | eza: listado, listado largo con estado de git y árbol de 2 niveles. |
| `gcm` | Commits en formato conventional commits (ver abajo). |

Alias de git: `gs` (status), `ga` (add), `gaa` (add -A), `gco` (checkout), `gb` (branch), `gp` (push), `gpl` (pull), `gd` (diff), `gl` (log compacto con grafo).

### gcm

```bash
gcm                        # modo interactivo: tipo con fzf, scope y mensaje
gcm feat "mensaje"         # feat: mensaje
gcm 'fix(api)' "mensaje"   # fix(api): mensaje
gcm -e docs "mensaje"      # docs: 📝 mensaje
```

El emoji es opcional: solo se agrega con `-e` (o aceptándolo en el modo interactivo) y va después de los dos puntos para que el mensaje siga cumpliendo la especificación.

| Tipo | Emoji | Tipo | Emoji |
|---|---|---|---|
| `feat` | ✨ | `test` | ✅ |
| `fix` | 🐛 | `build` | 📦 |
| `docs` | 📝 | `ci` | 👷 |
| `style` | 💄 | `chore` | 🔧 |
| `refactor` | ♻️ | `revert` | ⏪ |
| `perf` | ⚡ | | |

## Windows Terminal

| Tecla | Qué hace |
|---|---|
| `Ctrl+Shift+P` | Paleta de comandos. |
| `Ctrl+,` | Ajustes. |
| `Ctrl+Shift+T` | Pestaña nueva. |
| `Alt+Shift+-` / `Alt+Shift++` | Divide el panel en horizontal / vertical. |

Si `Ctrl+Shift` no responde, puede estar chocando con el atajo de cambio de idioma de Windows (*Configuración → Hora e idioma → Escritura → Configuración avanzada del teclado → Teclas de acceso rápido del idioma de entrada*).
