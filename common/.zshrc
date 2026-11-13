# What OS are we running?
if [[ $(uname) == "Darwin" ]]; then
    source "$HOME"/.zsh/mac.zsh
elif command -v nixos-version > /dev/null; then
    source "$HOME"/.zsh/nixos.zsh
fi

# Option+Left/Right word movement (Ghostty sends real alt-arrows; its esc:b/esc:f defaults are unbound)
bindkey '^[[1;3D' backward-word
bindkey '^[[1;3C' forward-word
