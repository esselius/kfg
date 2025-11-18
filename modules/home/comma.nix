{ inputs, ... }:
{
  flake-file.inputs.nix-index-database.url = "github:nix-community/nix-index-database";

  den.aspects.comma.homeManager = {
    imports = [
      inputs.nix-index-database.homeModules.nix-index
    ];
    programs = {
      command-not-found.enable = false;
      nix-index-database.comma.enable = true;
    };
  };
}
