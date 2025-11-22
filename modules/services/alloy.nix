{ den, ... }:
{
  den.aspects.alloy = {
    provides = {
      vm.includes = with den.aspects.alloy._; [
        base
        agent
        journal-to-loki
      ];

      base.nixos =
        { lib, config, ... }:
        {
          options.services.alloy.alloyFiles = lib.mkOption {
            type = lib.types.attrsOf lib.types.str;
          };

          config.environment.etc = lib.mapAttrs' (
            name: value: lib.nameValuePair ("alloy/${name}.alloy") ({ text = value; })
          ) config.services.alloy.alloyFiles;
        };

      agent.nixos = {
        services.alloy = {
          enable = true;
        };
      };

      journal-to-loki.nixos =
        { config, ... }:
        {
          services.alloy.alloyFiles.journal = ''
            loki.source.journal "logs" {
              forward_to = [loki.write.local.receiver]
            }

            loki.write "local" {
              endpoint {
                url = "https://${config.kfg.domain}:3100/loki/api/v1/push"
              }
            }
          '';
        };
    };
  };
}
