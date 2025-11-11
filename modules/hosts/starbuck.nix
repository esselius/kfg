{ den, ... }:
{
  den.aspects.starbuck = {
    nixos.system.stateVersion = "24.05";

    includes = [
      den.aspects.starbuck._.hw
    ];

    hw.includes = [
      den.aspects.hw-rpi5
      den.aspects.disko-nvme-zfs
    ];
  };
}
