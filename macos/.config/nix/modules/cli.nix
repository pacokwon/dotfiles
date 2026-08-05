{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    (neovim.override {
      withPython3 = true;
      extraPython3Packages = p: with p; [ pynvim ];
    })
    zsh
    stow
    bat
    ripgrep
    fd
    fzf
    eza
    lazygit
    bear
    tmux
    yt-dlp
    ffmpeg
    qemu
    gdb
    tree
    direnv
    tokei
    gnupatch
    delta
    zoxide
    rlwrap
    docker
    colima
    zola
    just
    ollama
    llama-cpp
    opencode
    hyperfine
    pokemon-colorscripts
    glow
    poppler-utils
    uv
    asciidoctor
    gh
    difftastic
  ];
}
