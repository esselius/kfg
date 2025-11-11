{ config, ... }:
{
  den.hosts.aarch64-linux.adama.users.peteresselius = { };
  den.hosts.aarch64-linux.adama.instantiate = config.flake.lib.instantiate-rpi5-host;
  den.hosts.aarch64-linux.starbuck.users.peteresselius = { };
  den.hosts.aarch64-linux.starbuck.instantiate = config.flake.lib.instantiate-rpi5-host;

  den.hosts.aarch64-linux.vm = { };

  den.hosts.aarch64-darwin.fox.users.peteresselius = { };

  flake-file.inputs.darwin.url = "github:nix-darwin/nix-darwin";
  flake-file.inputs.darwin.inputs.nixpkgs.follows = "nixpkgs";
  flake-file.inputs.home-manager.url = "github:nix-community/home-manager";
  flake-file.inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";
}
