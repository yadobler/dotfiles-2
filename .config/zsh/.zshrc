[ "$TTY" = "/dev/tty1" ] && exec Hyprland
# load zgenom
# source "$ZDOTDIR/zgenom/zgenom.zsh"
# zgenom autoupdate
# if ! zgenom saved; then
#     echo "Creating zgenom save..."
#     zgenom load chrissicool/zsh-256color
#     zgenom load zsh-users/zsh-completions
#     zgenom save
#     zgenom compile "$ZDOTDIR/.zshrc"
# fi
# 

# load omp
eval "$(oh-my-posh init zsh --config ~/.config/zsh/oh-my-posh-config.json)"

# Ztyle pattern
# :completion:<function>:<completer>:<command>:<argument>:<tag>

# Define completers
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
zstyle ':completion:*' complete true
zstyle ':completion:*' menu select
zstyle ':completion:*' complete-options true
zstyle ':completion:*' file-sort modification
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %D %d --%f'
zstyle ':completion:*:*:*:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:*:*:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' keep-prefix true
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

autoload -Uz compinit && compinit
_comp_options+=(globdots)

bindkey -e

[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"

alias "bw_unlock"="[[ \$(bw status | jq '.status') == 'unlocked' ]] || export BW_SESSION=\$(bw unlock \$(zenity --password) --raw)"
#alias "activate_conda"="source /opt/miniconda3/etc/profile.d/conda.sh && echo Conda Activated!"

#bindkey "^[[A" history-beginning-search-backward
#bindkey "^[[B" history-beginning-search-forward
bindkey '^I'   expand-or-complete-prefix
bindkey '^[[Z' reverse-menu-complete

# Allow exec to run zsh init commands
if [[ $1 == eval ]]
then
    "$@"
set --
fi
