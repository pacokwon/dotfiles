{
  description = "Flake for pacokwon's macos";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-util.url = "github:hraban/mac-app-util";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, mac-app-util, nix-homebrew, homebrew-core, homebrew-cask, ... }:
  let
    configuration = { pkgs, config, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs; [
        wezterm
        vim
        neovim
        zsh
        stow
        bat
        ripgrep
        fd
        fzf
        eza
        lazygit
        bear
        tmux
        obsidian
        yt-dlp
        ffmpeg
        qemu
        gdb
        zoom-us
        skhd
        tree
        deno go rustc cargo opam nodejs_22 yarn-berry_3
        dprint
        direnv
        tokei
        gnupatch
        hexyl
        python314
        delta
        raycast
        vscode
        zola
      ];

      homebrew = {
        enable = true;
        brews = [
          "antidote"
          "tpm"
        ];
        casks = [
          "ghostty"
          "messenger"
          "whatsapp"
          "firefox"
          "obs"
          "dolphin"
          "amethyst"
          "thunderbird"
          "mgba"
          "chatgpt"
          "zulip"
        ];
      };

      fonts.packages = [
        pkgs.nerd-fonts.hack
        pkgs.nerd-fonts.victor-mono
        pkgs.nerd-fonts.symbols-only
        pkgs.noto-fonts-cjk-sans
      ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      programs.zsh.enable = true;
      programs.direnv.enable = true;

      services.skhd.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.primaryUser = "pacokwon";

      system.defaults = {
        dock.autohide = true;
        screencapture.location = "~/Pictures/Screenshots";
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
      nixpkgs.config = { allowUnfree = true; };
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Haechans-MacBook-Pro
    darwinConfigurations."macbookpro" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        mac-app-util.darwinModules.default
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            enableRosetta = true;

            # User owning the Homebrew prefix
            user = "pacokwon";

            # Optional: Declarative tap management
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
            };

            # Optional: Enable fully-declarative tap management
            #
            # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
            mutableTaps = false;
          };
        }
      ];
    };

    darwinPackages = self.darwinConfigurations."macbookpro".pkgs;
  };
}

# vim: ts=2 sts=2 sw=2 et
