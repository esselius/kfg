{ config, ... }:
{
  # den.hosts.aarch64-linux.adama.users.peteresselius = { };
  # den.hosts.aarch64-linux.adama.instantiate = config.flake.lib.instantiate-rpi5-host;
  den.hosts.aarch64-linux.starbuck.users.peteresselius = { };
  den.hosts.aarch64-linux.starbuck.instantiate = config.flake.lib.instantiate-rpi5-host;

  den.hosts.aarch64-linux.vm.users.peteresselius = { };

  den.hosts.aarch64-darwin.Fox.users.peteresselius = { };

  flake-file.inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
  flake-file.inputs.darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
  flake-file.inputs.home-manager.url = "github:nix-community/home-manager/release-25.05";
}
