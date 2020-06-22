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

autoload -Uz compinit; compinit
# # which completers to use
# # for use with expand-or-complete-prefix :
# zstyle ':completion:*' completer _complete _match _list _ignored _correct _approximate
# # for use with expand-or-complete :
# # zstyle ':completion:*' completer _complete _match _prefix:-complete _list _correct _approximate _prefix:-approximate _ignored
# # _list anywhere to the completers always only lists completions on first tab

# zstyle ':completion:*:prefix-complete:*' completer _complete
# zstyle ':completion:*:prefix-approximate:*' completer _approximate

# # configure the match completer, more flexible of GLOB_COMPLETE
# # with original set to only it doesn't act like a `*' was inserted at the cursor position
# zstyle ':completion:*:match:*' original only

# # first case insensitive completion, then case-sensitive partial-word completion, then case-insensitive partial-word completion
# # (with -_. as possible anchors)
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[-_.]=* r:|=*' 'm:{a-z}={A-Z} r:|[-_.]=* r:|=*'

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

# ====== aliases ======
alias vim="nvim"
alias git="hub"
alias cat="bat"
alias ydl="youtube-dl"
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# ====== exports ======
export EDITOR="/usr/local/bin/nvim"
export FZF_DEFAULT_COMMAND="rg --files --hidden -g !node_modules"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export PYENV_ROOT="$HOME/.pyenv"
export JAVA_HOME="/usr/local/Cellar/openjdk@11/11.0.7+10"
export SCALA_HOME="/usr/local/scala"
export SBT_HOME="/opt/sbt"
export PATH="/usr/local/opt/openjdk/bin:$PYENV_ROOT/bin:$JAVA_HOME/bin:$SCALA_HOME/bin:$SBT_HOME/bin:$PATH"
export COLORTERM="truecolor"
export BAT_THEME="DarkNeon"

# ====== fzf zsh ======
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

function gi() {
    curl -sLw n https://www.gitignore.io/api/$@ ;
}

function vimrc() {
    vim ~/.vimrc
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

