source $(brew --prefix antidote)/share/antidote/antidote.zsh

antidote load

autoload -U compinit && compinit
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

alias vim="nvim"
alias cat="bat"
alias ls='eza --icons --color auto'
alias ll='eza --icons --color auto -l'
alias less='less -RFX' # display color on less

export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'

# I'm using a symbols only nerd font as a fallback,
# and an unpatched font as primary. the symbols look like
# it's right next to the entries because it's bigger than other fonts
# Adjust the spacing with this variable
export EZA_ICON_SPACING=2

# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r "$HOME/.opam/opam-init/init.zsh" ]] || source "$HOME/.opam/opam-init/init.zsh" > /dev/null 2> /dev/null
# END opam configuration

eval "$(zoxide init zsh)"

pokemon-colorscripts --random --no-title
