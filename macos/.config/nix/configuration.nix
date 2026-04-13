{ pkgs, config, inputs, ... }: {
  nixpkgs.overlays = [ inputs.claude-code.overlays.default ];
  environment.systemPackages = [
    pkgs.claude-code  # or pkgs.claude-code-bun if you prefer the bun-based build
  ];

  homebrew = {
    enable = true;
    onActivation = {
      upgrade = true;
      cleanup = "uninstall";
    };
    brews = [
      "antidote"
      "laishulu/homebrew/macism"
      "tpm"
      "mas"
      "gmp"
      "pkgconf"
      "watch"
      "watchexec"
    ];
    casks = [
      "ghostty"
      "messenger"
      "whatsapp"
      "firefox"
      "ungoogled-chromium"
      "google-chrome"
      "obs"
      "dolphin"
      "amethyst"
      "thunderbird"
      "mgba-app"
      "chatgpt"
      "zulip"
      "scroll-reverser"
      "font-bree-serif"
      "input-source-pro"
      "protonvpn"
      "signal"
      "karabiner-elements"
      "balenaetcher"
      "steam"
      "telegram-desktop"
      "skim"
    ];
    masApps = {
      KakaoTalk = 869223134;
      Hangul = 416746898;
      # Xcode = 497799835;
      Goodnotes = 1444383602;
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.hack
    nerd-fonts.victor-mono
    nerd-fonts.symbols-only
    nerd-fonts.iosevka
    nerd-fonts.iosevka-term
    noto-fonts-cjk-sans
    nerd-fonts.roboto-mono
    roboto-mono
    iosevka
    atkinson-hyperlegible
    pretendard
    d2coding
  ];

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";
  nix.enable = false;

  # Enable alternative shell support in nix-darwin.
  programs.direnv.enable = true;

  system.primaryUser = "pacokwon";

  system.defaults = {
    dock.autohide = true;
    screencapture.location = "/Users/pacokwon/Pictures/Screenshots";
    controlcenter.BatteryShowPercentage = true;
  };

  system.defaults.NSGlobalDomain = {
    ApplePressAndHoldEnabled = false;
    NSWindowShouldDragOnGesture = true;
    _HIHideMenuBar = true;
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config = {
    allowUnfree = true;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  environment.variables = {
    ROCQPATH = "${pkgs.rocqPackages.stdlib}/lib/coq/9.0/user-contrib";
  };
}
