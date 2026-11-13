{ pkgs, inputs }:
with pkgs;
[
  # editors / core
  git
  vim
  wget
  (neovim.override {
    withPython3 = true;
    extraPython3Packages = p: with p; [ pynvim ];
  })

  # shell / navigation
  bat
  direnv
  eza
  fd
  fzf
  glow
  ripgrep
  stow
  tmux
  tree
  zoxide

  # dev tooling
  ffmpeg
  just
  poppler-utils
  tree-sitter

  # languages / LSPs shared everywhere
  deno
  lua-language-server
  markdownlint-cli2
  nixd
  nixfmt
  opam
  pyright
  python314
  ruff

  # ai
  inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code

  # prompt
  pure-prompt
]
