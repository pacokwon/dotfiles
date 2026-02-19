if [[ ! -d $HOME/.antidote ]]; then
    git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
    chmod u+x $HOME/.antidote/antidote
fi

source $HOME/.antidote/antidote.zsh
antidote load

set -o emacs
# Bind Alt + Left Arrow to move back one word
bindkey '^[[1;3D' backward-word

# Bind Alt + Right Arrow to move forward one word
bindkey '^[[1;3C' forward-word

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
pathadd "$HOME/.config/emacs/bin"

export MANPAGER="nvim +Man!"
export EDITOR="nvim"
export SUDO_EDITOR="nvim"
export DELTA_FEATURES="+side-by-side line-numbers"

alias vim="nvim"
alias cat="bat"
alias ls='eza --icons --color auto'
alias ll='eza --icons --color auto -l'
alias less='less -RFX' # display color on less

# I'm using a symbols only nerd font as a fallback,
# and an unpatched font as primary. the symbols look like
# it's right next to the entries because it's bigger than other fonts
# Adjust the spacing with this variable
export EZA_ICON_SPACING=2

eval "$(zoxide init zsh)"
