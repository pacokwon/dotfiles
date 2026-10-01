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
    asciidoctor
    bat
    bear
    colima
    d2
    delta
    difftastic
    direnv
    docker
    dprint
    eza
    fd
    ffmpeg
    fzf
    gdb
    gh
    glow
    gnupatch
    go-grip
    hyperfine
    just
    lazygit
    llama-cpp
    mitmproxy
    ollama
    opencode
    pokemon-colorscripts
    poppler-utils
    qemu
    rclone
    ripgrep
    rlwrap
    stow
    tmux
    tokei
    tree
    uv
    yt-dlp
    zola
    zoxide
    zsh
  ];
}
