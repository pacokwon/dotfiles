if [[ ! -d $HOME/.antidote ]]; then
    git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
    chmod u+x $HOME/.antidote/antidote
fi

source $HOME/.antidote/antidote.zsh
antidote load

set -o emacs

autoload -U promptinit && promptinit
zstyle :prompt:pure:git:stash show yes
zstyle :prompt:pure:git:action show yes
zstyle :prompt:pure:git:arrow show yes
zstyle ':prompt:pure:git:branch' color '#4EF279'
zstyle ':prompt:pure:prompt:success' color cyan
prompt pure

autoload -U compinit && compinit
setopt COMPLETE_IN_WORD
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

eval "$(direnv hook zsh)"

pathadd() {
  [[ -d "$1" ]] || return

  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$PATH:$1" ;;
  esac
}

pathadd "$HOME/.local/bin"

export MANPAGER="nvim +Man!"
export EDITOR="nvim"
export DELTA_FEATURES="+side-by-side line-numbers"

alias vim="nvim"
alias cat="bat"
alias ls='eza --icons --color always'
alias ll='eza --icons --color always -l'
alias less='less -RFX' # display color on less

eval "$(zoxide init zsh)"
