#!/bin/ash
#-------------------------------------------------------------------------------------------------------------
#    Syntax: ./common-alpine.sh [username] [user UID] [user GID] [user GROUP] [user HOME]  #
#-------------------------------------------------------------------------------------------------------------

USERNAME=${1:-"vscode"}
USER_UID=${2:-"1000"}
USER_GID=${3:-"1000"}
USER_GROUP=${4:-"vscode"}
USER_HOME=${5:-"home/vscode"}

set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Скрипт должен запускаться от имени root. Используйте sudo, su или добавьте «USER root» в свой Dockerfile перед запуском этого скрипта.'
    exit 1
fi
# Загрузите маркеры, чтобы увидеть, какие шаги уже выполнены
source "`dirname $0`"/marker_file.sh

# Убедитесь, что оболочки входа в систему получают правильный путь, если пользователь обновил PATH с помощью ENV.
rm -f /etc/profile.d/00-restore-env.sh
echo "export PATH=${PATH//$(sh -lc 'echo $PATH')/\$PATH}" > /etc/profile.d/00-restore-env.sh
chmod +x /etc/profile.d/00-restore-env.sh

# Install git, common dependencies

if [ "${PACKAGES_COMMON_INSTALLED}" != "true" ]; then
    apk update
    apk add --no-cache \
        git \
        openssh \
        shadow \
        nano \
        make \
        sudo
    Add_MARKER_FILE "PACKAGES_COMMON_INSTALLED=true"
fi

# 🕵️ Создайте или обновите пользователя без полномочий root для соответствия UID/GID.
if id -u ${USERNAME} > /dev/null 2>&1; then
    # ✔️ Пользователь существует, при необходимости обновите
    if [ "$USER_UID" != "$(id -u $USERNAME)" ]; then
        usermod --uid $USER_UID $USERNAME
    fi
else
   echo "👷   Create user"
   mkdir -p $USER_HOME
   chown $USER_UID:$USER_GID $USER_HOME
   addgroup -g ${USER_GID}  ${USER_GROUP}
   adduser -h "$USER_HOME" -u ${USER_UID} -G ${USER_GROUP} -s /bin/bash -D ${USERNAME}
fi

# Добавить поддержку sudo для пользователя без полномочий root
if [ "${USERNAME}" != "root" ] && [ "${EXISTING_NON_ROOT_USER}" != "${USERNAME}" ]; then
    echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME
    chmod 0440 /etc/sudoers.d/$USERNAME
    Add_MARKER_FILE "EXISTING_NON_ROOT_USER=${USERNAME}"
fi

# code shim, it fallbacks to code-insiders if code is not available
if [ -f /tmp/build/bin/executable_code ]; then
    cp -f /tmp/build/bin/executable_code  /usr/local/bin/code
    chmod +x /usr/local/bin/code
fi
echo "✔️  common-alpine Done!"
