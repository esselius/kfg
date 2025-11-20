{ inputs, ... }:
{
  flake-file.inputs.determinate.url = "github:DeterminateSystems/determinate/lucperkins/cf-170-improve-the-nix-darwin-solution-for-better-user-experience";

  den.aspects.determinate = {
    darwin = {
      imports = [
        inputs.determinate.darwinModules.default
      ];
      determinateNix = {
        enable = true;
        nixosVmBasedLinuxBuilder.enable = true;
      };
    };
  };
}
