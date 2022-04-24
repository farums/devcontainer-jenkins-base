#!/bin/ash
#-------------------------------------------------------------------------------------------------------------
#    Syntax: ./zsh-alpine.sh [username] [user HOME] [user GID] #
#-------------------------------------------------------------------------------------------------------------

USERNAME=${1:-"vscode"}
USER_GID=${2:-"1000"}
USER_HOME=${3:-"/home/vscode"}

set -e

# Загрузите маркеры, чтобы увидеть, какие шаги уже выполнены
source /tmp/build/scripts/marker_file.sh

#-------------------------------------------
#                   ZSH                    #
#-------------------------------------------
if ! type zsh >/dev/null 2>&1; then
    echo "✔️  ZSH Install"
    apk add --no-cache zsh
    usermod --shell /bin/zsh root
    usermod --shell /bin/zsh ${USERNAME}
fi
if [ "${ZSH_INSTALLED}" != "true" ]; then
    if [ -d "/tmp/build/shell" ]; then
        # USERNAME
        cp /tmp/build/shell/.p10k.zsh ${USER_HOME}/
        cp /tmp/build/shell/.zshrc ${USER_HOME}/
        #-------------------------------------------
        #                bashrc фрагмент           #
        #-------------------------------------------
        if [ -f "/tmp/build/shell/profile.sh" ]; then
            cp /tmp/build/shell/profile.sh  ${USER_HOME}/
            if [ -d "/tmp/build/shell/profile.d" ]; then
                cp -R  /tmp/build/shell/profile.d ${USER_HOME}/
                echo "✔️  profile!"
            fi
        fi
        newHomepath="${USER_HOME//\//\\/}"
        sed -i "s/HOMEPATH/${newHomepath}/" ${USER_HOME}/.zshrc
        # root
        ln -s ${USER_HOME}/.p10k.zsh /root/.p10k.zsh
        cp ${USER_HOME}/.zshrc /root/.zshrc
        #-------------------------------------------
        #                bashrc фрагмент           #
        #-------------------------------------------
        if [ -f "/tmp/build/shell/profile.sh" ]; then
            cp /tmp/build/shell/profile.sh  /root/profile.sh
            if [ -d "/tmp/build/shell/profile.d" ]; then
                cp -R  /tmp/build/shell/profile.d /root
                echo "✔️  profile!"
            fi
        fi
        sed -i "s/HOMEPATH/root/" /root/.zshrc
        POWERLEVEL10K_VERSION=v1.14.6
        git clone --single-branch --depth 1 https://github.com/robbyrussell/oh-my-zsh.git ${USER_HOME}/.oh-my-zsh 2>&1
        git clone --branch ${POWERLEVEL10K_VERSION} --depth 1 https://github.com/romkatv/powerlevel10k.git ${USER_HOME}/.oh-my-zsh/custom/themes/powerlevel10k 2>&1
        rm -rf ${USER_HOME}/.oh-my-zsh/custom/themes/powerlevel10k/.git
        chown -R ${USERNAME}:${USER_GID} ${USER_HOME}/.oh-my-zsh
        chmod -R 700 ${USER_HOME}/.oh-my-zsh
        cp -r ${USER_HOME}/.oh-my-zsh /root/.oh-my-zsh
        chown -R root:root /root/.oh-my-zsh

        Add_MARKER_FILE "ZSH_INSTALLED=true"
    fi
fi
echo "✔️  zsh-alpine Done!"
