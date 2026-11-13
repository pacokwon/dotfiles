{ pkgs, ... }:
{
  # zsh plugins, sourced from ~/.zsh/{mac,nixos}.zsh after compinit.
  # Order matters: fzf-tab before widget-wrapping plugins, syntax highlighting last.
  environment.etc."zsh/plugins.zsh".text = ''
    source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
    source ${pkgs.zsh-autosuggestions}/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  '';

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
