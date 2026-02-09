{ config, pkgs, silentSDDM, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      silentSDDM.nixosModules.default
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.graphics = {
    enable = true;
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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

  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };

  programs.silentSDDM = {
    enable = true;
    theme = "default";
    # settings = { ... }; see example in module
  };

  services.xserver.displayManager.lightdm.greeters.gtk.enable = false;
  services.xserver.displayManager.lightdm.greeters.slick = {
    enable = true;
    theme = {
      name = "gruvbox-dark";
      package = pkgs.gruvbox-dark-gtk;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };
    extraConfig = ''
      background=${./wallpapers/nix-d-nord-purple.jpg}
      draw-user-backgrounds=false
      enable-hidpi=auto
    '';
  };

  # Whether to enable handling of hotplug and sleep events by autorandr.
  services.autorandr.enable = true;

  programs.dconf.enable = true;

  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        main = {
          muhenkan = "layer(nav)";
          henkan = "space";
          katakanahiragana = "space";
          ro = "rightshift";
          yen = "backspace";
          capslock = "leftcontrol";
        };
        nav = {
          h = "left";
          j = "down";
          k = "up";
          l = "right";
        };
      };
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

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
    packages = with pkgs; [
    ];
  };

  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      catppuccin
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
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
    waybar
    swaylock
    brightnessctl
    playerctl
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

  environment.variables = {
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "36";
  };

  environment.sessionVariables = {
    GDK_SCALE = "1"; 
    GDK_DPI_SCALE = "0.8"; # This mimics xft.dpi behavior for text
  };

  system.stateVersion = "25.11"; # Did you read the comment?
}
