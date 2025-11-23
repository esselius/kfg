# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    den.url = "github:vic/den";
    determinate.url = "github:DeterminateSystems/determinate/lucperkins/cf-170-improve-the-nix-darwin-solution-for-better-user-experience";
    disko.url = "github:nix-community/disko";
    flake-aspects.url = "github:vic/flake-aspects";
    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
      url = "github:hercules-ci/flake-parts";
    };
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    import-tree.url = "github:vic/import-tree";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nixos-raspberrypi = {
      inputs.nixpkgs.follows = "nixpkgs-modules-with-keys";
      url = "github:nvmd/nixos-raspberrypi/main";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-lib.follows = "nixpkgs";
    nixpkgs-modules-with-keys.url = "github:nvmd/nixpkgs/modules-with-keys-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixvim = {
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      url = "github:nix-community/nixvim";
    };
    secrets = {
      flake = false;
      url = "git+ssh://git@github.com/esselius/secrets";
    };
    sops-nix.url = "github:Mic92/sops-nix";
    systems.url = "github:nix-systems/default";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

}
