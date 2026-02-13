{
  description = "A SecureBoot-enabled NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, lanzaboote, silentSDDM, ...}:
    let
      system = "x86_64-linux";
    in {
    nixosConfigurations = {
      thinkpad = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = { inherit silentSDDM; };

        modules = [
          # This is not a complete NixOS configuration and you need to reference
          # your normal configuration here.

          lanzaboote.nixosModules.lanzaboote
          ./configuration.nix
          ./thinkpad/configuration.nix
        ];
      };
      desktop = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = { inherit silentSDDM; };

        modules = [
          # This is not a complete NixOS configuration and you need to reference
          # your normal configuration here.

          lanzaboote.nixosModules.lanzaboote
          ./configuration.nix
          ./desktop/configuration.nix
        ];
      };
    };
  };
}
