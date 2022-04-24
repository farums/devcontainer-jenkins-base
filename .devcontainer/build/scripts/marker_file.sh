#!/bin/ash

# Загрузите маркеры, чтобы увидеть, какие шаги уже выполнены
MARKER_FILE="/usr/local/etc/vscode-dev-containers/marker_file"
if [ -f "${MARKER_FILE}" ]; then
    echo "✔️  Маркер найден:"
    source "${MARKER_FILE}"
fi

Add_MARKER_FILE () {
    if [ -f "${MARKER_FILE}" ]; then
        echo -e "$1"\n\  >>  "${MARKER_FILE}"
    else
        mkdir -p "$(dirname "${MARKER_FILE}")"
        echo -e "$1"\n\ >> "${MARKER_FILE}"
    fi
}