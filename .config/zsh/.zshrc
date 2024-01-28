# If running from tty1 start hyprland
[ "$(tty)" = "/dev/tty1" ] && /bin/Hyprland

setopt HIST_EXPIRE_DUPS_FIRST
setopt append_history
setopt auto_pushd
setopt autocd 
setopt completeinword
setopt extended_glob
setopt extended_history
setopt hash_list_all
setopt longlistjobs
setopt nobeep 
setopt nomatch 
setopt noshwordsplit
setopt notify 
setopt pushd_ignore_dups
setopt share_history
setopt unset
setopt nocorrect

autoload -Uz compinit && compinit
function _force_rehash () {
    (( CURRENT == 1 )) && rehash
    return 1
}

if ip -color=auto addr show dev lo >/dev/null 2>&1; then
    alias ip='command ip -color=auto'
fi
if [[ $ZSH_PROFILE_RC -gt 0 ]] ; then
    zmodload zsh/zprof
fi

GRML_COMP_CACHE_DIR=${GRML_COMP_CACHE_DIR:-$HOME/.cache/zsh}
if [[ ! -d ${GRML_COMP_CACHE_DIR} ]]; then
    command mkdir -p "${GRML_COMP_CACHE_DIR}"
fi
for compcom in cp deborphan df feh fetchipac gpasswd head hnb ipacsum mv \
               pal stow uname ; do
    [[ -z ${_comps[$compcom]} ]] && compdef _gnu_generic ${compcom}
done; unset compcom

ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh" 
ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump"
HISTFILE=$ZSH_CACHE_DIR/.histfile
DIRSTACKFILE=$ZSH_CACHE_DIR/.zdirs
HISTSIZE=1000
SAVEHIST=1000
COMPLETION_WAITING_DOTS=true

zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose true
zstyle ':completion:*' menu select=5
zstyle ':completion:*' auto-description 'specift: %d' zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete _files _ignored
zstyle ':completion:*' ignore-parents parent pwd .. directory
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '+m:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+m:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+m:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+m:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' use-cache yes
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:*:zcompile:*' ignored-patterns '(*~|*.zwc)'
zstyle ':completion:*:-command-:*:' verbose false
zstyle ':completion:*:approximate:' max-errors 'reply=( $((($#PREFIX+$#SUFFIX)/3 )) numeric )'
zstyle ':completion:*:complete:*' cache-path "${GRML_COMP_CACHE_DIR}"
zstyle ':completion:*:correct:*' insert-unambiguous true
zstyle ':completion:*:correct:*' original true
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:expand:*' tag-order all-expansions
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:man:*' menu yes select
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.*' insert-sections true
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:processes-names' command 'ps c -u ${USER} -o command | uniq'
zstyle ':completion:*:warnings' format $'%{\e[0;31m%}No matches for:%{\e[0m%} %d'
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'
zstyle ':completion:correct:' prompt 'correct to: %e'

function beginning-or-end-of-somewhere () {
    local hno=$HISTNO
    if [[ ( "${LBUFFER[-1]}" == $'\n' && "${WIDGET}" == beginning-of* ) || \
      ( "${RBUFFER[1]}" == $'\n' && "${WIDGET}" == end-of* ) ]]; then
        zle .${WIDGET:s/somewhere/buffer-or-history/} "$@"
    else
        zle .${WIDGET:s/somewhere/line-hist/} "$@"
        if (( HISTNO != hno )); then
            zle .${WIDGET:s/somewhere/buffer-or-history/} "$@"
        fi
    fi
}
zle -N beginning-of-somewhere beginning-or-end-of-somewhere
zle -N end-of-somewhere beginning-or-end-of-somewhere


bindkey -e
bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward

alias print_battery_percentage="upower -i /org/freedesktop/UPower/devices/battery_BAT1 | awk 'match(\$1,/percentage/){print \$2}'"
PS1="%B┌─%-50(l.[%b%F{cyan}%n%f%F{white}@%f%F{red}%m%f%B]─[%b%F{blue}%D%f%B]─[%B%F{magenta}$(print_battery_percentage)%%f%b]─.)[%b%F{yellow}%#%f%B]─[%b%F{green}%~%f%B]
└─[%F{%(0?.green.red)}%?%f]%b "
RPS1="%F{%(0?..red:(}%f"
export PATH="$HOME/.local/bin:/usr/local/bin:$HOME/.cargo/bin/:$PATH"
export EDITOR=nvim
export LESS="-R"
export MANPAGER="less -R"
export GLFW_IM_MODULE="ibus"
export XMODIFIERS="@im=fcitx"
export GTK_IM_MODULE="wayland"
export QT_IM_MODULE="fcitx"
export RANGER_LOAD_DEFAULT_RC="FALSE"
# support colors in less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
# automatically remove duplicates from these arrays
typeset -U path PATH cdpath CDPATH fpath FPATH manpath MANPATH
 
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
alias wal_update='wal --cols16 -o ~/.config/scripts/wal_posthook.sh -i'
alias steam_update_apps="sed 's/Exec=steam /Exec=gamemoderun steam /g' -i ~/.local/share/applicationsCC/*"

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
