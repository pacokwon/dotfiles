{ lib, config, pkgs, ... }:
let
  sources = import ./lon.nix;
  lanzaboote = import sources.lanzaboote {
    inherit pkgs;
  };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      lanzaboote.nixosModules.lanzaboote
    ];

  # Bootloader.
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

  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "ko_KR.UTF-8/UTF-8"
  ];

  # Optionally
  i18n.extraLocaleSettings = {
    # LC_ALL = "en_US.UTF-8"; # This overrides all other LC_* settings.
    LANGUAGE = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ADDRESS = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MESSAGES = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
    LC_COLLATE = "en_US.UTF-8";
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

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    windowManager.i3.enable = true;
    xkb.options = "ctrl:nocaps";
    displayManager.lightdm = {
      enable = true;
    };
    displayManager.lightdm.greeters.gtk.enable = false;
  };

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
      background=${./wallpapers/nix-l-nord-aurora.png}
      draw-user-backgrounds=false
      enable-hidpi=auto
    '';
  };
  # fix some bug in lightdm
  programs.dconf.enable = true;

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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pacokwon = {
    isNormalUser = true;
    description = "pacokwon";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
    #  thunderbird
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
    ghostty
    bat
    ripgrep
    fd
    fzf
    ffmpeg
    obsidian
    xfce.thunar
    rofi
    stow
    direnv
    eza
    zoxide
    python314 gcc15 go rustc cargo opam deno nodejs_22 yarn-berry_3
    polybar
    killall
    unzip
    pciutils
    lshw
    xclip
    signal-desktop
    feh
    bibata-cursors
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

  system.stateVersion = "25.11"; # Did you read the comment?
}

# vim: set shiftwidth=2 tabstop=2 expandtab:
