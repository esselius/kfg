{ den, ... }:
{
  den.aspects.grafana = {
    provides = {
      vm.includes = with den.aspects.grafana._; [
        server
        forward-ports
        tls
        loki-datasource
        prometheus-datasource
      ];

      server.nixos = {
        services.grafana = {
          enable = true;
        };
      };

      tls.nixos =
        { config, ... }:
        {
          security.acme.certs."grafana.${config.kfg.domain}" = {
            group = "grafana";
            listenHTTP = ":80";
            extraDomainNames = [ config.kfg.domain ];
          };
          services.grafana.settings.server = {
            protocol = "https";
            cert_file = config.security.acme.certs."grafana.${config.kfg.domain}".directory + "/cert.pem";
            cert_key = config.security.acme.certs."grafana.${config.kfg.domain}".directory + "/key.pem";
          };
        };

      prometheus-datasource.nixos =
        { config, ... }:
        {
          services.grafana.provision = {
            enable = true;
            datasources.settings.datasources = [
              {
                name = "Prometheus";
                type = "prometheus";
                access = "proxy";
                url = "https://${config.kfg.domain}:${toString config.services.prometheus.port}";
              }
            ];
          };
        };

      loki-datasource.nixos =
        { config, ... }:
        {
          services.grafana.provision = {
            enable = true;
            datasources.settings.datasources = [
              {
                name = "Loki";
                type = "loki";
                url = "https://${config.kfg.domain}:${toString config.services.loki.configuration.server.http_listen_port}";
                access = "proxy";
              }
            ];
          };
        };

      forward-ports.nixos = {
        networking.firewall.allowedTCPPorts = [ 3000 ];
        virtualisation.vmVariant.virtualisation.forwardPorts = [
          {
            host.port = 3000;
            guest.port = 3000;
          }
        ];
        services.grafana.settings.server.http_addr = "0.0.0.0";
      };
    };
  };
}
