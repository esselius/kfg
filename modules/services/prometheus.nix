{ den, ... }:
{
  den.aspects.prometheus = {
    provides = {
      vm.includes = with den.aspects.prometheus._; [
        server
        forward-ports
        tls
      ];

      server.nixos = {
        services.prometheus = {
          enable = true;
        };
      };

      tls.nixos =
        { config, pkgs, ... }:
        {
          security.acme.certs."prometheus.${config.kfg.domain}" = {
            group = "prometheus";
            listenHTTP = ":80";
            extraDomainNames = [ config.kfg.domain ];
          };
          services.prometheus.webConfigFile = (pkgs.formats.yaml { }).generate "web-config.yaml" {
            tls_server_config = {
              cert_file = config.security.acme.certs."prometheus.${config.kfg.domain}".directory + "/cert.pem";
              key_file = config.security.acme.certs."prometheus.${config.kfg.domain}".directory + "/key.pem";
            };
          };

        };

      forward-ports.nixos = {
        networking.firewall.allowedTCPPorts = [ 9090 ];
        virtualisation.vmVariant.virtualisation.forwardPorts = [
          {
            host.port = 9090;
            guest.port = 9090;
          }
        ];
      };
    };
  };
}
