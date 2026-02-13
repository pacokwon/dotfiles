{ config, lib, pkgs, silentSDDM, ... }: {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      silentSDDM.nixosModules.default
    ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Lanzaboote currently replaces the systemd-boot module.
  # This setting is usually set to true in configuration.nix
  # generated at installation time. So we force it to false
  # for now.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
    autoGenerateKeys.enable = true;
    autoEnrollKeys.enable = true;
    autoEnrollKeys.autoReboot = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ libva-vdpau-driver ];
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = lib.mkDefault ["nvidia"];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  # Use the systemd-boot EFI boot loader.
  boot = {
    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    initrd.kernelModules = [ "nvidia" "i915" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    kernelParams = [
      "nvidia-drm.modeset=1"
      "modprobe.blacklist=nouveau"
      "nouveau.modeset=0" 
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
    blacklistedKernelModules = [ "nouveau" ];
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

  systemd.tmpfiles.rules = [
    "L /var/lib/AccountsService/icons/pacokwon - - - - ${./avatar.jpeg}"
  ];

  programs.silentSDDM = {
    enable = true;
    theme = "default";
  };

  programs.dconf.enable = true;

  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        main = {
          capslock = "leftcontrol";
        };
      };
    };
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
    swaylock
    brightnessctl
    playerctl
    swayosd
    wlogout
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
    GDK_DPI_SCALE = "1"; # This mimics xft.dpi behavior for text
  };

  system.stateVersion = "25.11"; # Did you read the comment?
}
