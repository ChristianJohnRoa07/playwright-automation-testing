# Dev Container

This is a simple starter for a javascript Dev Container

## Getting started
1. Manually configure your own `.env` file from `.env.sample`
2. Run `./release.dev.sh` to check and generate the required files
3. Add the required fields on  `.env`
4. Open in VS Code using Dev Containers
    - `Ctrl + Shift + P` type "Reopen in Dev Container"
    - Alternatively, run `docker compose -f compose.dev.yaml up`
      to start the development environment. Then, attach your editor
      to the `${PROJECT_NAME}-develop` container.

## How it works
* `docker/dev/app.Dockerfile` defines the dev container
    * It is important to create a user in the container that matches the host user's UID:GID
    * This is to prevent permission issues from files created in the container
* `compose.dev.yaml` defines other services needed in the dev environment
    * The current directory is mounted to the container to persist files in the host machine
        * https://docs.docker.com/engine/storage/bind-mounts/
    * Exposes the default Node.js port `3000` so that the node.js server is accessible by the host
* `release.dev.sh` checks the `.env` file and initializes some needed files
    * `.bash_history` persists the history between rebuilds
