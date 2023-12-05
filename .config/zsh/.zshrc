# If running from tty1 start sway
# [ "$(tty)" = "/dev/tty1" ] && exec /bin/Hyprland


# The following lines were added by compinstall

zstyle ':completion:*' auto-description 'specift: %d'
zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' ignore-parents parent pwd .. directory
zstyle ':completion:*' insert-unambiguous false
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '+m:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+m:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+m:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+m:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' max-errors 2 not-numeric
zstyle ':completion:*' menu select=1
zstyle ':completion:*' original true
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' squeeze-slashes true
zstyle :compinstall filename '/home/yukna/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
setopt SHARE_HISTORY
HISTFILE=~/.cache/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt nomatch notify HIST_EXPIRE_DUPS_FIRST
unsetopt autocd beep extendedglob
bindkey -e
bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward
# End of lines configured by zsh-newuser-install

ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh" 
ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump"
COMPLETION_WAITING_DOTS=true
alias print_battery_percentage="upower -i /org/freedesktop/UPower/devices/battery_BAT1 | awk 'match(\$1,/percentage/){print \$2}'"
PS1="%B┌─%-50(l.[%b%F{cyan}%n%f%F{white}@%f%F{red}%m%f%B]─[%b%F{blue}%D%f%B]─[%B%F{magenta}$(print_battery_percentage)%%f%b]─.)[%b%F{yellow}%#%f%B]─[%b%F{green}%~%f%B]
└─[%F{%(0?.green.red)}%?%f]%b "
RPS1="%F{%(0?..red:(}%f"
export PATH="$HOME/.local/bin:/usr/local/bin:$HOME/.cargo/bin/:$PATH"
export EDITOR=nvim
export LESS="-R"
export MANPAGER="less -R"

alias vim="nvim"
alias svim="sudo -E nvim"
alias batt="upower -i /org/freedesktop/UPower/devices/battery_BAT1 | grep -e state -e percentage -e time\ to\ empty"
# alias ls="ls --color=auto"
#alias grep="grep --color=auto"
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

alias "cd.."="cd .."
alias ":q"="exit"
alias "gau"="git add -u"
alias "gsm"="git submodule"
alias "gs"="git status"
alias "gcm"="git commit -m"
alias "gpush"="git push"
alias "gpull"="git pull"

