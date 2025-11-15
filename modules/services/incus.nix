{
  den.aspects.incus = {
    nixos =
      { config, pkgs, ... }:
      {
        networking.nftables.enable = true;
        networking.firewall.allowedTCPPorts = [ 9999 ];

        virtualisation.incus = {
          enable = true;
          package = pkgs.incus;
          ui.enable = true;
          preseed = {
            config = {
              "core.https_address" = "0.0.0.0:9999";
              "acme.agree_tos" = "true";
              "acme.domain" = config.kfg.domain;
              "acme.email" = config.security.acme.defaults.email;
              "acme.ca_url" = config.security.acme.defaults.server;
            };
            networks = [
              {
                config = {
                  "ipv4.address" = "auto";
                  "ipv6.address" = "auto";
                };
                description = "";
                name = "incusbr0";
                type = "bridge";
                project = "default";
              }
            ];
            profiles = [
              {
                config = {
                  "raw.qemu.conf" = ''
                    [memory]
                    maxmem = "256G"
                  '';
                  "security.secureboot" = "false";
                };
                description = "";
                devices = {
                  eth0 = {
                    name = "eth0";
                    network = "incusbr0";
                    type = "nic";
                  };
                  root = {
                    path = "/";
                    pool = "default";
                    type = "disk";
                    size = "20GB";
                  };
                };
                name = "default";
                project = "default";
              }
            ];
          };
        };

        networking.firewall.interfaces.incusbr0.allowedTCPPorts = [
          53
          67
        ];
        networking.firewall.interfaces.incusbr0.allowedUDPPorts = [
          53
          67
        ];
      };

    provides = {
      zfs-storage.nixos = {
        virtualisation.incus.preseed.storage_pools = [
          {
            config.source = "rpool/incus";
            name = "default";
            driver = "zfs";
          }
        ];
      };
      dir-storage.nixos = {
        virtualisation.incus.preseed.storage_pools = [
          {
            name = "default";
            driver = "dir";
          }
        ];
      };
      forward-ports.nixos = {
        virtualisation.vmVariant.virtualisation.forwardPorts = [
          {
            host.port = 9999;
            guest.port = 9999;
          }
        ];
      };
    };
  };
}
