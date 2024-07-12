# use .config file, not home, for zshrc
export ZDOTDIR="$HOME/.config/zsh"
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh" 
export ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump"
export HISTFILE="$ZSH_CACHE_DIR/.histfile"
export DIRSTACKFILE="$ZSH_CACHE_DIR/.zdirs"
export HISTSIZE=1000
export SAVEHIST=1000
export COMPLETION_WAITING_DOTS=true

export PATH="$HOME/.local/bin:/usr/local/bin:$HOME/.cargo/bin/:/usr/bin:/bin:$GEM_HOME/bin:$PATH"
export EDITOR=nvim
export LESS="-R"
export MANPAGER="less -R"
export RANGER_LOAD_DEFAULT_RC="FALSE"

# support colors in less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
