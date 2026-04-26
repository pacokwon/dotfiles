# What OS are we running?
if [[ $(uname) == "Darwin" ]]; then
    source "$HOME"/.zsh/mac.zsh
elif command -v nixos-version > /dev/null; then
    source "$HOME"/.zsh/nixos.zsh
fi


# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '/home/pacokwon/.opam/opam-init/init.zsh' ]] || source '/home/pacokwon/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration
