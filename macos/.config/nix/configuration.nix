{
  pkgs,
  config,
  inputs,
  ...
}:
{
  nix = {
    # necessary for determinate nix
    enable = false;
    registry.nixpkgs.flake = inputs.nixpkgs;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    settings = {
      experimental-features = "nix-command flakes";
    };
  };

  nixpkgs.overlays = [ inputs.claude-code.overlays.default ];
  environment.systemPackages = [
    pkgs.claude-code # or pkgs.claude-code-bun if you prefer the bun-based build
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
      "anki"
      "discord"
      "blackhole-2ch"
    ];
    masApps = {
      KakaoTalk = 869223134;
      Hangul = 416746898;
      Xcode = 497799835;
      Keynote = 361285480;
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

  # Enable alternative shell support in nix-darwin.
  programs.direnv.enable = true;

  services.skhd.enable = false;

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
}
