#!/usr/bin/env zsh

USERNAME=${1:-"vscode"}

set -e

if [ -z $(apk info | grep -e '^docker$')]; then

    apk add --update docker openrc docker-cli docker-compose && rc-update add docker boot

    # DOCKER_GID=998
    # groupadd -g ${DOCKER_GID} docker
    # usermod -aG docker ${USERNAME}
fi

echo "✔️  docker-alpine Done!"