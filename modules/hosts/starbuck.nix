{ den, ... }:
{
  den.aspects.starbuck = {
    nixos = {
      system.stateVersion = "24.05";
      networking.hostId = "9c8031a8";
    };

    includes = with den.aspects.starbuck._; [
      hw
      services
    ];

    provides = {
      services.includes = [ den.aspects.sshd ];

      hw.includes = [
        den.aspects.hw-rpi5
        den.aspects.disko-nvme-zfs
      ];
    };
  };
}
