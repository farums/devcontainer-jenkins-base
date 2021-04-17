#-------------------------------------------------------------------------
# powerlevel10             =>  https://github.com/romkatv/powerlevel10k
# colors                   =>  https://jonasjacek.github.io/colors/
# настройка тем и плагинов =>  https://www.youtube.com/watch?v=ZNHkS4EnXhQ&ab_channel=Props
#-------------------------------------------------------------------------

ZSH=/HOMEPATH/.oh-my-zsh
ZSH_CUSTOM=$ZSH/custom

HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.cache/zsh/history
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
ZSH_THEME="powerlevel10k/powerlevel10k"
ENABLE_CORRECTION="false"
COMPLETION_WAITING_DOTS="true"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=236,bold,underline"


# install zsh-syntax-highlighting
if [ ! -d ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
fi
source ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null


# Autosuggestion plugin
if [ ! -d ${ZSH_CUSTOM}/plugins/zsh-autosuggestions ]; then
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
fi
source ${ZSH_CUSTOM}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd history completion)


plugins=(vscode git colorize npm npx yarn node docker docker-compose zsh-syntax-highlighting zsh-autosuggestions)

export LANG='en_US.UTF-8'
export LANGUAGE='en_US:en'
export LC_ALL='en_US.UTF-8'
export TERM=xterm-256color

source $ZSH/oh-my-zsh.sh
source ~/.p10k.zsh

echo
[ -f ~/.zshrc-specific.sh ] && source ~/.zshrc-specific
[ -f ~/profile.sh ] && source ~/profile.sh
