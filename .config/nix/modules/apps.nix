{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ 
    wezterm
    obsidian
    slack
    zoom-us
    raycast
    zathura
  ];
}
