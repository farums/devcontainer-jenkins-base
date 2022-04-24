#! /bin/bash
echo ">> install packages"

set -e

apk add --no-cache \
    git-lfs \
    unzip \
    curl \
    ttf-dejavu