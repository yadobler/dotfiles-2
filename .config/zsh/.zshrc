# load zgenom
source "../zgenom/zgenom.zsh"
zgenom autoupdate
if ! zgenom saved; then
    echo "Creating zgenom save..."
    zgenom load zdharma-continuum/fast-syntax-highlighting
    zgenom load zsh-users/zsh-history-substring-search
    zgenom load unixorn/fzf-zsh-plugin
    zgenom load chrissicool/zsh-256color
    zgenom load zsh-users/zsh-completions src
    zgenom load zsh-users/zsh-autosuggestions
    zgenom load romkatv/powerlevel10k powerlevel10k
    zgenom save
    zgenom compile "$ZDOTDIR/.zshrc"
fi


bindkey -e
bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward


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
