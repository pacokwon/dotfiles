setopt auto_cd
setopt COMPLETE_IN_WORD

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

fpath+=$HOME/.zsh/pure

# ====== pure prompt ======
autoload -U promptinit; promptinit

zstyle :prompt:pure:git:stash show yes
zstyle :prompt:pure:git:action show yes
zstyle :prompt:pure:git:arrow show yes
zstyle ':prompt:pure:git:branch' color '#4EF279'
zstyle ':prompt:pure:prompt:success' color cyan

prompt pure

# ====== Antibody ======
# antibody init
source <(antibody init)
antibody bundle zsh-users/zsh-autosuggestions
antibody bundle zsh-users/zsh-syntax-highlighting
antibody bundle Aloxaf/fzf-tab

# ====== pyenv ======
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"

# ====== nvm ======
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ====== exports ======
export EDITOR="/usr/local/bin/nvim"

# see "brew info llvm"
PATH="/usr/local/Cellar/llvm@11/11.1.0/bin:$PATH"
PATH="/Users/pacokwon/.dotnet/tools:$PATH"
export PATH="/Users/pacokwon/.local/bin:$PATH"

# ====== ghcup ======
[ -f "/Users/pacokwon/.ghcup/env" ] && source "/Users/pacokwon/.ghcup/env" # ghcup-env

# ====== opam ======
test -r /Users/pacokwon/.opam/opam-init/init.zsh && . /Users/pacokwon/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

# ====== fzf zsh ======
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_COMMAND="rg --files --hidden -g !node_modules"
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

export PYENV_ROOT="$HOME/.pyenv"
export COLORTERM="truecolor"
export BAT_THEME="DarkNeon"
export MANPAGER='nvim +Man!'
export WIDGETS="$HOME/Library/Application Support/Übersicht/widgets"


# ====== aliases ======
alias vim="nvim"
alias cat="bat"
alias ydl="youtube-dl"
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias ls='exa --icons --color always'
alias ll='exa --icons --color always -l'
alias less='less -RFX' # display color on less
alias ssh='kitty +kitten ssh' # send terminfo on ssh. only use this alias on kitty
alias gd='git diff'
alias vimrc='vim ~/.config/nvim/init.vim'
alias zshrc='vim ~/.zshrc'
alias cdn='cd ~/.config/nvim'
alias lg='lazygit'

alias dr='dotnet run'
alias ds='dotnet fsi'

# set title for kitty tabs
function set-title-precmd() {
  title=$(basename $PWD | cut -c 1-8)
  printf "\e]2;%s\a" "$title"
}

function set-title-preexec() {
  printf "\e]2;%s\a" "$1"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd set-title-precmd
add-zsh-hook preexec set-title-preexec
