{ den, ... }:
{
  den.aspects.grafana = {
    provides = {
      vm.includes = with den.aspects.grafana._; [
        server
        forward-ports
        tls
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
