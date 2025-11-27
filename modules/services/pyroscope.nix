{ den, inputs, ... }:
{
  den.aspects.pyroscope.provides = {
    vm.includes = with den.aspects.pyroscope._; [
      server
      nixpkgs-unstable-package
    ];

    server.nixos =
      { pkgs, config, ... }:
      let
        cfg = (pkgs.formats.yaml { }).generate "pyroscope.yaml" {
          server = {
            http_listen_port = 4040;
            grpc_listen_port = 9096;
            grpc_tls_config = {
              cert_file = config.security.acme.certs."pyroscope.${config.kfg.domain}".directory + "/cert.pem";
              key_file = config.security.acme.certs."pyroscope.${config.kfg.domain}".directory + "/key.pem";
            };
          };
        };
      in
      {
        security.acme.certs."pyroscope.${config.kfg.domain}" = {
          group = "pyroscope";
          listenHTTP = ":80";
          extraDomainNames = [ config.kfg.domain ];
        };

        users.groups.pyroscope = { };
        users.users.pyroscope = {
          description = "Pyroscope Service User";
          group = "pyroscope";
          home = "/var/lib/pyroscope";
          createHome = true;
          isSystemUser = true;
        };

        systemd.services.pyroscope = {
          description = "Pyroscope Service Daemon";
          wants = [ "network-online.target" ];
          after = [ "network-online.target" ];
          wantedBy = [ "multi-user.target" ];

          serviceConfig = {
            ExecStart = "${pkgs.pyroscope}/bin/pyroscope -config.file ${cfg}";
            User = "pyroscope";
            PrivateTmp = true;
            Restart = "always";
            WorkingDirectory = "/var/lib/pyroscope";
          };
        };
      };

    nixpkgs-unstable-package.nixos = {
      nixpkgs.overlays = [
        (final: prev: { pyroscope = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.pyroscope; })
      ];
    };
  };
}
