{
  description = "Unified flake for pacokwon's macOS (nix-darwin) and NixOS hosts";

  inputs = {
    # darwin tracks nixpkgs-unstable; NixOS tracks nixos-unstable, which only
    # advances after the NixOS VM tests pass.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-nixos.url = "github:NixOS/nixpkgs/nixos-unstable";

    # ---- darwin inputs ----
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    claude-code.url = "github:sadjow/claude-code-nix";
    lean-lsp-mcp = {
      url = "github:oOo0oOo/lean-lsp-mcp";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NOTE: homebrew/core and homebrew/cask are no longer tapped declaratively.
    # Homebrew 5.x installs from the API and tries to untap them, which fails
    # while casks are installed. Let Homebrew manage them via the API instead.
    homebrew-laishulu = {
      url = "github:laishulu/homebrew-homebrew";
      flake = false;
    };

    # ---- nixos inputs ----
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.2.0";
      inputs.nixpkgs.follows = "nixpkgs-nixos";
    };
    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs-nixos";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-nixos,
      nix-darwin,
      mac-app-util,
      nix-homebrew,
      homebrew-laishulu,
      lanzaboote,
      silentSDDM,
      ...
    }:
    let
      linuxSystem = "x86_64-linux";
    in
    {
      # ---- macOS (nix-darwin) ----
      darwinConfigurations."Haechans-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./darwin/configuration.nix
          ./darwin/modules/cli.nix
          ./darwin/modules/apps.nix
          ./darwin/modules/lang.nix
          ./darwin/modules/emacs.nix
          ./darwin/modules/tex.nix
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

              # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
              mutableTaps = false;
              autoMigrate = true;
            };

            # Set Git commit hash for darwin-version.
            system.configurationRevision = self.rev or self.dirtyRev or null;
          }
        ];
      };

      darwinPackages = self.darwinConfigurations."Haechans-MacBook-Pro".pkgs;

      # ---- NixOS ----
      nixosConfigurations = {
        thinkpad = nixpkgs-nixos.lib.nixosSystem {
          system = linuxSystem;
          specialArgs = { inherit silentSDDM; };
          modules = [
            lanzaboote.nixosModules.lanzaboote
            ./nixos/configuration.nix
            ./nixos/hosts/thinkpad/configuration.nix
          ];
        };
        desktop = nixpkgs-nixos.lib.nixosSystem {
          system = linuxSystem;
          specialArgs = { inherit silentSDDM; };
          modules = [
            lanzaboote.nixosModules.lanzaboote
            ./nixos/configuration.nix
            ./nixos/hosts/desktop/configuration.nix
          ];
        };
      };
    };
}

# vim: ts=2 sts=2 sw=2 et
