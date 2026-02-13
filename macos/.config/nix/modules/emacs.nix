{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ 
    emacs
    fontconfig
    coreutils-prefixed
    shellcheck
  ];
}
