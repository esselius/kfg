{ den, ... }:
{
  den.aspects.loki = {
    provides = {
      vm.includes = with den.aspects.loki._; [
        server
        forward-ports
        tls
        base
      ];

      server.nixos = {
        services.loki = {
          enable = true;
        };
      };

      tls.nixos =
        { config, ... }:
        {
          security.acme.certs."loki.${config.kfg.domain}" = {
            group = "loki";
            listenHTTP = ":80";
            extraDomainNames = [ config.kfg.domain ];
          };
          services.loki.configuration.server.http_tls_config = {
            cert_file = config.security.acme.certs."loki.${config.kfg.domain}".directory + "/cert.pem";
            key_file = config.security.acme.certs."loki.${config.kfg.domain}".directory + "/key.pem";
          };
        };

      base.nixos = {
        services.loki.configuration = {
          server = {
            http_listen_port = 3100;
          };
          auth_enabled = false;

          ingester = {
            lifecycler = {
              address = "127.0.0.1";
              ring = {
                kvstore.store = "inmemory";
                replication_factor = 1;
              };
              final_sleep = "0s";
            };
            chunk_idle_period = "5m";
            chunk_retain_period = "30s";
          };

          schema_config.configs = [
            {
              from = "2024-04-01";
              store = "tsdb";
              object_store = "filesystem";
              schema = "v13";
              index = {
                prefix = "index_";
                period = "24h";
              };
            }
          ];
          storage_config = {
            tsdb_shipper = {
              active_index_directory = "/var/lib/loki/tsdb-index";
              cache_location = "/var/lib/loki/tsdb-cache";
              cache_ttl = "24h";
            };
            filesystem.directory = "/var/lib/loki/chunks";
          };

          compactor = {
            working_directory = "/var/lib/loki";
            compactor_ring = {
              kvstore = {
                store = "inmemory";
              };
            };
          };
        };
      };

      forward-ports.nixos = {
        networking.firewall.allowedTCPPorts = [ 3100 ];
        virtualisation.vmVariant.virtualisation.forwardPorts = [
          {
            host.port = 3100;
            guest.port = 3100;
          }
        ];
      };
    };
  };
}
