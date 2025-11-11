{ inputs, ... }:
{
  den.aspects.hw-rpi5 = {
    nixos =
      { pkgs, ... }:
      {
        imports = [
          inputs.nixos-raspberrypi.nixosModules.raspberry-pi-5.base
          inputs.nixos-raspberrypi.nixosModules.raspberry-pi-5.bluetooth
        ];

        # 4KB kernel page size for Raspberry Pi 5
        # The standard 16KB cause issues with some software, like zfs + qemu-img
        boot.kernelPackages = pkgs.linuxPackages_rpi4;

        # Recommended default: https://github.com/nvmd/nixos-raspberrypi/tree/develop#provides-bootloader-infrastructure}
        boot.loader.raspberryPi.bootloader = "kernel";
      };
  };

  flake.lib.instantiate-rpi5-host =
    args:
    inputs.nixos-raspberrypi.lib.nixosSystem {
      inherit (inputs.nixos-raspberrypi.inputs) nixpkgs;
      specialArgs = { inherit (inputs) nixos-raspberrypi; };
    }
    // args;

  flake-file.inputs.nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
  flake-file.inputs.nixpkgs-modules-with-keys.url = "github:nvmd/nixpkgs/modules-with-keys-25.05";
  flake-file.inputs.nixos-raspberrypi.inputs.nixpkgs.follows = "nixpkgs-modules-with-keys";
}
