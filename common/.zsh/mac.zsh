source $(brew --prefix antidote)/share/antidote/antidote.zsh

antidote load

autoload -Uz vcs_info
setopt prompt_subst

precmd_functions+=(vcs_info)

# 1. Define the Stash Hook
+vi-git-stash() {
    local stashes
    if [[ -s ${hook_com[base]}/.git/refs/stash ]]; then
        stashes=$(git rev-list --walk-reflogs --count refs/stash 2>/dev/null)
        hook_com[misc]+=" %F{cyan}≡${stashes}%f"
    fi
}
zstyle ':vcs_info:git*+set-message:*' hooks git-stash

# 2. Styles
zstyle ':vcs_info:git:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' formats ' %F{yellow}%b%c%u%m%f'
zstyle ':vcs_info:git:*' actionformats ' %F{yellow}%b|%a%c%u%m%f'

# 3. Prompt
PS1='
%F{blue}%~%f${vcs_info_msg_0_}
%(?.%F{green}.%F{red})❯%f '

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
pathadd "$HOME/.deno/bin"
pathadd "$HOME/.config/emacs/bin"

export MANPAGER="nvim +Man!"
export EDITOR="nvim"
export DELTA_FEATURES="+side-by-side line-numbers"

# both variables need to be set to change history size
export HISTSIZE=5000
export SAVEHIST=$HISTSIZE

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
