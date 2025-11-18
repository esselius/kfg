{ inputs, ... }:
{
  flake-file.inputs.nix-homebrew.url = "github:zhaofengli/nix-homebrew";

  den.aspects.homebrew.darwin = {
    imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];
  };
}
