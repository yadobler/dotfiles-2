# load zgenom
source "$ZDOTDIR/zgenom/zgenom.zsh"
zgenom autoupdate
if ! zgenom saved; then
    echo "Creating zgenom save..."
    zgenom load z-shell/F-Sy-H
    zgenom load chrissicool/zsh-256color
    zgenom load zsh-users/zsh-autosuggestions
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

bindkey -e
bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward
bindkey              '^I'         menu-complete
bindkey "$terminfo[kcbt]" reverse-menu-complete
bindkey "^ "  autosuggest-accept

autoload -Uz compinit && compinit
_comp_options+=(globdots)
setopt completeinword
setopt extended_glob
setopt nobeep
setopt longlistjobs
setopt share_history
zstyle ':completion:*' ignore-parents parent pwd .. directory
zstyle ':completion:*' matcher-list '+m:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+m:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+m:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+m:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:*:zcompile:*' ignored-patterns '(*~|*.zwc)'
zstyle ':completion:*:expand:*' tag-order all-expansions
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:man:*' menu yes select
zstyle ':completion:*' special-dirs true

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
