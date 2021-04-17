#!/bin/ash

set -e

# Загрузите маркеры, чтобы увидеть, какие шаги уже выполнены
source "`dirname $0`"/marker_file.sh

# Сразу переключитесь на bash
if [ "${SWITCHED_TO_BASH}" != "true" ]; then
    apk add bash
    export SWITCHED_TO_BASH=true
    exec /bin/bash "$0" "$@"
    exit $?
    Add_MARKER_FILE "SWITCHED_TO_BASH=true"
fi

#-------------------------------------------
#                bashrc фрагмент           #
#-------------------------------------------
if [ -d "/tmp/build/shell/.bashrc" ]; then
    #-------------------------------------------
    #                bashrc фрагмент           #
    #-------------------------------------------
    cp /tmp/build/shell/.bashrc  ~/
    cp /tmp/build/shell/profile.sh  ~/profile.sh
    if [ -d "/tmp/build/shell/profile.d" ]; then
        cp -R  /tmp/build/shell/profile.d ~/
        echo "✔️  profile!"
    fi
fi

echo "✔️  bash Done!"
