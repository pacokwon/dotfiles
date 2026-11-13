# put the native homebrew on PATH
eval "$(/opt/homebrew/bin/brew shellenv)"

autoload -U compinit && compinit

# plugins are installed by nix (common/zsh.nix)
source /etc/zsh/plugins.zsh
setopt COMPLETE_IN_WORD
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# granular word boundary when using Ctrl-W

autoload -Uz select-word-style
select-word-style bash
autoload -U backward-kill-word-match
zle -N backward-kill-word backward-kill-word-match

###########################

eval "$(direnv hook zsh)"

pathadd() {
  [[ -d "$1" ]] || return

  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$PATH:$1" ;;
  esac
}

pathadd "$HOME/.local/bin"
pathadd "$HOME/.deno/bin"
pathadd "$HOME/.config/emacs/bin"

# filepath completion for just
_just_completion() {
if (( CURRENT > 2 )); then
  _files
else
  _just
fi
}
compdef _just_completion just

# take a long pdf, align it in 2x1 layout, trim it, and open print dialog
pjprint() {
  local dir out
  dir=$(mktemp -d) || return
  out="$dir/print.pdf"
  pdfjam --nup 2x1 --landscape --trim "15mm 20mm 15mm 20mm" --clip true --delta "0mm 0mm" "$1" --outfile "$out" || return
  osascript -e 'on run argv' \
            -e 'tell application "Preview"' \
            -e 'activate' \
            -e 'print ((POSIX file (item 1 of argv)) as alias) with print dialog' \
            -e 'end tell' \
            -e 'end run' "$out"
}

export MANPAGER="nvim +Man!"
export EDITOR="nvim"
export DELTA_FEATURES="+side-by-side line-numbers"

# both variables need to be set to change history size
export HISTSIZE=10000
export SAVEHIST=$HISTSIZE
setopt share_history

# ignore duplicate entries like ls -l
setopt hist_ignore_all_dups

# prevent entries starting with a space from being recorded
setopt hist_ignore_space

# prevents macos tar from adding Apple metadata files
export COPYFILE_DISABLE=1

alias vim="nvim"
alias cat="bat"
alias ls='eza --icons --color auto'
alias ll='eza --icons --color auto -l'
alias less='less -RFX' # display color on less
alias timeout=gtimeout
alias claude-personal='CLAUDE_CONFIG_DIR=~/.claude-personal claude'

# launch sioyek detached from the shell, like `open`
sioyek() { command sioyek "$@" &>/dev/null &! }

export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'

export NPM_CONFIG_PREFIX="$HOME/.npm-global"
export PATH="$HOME/.npm-global/bin:$PATH"

# I'm using a symbols only nerd font as a fallback,
# and an unpatched font as primary. the symbols look like
# it's right next to the entries because it's bigger than other fonts
# Adjust the spacing with this variable
export EZA_ICON_SPACING=2

# trying to make claude code scroll work with tmux's copy mode
export CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN=1

# increase context length (default 4096)
export OLLAMA_CONTEXT_LENGTH=32768

[[ -n $REX_BIN_DIR ]] && path=("$REX_BIN_DIR" $path)
[[ ! -r "$HOME/.opam/opam-init/init.zsh" ]] || source "$HOME/.opam/opam-init/init.zsh" > /dev/null 2> /dev/null

eval "$(zoxide init zsh)"

pokemon-colorscripts --random --no-title
