{
  den.aspects.adama = {
    nixos = {
      system.stateVersion = "24.05";
      fileSystems = {
        "/" = {
          device = "/dev/disk/by-label/NIXOS_SD";
          fsType = "ext4";
        };
        "/boot/firmware" = {
          device = "/dev/disk/by-label/FIRMWARE";
          fsType = "vfat";
        };
      };
    };

  };
}
