{
  config,
  den,
  ...
}:
{
  den.aspects.vm = {
    nixos.system.stateVersion = "25.11";

    includes = [ den.aspects.vm._.vm-base ];

    provides = {
      vm-base.nixos = {
        services.getty.autologinUser = "root";
      };
    };
  };

  perSystem =
    { pkgs, ... }:
    {
      apps.vm = config.flake.lib.mkVMApp config.flake.nixosConfigurations.vm pkgs false;
    };
}
