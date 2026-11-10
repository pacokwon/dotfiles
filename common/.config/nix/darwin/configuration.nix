{
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [
    ../common/zsh.nix
  ];

  nix = {
    # necessary for determinate nix
    enable = false;
    registry.nixpkgs.flake = inputs.nixpkgs;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    settings = {
      experimental-features = "nix-command flakes";
    };
  };

  nixpkgs.overlays = [
    inputs.claude-code.overlays.default
    # sioyek looks for its configs and shaders in Contents/Resources, but the
    # darwin build installs them into Contents/MacOS
    (final: prev: {
      sioyek = prev.sioyek.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          app=$out/Applications/sioyek.app/Contents
          for f in prefs.config keys.config tutorial.pdf shaders; do
            cp -r $app/MacOS/$f $app/Resources/
          done
        '';
      });
    })
  ];

  environment.systemPackages = (import ../common/packages.nix { inherit pkgs; }) ++ [
    pkgs.claude-code # or pkgs.claude-code-bun if you prefer the bun-based build
    inputs.lean-lsp-mcp.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.antigravity-cli # `agy`
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
      "omlahore/tap/removemacai"
      "tpm"
      "mas"
      "gmp"
      "pkgconf"
      "watch"
      "watchexec"
    ];
    casks = [
      "amethyst"
      "anki"
      "balenaetcher"
      "blackhole-2ch"
      "chatgpt"
      "claude"
      "discord"
      "dolphin"
      "firefox"
      "font-bree-serif"
      "ghostty"
      "google-chrome"
      "input-source-pro"
      "karabiner-elements"
      "messenger"
      "mgba-app"
      "obs"
      "protonvpn"
      "raycast"
      "scroll-reverser"
      "signal"
      "skim"
      "steam"
      "telegram-desktop"
      "thunderbird"
      "ungoogled-chromium"
      "zulip"
    ];
    masApps = {
      KakaoTalk = 869223134;
      Hangul = 416746898;
      Xcode = 497799835;
      Keynote = 361285480;
      Goodnotes = 1444383602;
    };
  };

  fonts.packages =
    (import ../common/fonts.nix { inherit pkgs; })
    ++ (with pkgs; [
      nerd-fonts.iosevka-term
      nerd-fonts.roboto-mono
      roboto-mono
      atkinson-hyperlegible
      pretendard
      d2coding
    ]);

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

# vim: ts=2 sts=2 sw=2 et
