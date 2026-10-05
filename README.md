# config

Mi configuración personal y scripts de setup para dejar un equipo listo para programar. Funciona en Ubuntu/WSL y macOS.

## Uso

```bash
git clone git@github.com:Kerpooo/config.git ~/config
cd ~/config
```

Cada carpeta es independiente: entra a la que necesites y ejecuta su `install.sh`. Los scripts preguntan el sistema operativo (Ubuntu/WSL o macOS) y se pueden volver a ejecutar sin problema: lo que ya está instalado se omite.

## Carpetas

| Carpeta | Qué contiene | Instalar |
|---|---|---|
| [`terminal/`](terminal/) | zsh con Spaceship, fzf, zoxide y eza, más el comando `gcm` para conventional commits. Incluye la lista de atajos de teclado. | `./terminal/install.sh` |
| [`runtimes/`](runtimes/) | Runtimes de lenguajes: uv (Python) y nvm con la última versión de Node (JavaScript). | `./runtimes/install.sh` |
| [`devops/`](devops/) | Herramientas de contenedores, infraestructura y nube. Por ahora, Docker. | `./devops/install.sh` |
| [`lib/`](lib/) | Funciones compartidas por los scripts de instalación. No se ejecuta directamente. | — |

### Instalar solo una herramienta

Dentro de `runtimes/` y `devops/` cada herramienta tiene su propio script:

```bash
./runtimes/uv.sh
./runtimes/nvm.sh
./devops/docker.sh
```

Los `install.sh` de esas carpetas también aceptan el nombre de la herramienta, por ejemplo `./runtimes/install.sh uv`.

## Agregar algo nuevo

- **Una herramienta de una categoría existente:** crea su script dentro de la carpeta (por ejemplo `devops/terraform.sh`), cárgale `../lib/common.sh` como hacen los demás y agrégala a la lista del `install.sh` de esa carpeta.
- **Una categoría nueva:** crea una carpeta con su propio `install.sh` y una fila en la tabla de arriba.

## Convenciones

- **Commits:** [conventional commits](https://www.conventionalcommits.org/), por ejemplo `feat(terminal): ...`. En la terminal se pueden escribir con `gcm`.
- **Dotfiles:** el archivo real vive dentro del repo y en `~` se crea un symlink hacia él, no al revés. Edita siempre los archivos del repo.
- **Rutas:** se usa `$HOME` en lugar de rutas con el nombre de usuario, para que la configuración sirva en cualquier equipo.
