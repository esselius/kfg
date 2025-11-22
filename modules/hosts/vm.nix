{
  config,
  den,
  lib,
  ...
}:
{
  den.aspects.vm = {
    nixos.system.stateVersion = "25.11";

    includes = with den.aspects.vm._; [
      vm-base
      services
    ];

    provides = {
      vm-base.nixos = {
        services.getty.autologinUser = "root";
        kfg.domain = "localho.st";
      };
      services.includes = [
        den.aspects.sshd
        den.aspects.sshd._.forward-ports
        den.aspects.postgres
        den.aspects.incus
        den.aspects.incus._.dir-storage
        den.aspects.incus._.forward-ports
        den.aspects.ca-server
        den.aspects.ca-server._.forward-ports
        den.aspects.ca-client
        den.aspects.ca-trust
        den.aspects.secrets._.fake
        den.aspects.domain
        den.aspects.prometheus._.vm
        den.aspects.grafana._.vm
        den.aspects.loki._.vm
        den.aspects.alloy._.vm
      ];
    };
  };

  perSystem =
    { pkgs, ... }:
    {
      apps.vm = config.flake.lib.mkVMApp config.flake.nixosConfigurations.vm pkgs false;
    };

  flake.lib.mkVMApp =
    config: pkgs: useDiskImage:
    let
      extendedNixosConfig = config.extendModules { modules = [ module ]; };
      program = lib.getExe extendedNixosConfig.config.system.build.vm;

      module = {
        virtualisation.vmVariant = {
          virtualisation = {
            host.pkgs = pkgs;
            diskImage = lib.mkIf (!useDiskImage) null;
          };
        };
      };
    in
    {
      inherit program;
    };
}
