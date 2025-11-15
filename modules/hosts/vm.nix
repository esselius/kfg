{
  config,
  den,
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
      vm-base.nixos =
        { modulesPath, ... }:
        {
          services.getty.autologinUser = "root";
          kfg.domain = "localho.st";
          imports = [ (modulesPath + "/virtualisation/qemu-vm.nix") ];
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
      ];
    };
  };

  perSystem =
    { pkgs, ... }:
    {
      apps.vm = config.flake.lib.mkVMApp config.flake.nixosConfigurations.vm pkgs false;
    };
}
