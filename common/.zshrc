# What OS are we running?
if [[ $(uname) == "Darwin" ]]; then
    source "$HOME"/.zsh/mac.zsh
elif command -v nixos-version > /dev/null; then
    source "$HOME"/.zsh/nixos.zsh
fi
