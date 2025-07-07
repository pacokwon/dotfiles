source $(brew --prefix antidote)/share/antidote/antidote.zsh

antidote load

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

export MANPAGER="nvim +Man!"

alias vim="nvim"
alias cat="bat"
alias ls='eza --icons --color always'
alias ll='eza --icons --color always -l'
alias less='less -RFX' # display color on less
