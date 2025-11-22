{ den, ... }:
{
  den.aspects.alloy = {
    provides = {
      vm.includes = with den.aspects.alloy._; [
        base
        agent
        journal-to-loki
        prometheus-remote-write
        node-exporter
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

      prometheus-remote-write.nixos =
        { config, ... }:
        {
          services.alloy.alloyFiles.prometheus-remote-write = ''
            prometheus.remote_write "prometheus" {
              endpoint {
                url = "https://${config.kfg.domain}:9090/api/v1/write"
              }
            }
          '';
        };

      node-exporter.nixos =
        { config, ... }:
        {
          services.alloy.alloyFiles.node_exporter = ''
            prometheus.exporter.unix "node_exporter" { }

            prometheus.scrape "node_exporter" {
              targets = prometheus.exporter.unix.node_exporter.targets
              forward_to = [prometheus.remote_write.prometheus.receiver]
            }
          '';
        };
    };
  };
}
