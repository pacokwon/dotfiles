neofetch

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
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# ====== nvm ======
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ====== exports ======
export EDITOR="/usr/local/bin/nvim"

# see "brew info llvm"
PATH="/usr/local/opt/llvm/bin:$PATH"
export PATH="/Users/pacokwon/.local/bin:$PATH"

export FZF_DEFAULT_COMMAND="rg --files --hidden -g !node_modules"
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

export PYENV_ROOT="$HOME/.pyenv"
export COLORTERM="truecolor"
export BAT_THEME="DarkNeon"
export MANPAGER='nvim +Man!'

# ====== aliases ======
alias vim="nvim"
alias cat="bat"
alias ydl="youtube-dl"
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias ls='exa --icons --color always'
alias ll='exa --icons --color always -l'
alias ssh='kitty +kitten ssh' # send terminfo on ssh. only use this alias on kitty
alias gd='git diff'
alias vimrc='vim ~/.config/nvim/init.vim'
alias zshrc='vim ~/.zshrc'
alias cdn='cd ~/.config/nvim'

# ====== fzf zsh ======
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

function gi() {
    curl -sLw n https://www.gitignore.io/api/$@ ;
}

# fd - cd to selected directory
function fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# Modified version where you can press
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
function fo() (
  IFS=$'\n' out=("$(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)")
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
  fi
)

# cdf - cd into the directory of the selected file
function cdf() {
   local file
   local dir
   file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}

# set title for kitty tabs
function set-title-precmd() {
  printf "\e]2;%s\a" "${PWD/#$HOME/~}"
}

function set-title-preexec() {
  printf "\e]2;%s\a" "$1"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd set-title-precmd
add-zsh-hook preexec set-title-preexec

# opam configuration
test -r /Users/pacokwon/.opam/opam-init/init.zsh && . /Users/pacokwon/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
