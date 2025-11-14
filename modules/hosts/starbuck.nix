{ den, ... }:
{
  den.aspects.starbuck = {
    nixos = {
      system.stateVersion = "24.05";
      networking.hostId = "9c8031a8";
      networking.hostName = "starbuck";
    };

    includes = with den.aspects.starbuck._; [
      hw
      services
    ];

    provides = {
      services.includes = [
        den.aspects.sshd
        den.aspects.incus
        den.aspects.incus._.zfs-storage
        den.aspects.ca-server
        den.aspects.ca-client
        den.aspects.ca-trust
        den.aspects.secrets._.sops
        den.aspects.domain
      ];

      hw.includes = [
        den.aspects.hw-rpi5
        den.aspects.disko-nvme-zfs
      ];
    };
  };
}
