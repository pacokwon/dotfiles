{
  description = "Flake for pacokwon's macos";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-util.url = "github:hraban/mac-app-util";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    claude-code.url = "github:sadjow/claude-code-nix";

    # Optional: Declarative tap management
    # NOTE: homebrew/core and homebrew/cask are no longer tapped declaratively.
    # Homebrew 5.x installs from the API and tries to untap them, which fails
    # while casks are installed. Let Homebrew manage them via the API instead.
    homebrew-laishulu = {
      url = "github:laishulu/homebrew-homebrew";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      mac-app-util,
      nix-homebrew,
      homebrew-laishulu,
      ...
    }:
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#Haechans-MacBook-Pro
      darwinConfigurations."Haechans-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./configuration.nix
          ./modules/cli.nix
          ./modules/apps.nix
          ./modules/lang.nix
          ./modules/emacs.nix
          ./modules/tex.nix
          ./modules/zsh.nix
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
                "laishulu/homebrew-homebrew" = homebrew-laishulu;
              };

              # Optional: Enable fully-declarative tap management
              #
              # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
              mutableTaps = false;
              autoMigrate = true;
            };

            # Set Git commit hash for darwin-version.
            system.configurationRevision = self.rev or self.dirtyRev or null;
          }
        ];
      };

      darwinPackages = self.darwinConfigurations."macbookpro".pkgs;
    };
}

# vim: ts=2 sts=2 sw=2 et
