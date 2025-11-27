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
        pyroscope
        incus-metrics
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

      node-exporter.nixos = {
        services.alloy.alloyFiles.node_exporter = ''
          prometheus.exporter.unix "node_exporter" { }

          prometheus.scrape "node_exporter" {
            targets = prometheus.exporter.unix.node_exporter.targets
            forward_to = [prometheus.remote_write.prometheus.receiver]
          }
        '';
      };
      incus-metrics.nixos =
        { config, ... }:
        {
          services.alloy.alloyFiles.incus = ''
            prometheus.scrape "incus" {
              scheme = "https"
              metrics_path = "/1.0/metrics"
              targets = [
                {"__address__" = "${config.kfg.domain}:9999", "instance" = "incus"},
              ]
              forward_to = [prometheus.remote_write.prometheus.receiver]
            }
          '';
        };

      pyroscope.nixos =
        { config, ... }:
        {
          services.alloy.alloyFiles.pyroscope = ''
            discovery.process "all" { }

            discovery.relabel "alloy" {
                targets = discovery.process.all.targets
                // Filter needed processes
                rule {
                    source_labels = ["__meta_process_exe"]
                    regex = ".*/alloy"
                    action = "keep"
                }
            }

            pyroscope.ebpf "instance" {
             forward_to     = [pyroscope.write.pyroscope.receiver]
             targets = discovery.relabel.alloy.output
            }

            pyroscope.scrape "local" {
              forward_to     = [pyroscope.write.pyroscope.receiver]
              targets    = [
                {"__address__" = "localhost:12345", "service_name"="grafana/alloy"},
              ]
            }

            pyroscope.write "pyroscope" {
              endpoint {
                url = "https://${config.kfg.domain}:9096"
              }
            }
          '';
          systemd.services.alloy = {
            serviceConfig = {
              CapabilityBoundingSet = "CAP_SYS_PTRACE";
              AmbientCapabilities = "CAP_SYS_PTRACE";
            };
          };
        };
    };
  };
}
