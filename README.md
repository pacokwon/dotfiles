# Dotfiles

```
.
├── common # base configuration
│   ├── .config
│   ├── .tmux.conf
│   ├── .zsh
│   ├── .zsh_plugins.txt
│   └── .zshrc
├── mac   # macos specific configuration
│   └── .config
└── nixos # nixos specific configuration
    └── .config
```

From the project root, run:

```bash
$ stow -t ~ common
$ stow -t ~ macos # if you're on a mac
$ stow -t ~ nixos # if you're on a nixos machine
```

## Nix

The flake in `common/.config/nix` (stowed to `~/.config/nix`) builds both systems:

```bash
$ darwin-rebuild switch --flake ~/.config/nix#Haechans-MacBook-Pro   # macOS
$ sudo nixos-rebuild switch --flake ~/.config/nix#desktop            # or #thinkpad
```

macOS tracks `nixpkgs-unstable` (input `nixpkgs`); NixOS tracks `nixos-unstable`
(input `nixpkgs-nixos`). Update them independently with `nix flake update <input>`.
