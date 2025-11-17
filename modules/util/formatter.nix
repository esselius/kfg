{ inputs, ... }:
{
  flake-file.inputs.treefmt-nix.url = "github:numtide/treefmt-nix";
  imports = [
    inputs.treefmt-nix.flakeModule
  ];

  perSystem = {
    treefmt = {
      programs = {
        nixfmt.enable = true;
        deadnix.enable = true;
        nixf-diagnose.enable = true;
        prettier.enable = true;
      };
      settings.on-unmatched = "fatal";
    };

  };
}
