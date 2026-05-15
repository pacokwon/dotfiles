{ pkgs, ... }:
{
  # Add the package to system-wide packages
  environment.systemPackages = [
    pkgs.pure-prompt
  ];

  # Enable Zsh and configure the interactive shell init
  programs.zsh = {
    enable = true;
    promptInit = ''
      # Add Pure to the fpath
      fpath+=( "${pkgs.pure-prompt}/share/zsh/site-functions" )

      # Initialize the prompt system
      autoload -U promptinit; promptinit

      zstyle :prompt:pure:git:stash show yes
      zstyle :prompt:pure:git:action show yes
      zstyle :prompt:pure:git:arrow show yes
      zstyle ':prompt:pure:git:branch' color '#4EF279'
      zstyle ':prompt:pure:prompt:success' color cyan

      # Set the prompt to pure
      prompt pure
    '';
  };
}
