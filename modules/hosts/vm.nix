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
      vm-base.nixos = {
        services.getty.autologinUser = "root";
      };
      services.includes = [ den.aspects.postgres ];
    };
  };

  perSystem =
    { pkgs, ... }:
    {
      apps.vm = config.flake.lib.mkVMApp config.flake.nixosConfigurations.vm pkgs false;
    };
}
