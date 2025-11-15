{ inputs, ... }:
{
  flake-file.inputs.sops-nix.url = "github:Mic92/sops-nix";
  flake-file.inputs.secrets = {
    url = "git+ssh://git@github.com/esselius/secrets";
    flake = false;
  };

  den.aspects.secrets.provides = {
    sops.nixos =
      {
        lib,
        config,
        ...
      }:
      let
        inherit (lib.types)
          attrsOf
          submodule
          anything
          path
          ;
      in
      {
        imports = [ inputs.sops-nix.nixosModules.sops ];

        options = {
          secrets = lib.mkOption {
            type = attrsOf (
              submodule (
                { name, ... }:
                {
                  freeformType = attrsOf anything;
                  options = {
                    path = lib.mkOption {
                      type = path;
                      default = config.sops.secrets.${name}.path;
                    };
                  };
                }
              )
            );
          };
        };

        config = {
          sops.defaultSopsFile = inputs.secrets + "/nixos-" + config.networking.hostName + ".yaml";
          sops.defaultSopsFormat = "yaml";

          sops.secrets = (
            lib.mapAttrs (
              _k: v:
              (builtins.removeAttrs v [
                "literal"
                "path"
                "literalPath"
              ])
            ) config.secrets
          );
        };
      };

    fake.nixos =
      {
        lib,
        config,
        pkgs,
        ...
      }:
      let
        inherit (lib.types)
          attrsOf
          submodule
          anything
          path
          ;
      in
      {
        options.secrets = lib.mkOption {
          type = attrsOf (
            submodule (
              { name, ... }:
              {
                freeformType = attrsOf anything;

                options = {
                  path = lib.mkOption {
                    type = path;
                    default =
                      config.secrets.${name}.literalPath or (pkgs.writeText name config.secrets.${name}.literal).outPath;
                  };
                };
              }
            )
          );
        };

      };
  };
}
