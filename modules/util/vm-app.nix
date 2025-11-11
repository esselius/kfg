{ lib, ... }:
{
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
