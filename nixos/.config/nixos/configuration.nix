{ config, lib, pkgs, silentSDDM, ... }: {
  imports =
    [ # Include the results of the hardware scan.
      silentSDDM.nixosModules.default
    ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Lanzaboote currently replaces the systemd-boot module.
  # This setting is usually set to true in configuration.nix
  # generated at installation time. So we force it to false
  # for now.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.systemd-boot.configurationLimit = 5;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
    autoGenerateKeys.enable = true;
    autoEnrollKeys.enable = true;
    autoEnrollKeys.autoReboot = true;
  };

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Seoul";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-hangul
      fcitx5-gtk
      qt6Packages.fcitx5-configtool
    ];
  };

  systemd.tmpfiles.rules = [
    "L /var/lib/AccountsService/icons/pacokwon - - - - ${./avatar.jpeg}"
  ];

  programs.silentSDDM = {
    enable = true;
    theme = "default";
  };

  programs.dconf.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pacokwon = {
    isNormalUser = true;
    description = "pacokwon";
    extraGroups = [ "networkmanager" "wheel" "video" "render" "input" ];
    shell = pkgs.zsh;
  };

  programs.niri.enable = true;
  programs.niri.package = pkgs.niri;
  services.displayManager.sddm.enable = true;
  services.displayManager.sessionPackages = [ pkgs.niri ];
  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      catppuccin
    ];
  };
  programs.waybar.enable = true;

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    neovim
    wezterm
    alacritty
    ghostty
    bat
    ripgrep
    fd
    fzf
    ffmpeg
    obsidian
    thunar
    stow
    direnv
    eza
    zoxide
    python314 gcc15 go rustc cargo opam deno nodejs_22 yarn-berry_3
    killall
    unzip
    pciutils
    lshw
    signal-desktop
    feh
    bibata-cursors
    protonvpn-gui
    lua-language-server stylua
    fuzzel
    wbg
    swaylock
    brightnessctl
    playerctl
    wlogout
    zathura
    rocq-core
    zulip
  ];

  fonts.packages = with pkgs; [
    dejavu_fonts
    nerd-fonts.hack
    nerd-fonts.victor-mono
    nerd-fonts.symbols-only
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
    noto-fonts-cjk-sans
    nanum-gothic-coding
    iosevka
    material-design-icons
  ];

  fonts.fontconfig.defaultFonts = {
    monospace = [
      "VictorMono Nerd Font Mono"
      "NanumGothicCoding"
    ];
    sansSerif = [
      "DejaVu Sans"
      "NanumGothicCoding"
    ];
    serif = [
      "DejaVu Serif"
      "NanumGothicCoding"
    ];
  };

  # Bridge the gap for Qt apps (like OBS or VLC)
  qt = {
    enable = true;
    platformTheme = "gtk2";
    style = "adwaita-dark";
  };

  environment.variables = {
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "36";
    GTK_THEME = "Adwaita:dark";
  };

  environment.sessionVariables = {
    GDK_SCALE = "1"; 
    GDK_DPI_SCALE = "1"; # This mimics xft.dpi behavior for text
  };

  system.stateVersion = "25.11"; # Did you read the comment?
}
