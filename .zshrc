neofetch

# ====== Powerlevel10k ======
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

setopt auto_cd
setopt COMPLETE_IN_WORD

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# ====== Antibody ======
# antibody init
source <(antibody init)
antibody bundle romkatv/powerlevel10k
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

# ====== aliases ======
alias vim="nvim"
alias cat="bat"
alias ydl="youtube-dl"
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias ls='ls -G'
alias ssh='kitty +kitten ssh' # send terminfo on ssh. only use this alias on kitty

# ====== exports ======
export EDITOR="/usr/local/bin/nvim"
export FZF_DEFAULT_COMMAND="rg --files --hidden -g !node_modules"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export PYENV_ROOT="$HOME/.pyenv"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/adoptopenjdk-10.jdk/Contents/Home"
export GOROOT="/usr/local/go"
export GOPATH="$HOME/go"
export GO111MODULE="on"
export COLORTERM="truecolor"
export BAT_THEME="DarkNeon"
export MANPAGER='nvim +Man!'
export LDFLAGS="-L/usr/local/opt/llvm/lib"
export CPPFLAGS="-I/usr/local/opt/llvm/include -isysroot"

PATH="/usr/local/opt/openjdk/bin:$PATH"
PATH="$PYENV_ROOT/bin:$PATH"
PATH="$JAVA_HOME/bin:$PATH"
PATH="$JAVA_HOME/bin:$PATH"
PATH="/Applications/MATLAB.app/bin:$PATH"
PATH="/usr/local/opt/llvm/bin:$PATH"
export PATH="/Users/pacokwon/.local/bin:$PATH"

# ====== fzf zsh ======
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

function gi() {
    curl -sLw n https://www.gitignore.io/api/$@ ;
}

function vimrc() {
    vim ~/.config/nvim/init.vim
}

function zshrc() {
    vim ~/.zshrc
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
