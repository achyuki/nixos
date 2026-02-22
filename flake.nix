{
  description = "AcetylYuki's NixOS Configurations!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nur = {
      url = "github:nix-community/nur";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      nur,
      flake-utils,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;
      util = import ./flake/util.nix lib;
      flake = util.loadModules ./flake;
      modules = {
        nixosModules = util.loadModules ./modules // {
          _global = with inputs; [
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
            nix-index-database.nixosModules.default
            disko.nixosModules.disko
          ];
        };
        homeModules = util.loadModules ./home // {
          _global = with inputs; [ ];
        };
      };
    in
    {
      inherit (modules) nixosModules homeModules;
      nixosConfigurations = flake.nixos { inherit inputs lib util modules; };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgArgs = {
          overlays = util.loadOverlays ./overlays
            ++ [ (final: prev: { localPkgs = self.packages.${system}; }) ];
          config.allowUnfree = true;
          inherit system;
        };
        pkgs = util.genHybridPkgs { inherit nixpkgs nixpkgs-stable nur pkgArgs; };
      in
      {
        devShells = flake.devshell { inherit inputs pkgs lib util; };
        packages = util.loadPackages pkgs ./packages;
      }
    );
}
