[ "$TTY" = "/dev/tty1" ] && exec Hyprland
# load zgenom
source "$ZDOTDIR/zgenom/zgenom.zsh"
zgenom autoupdate
if ! zgenom saved; then
    echo "Creating zgenom save..."
    zgenom load chrissicool/zsh-256color
    zgenom load zsh-users/zsh-completions
    zgenom load romkatv/powerlevel10k powerlevel10k
    zgenom save
    zgenom compile "$ZDOTDIR/.zshrc"
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


autoload -Uz compinit && compinit
_comp_options+=(globdots)

setopt menu_complete
setopt auto_list
setopt complete_in_word
setopt extended_glob
setopt nobeep
setopt longlistjobs
setopt share_history
bindkey -e
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
bindkey '^I'   expand-or-complete
bindkey '^[[Z' reverse-menu-complete

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

[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"
alias vim="nvim"
alias svim="sudo -E nvim"
alias batt="upower -i /org/freedesktop/UPower/devices/battery_BAT1 | grep -e state -e percentage -e time\ to\ empty"
alias ip="ip -color=auto"
alias ls="lsd --group-directories-first"
alias ll="ls -lhA"
alias la="ls -lA"
alias cat="bat"
alias du="dust"
alias ps="procs"
alias htop="btm"
alias grep="rg"
alias find="fd"
alias "jobs"="jobs -p"
alias wal_update='wal --cols16 -p "main_theme" -o ~/.config/scripts/wal_posthook.sh -i'
alias steam_update_apps="sed 's/Exec=steam /Exec=gamemoderun steam /g' -i ~/.local/share/applicationsCC/*"
alias valgrind="~/.config/scripts/colorgrind"

alias "cd.."="cd .."
alias ":q"="exit"
alias "gaf"="git add -f"
alias "gau"="git add -u"
alias "gsm"="git submodule"
alias "gs"="git status"
alias "gcm"="git commit -m"
alias "gpush"="git push"
alias "gpull"="git pull"

alias "bw_unlock"="[[ \$(bw status | jq '.status') == 'unlocked' ]] || export BW_SESSION=\$(bw unlock \$(zenity --password) --raw)"
alias "activate_conda"="source /opt/miniconda3/etc/profile.d/conda.sh && echo Conda Activated!"

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
if zmodload zsh/terminfo && (( terminfo[colors] >= 256 )); then
    [[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
else
    [[ ! -f ~/.config/zsh/.p10k-portable.zsh ]] || source ~/.config/zsh/.p10k-portable.zsh
fi
