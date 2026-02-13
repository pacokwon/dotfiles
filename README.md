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
$ stow -t ~ mac   # if you're on a mac machine
$ stow -t ~ nixos # if you're on a nixos machine
```
