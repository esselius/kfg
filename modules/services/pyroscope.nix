{ den, inputs, ... }:
{
  den.aspects.pyroscope.provides = {
    vm.includes = with den.aspects.pyroscope._; [
      server
      nixpkgs-unstable-package
    ];

    server.nixos =
      { pkgs, lib, ... }:
      let
        cfg = (pkgs.formats.yaml { }).generate "pyroscope.yaml" {
          server.grpc_listen_port = 9096;

        };
      in
      {
        systemd.services.pyroscope = {
          description = "Pyroscope Service Daemon";
          wants = [ "network-online.target" ];
          after = [ "network-online.target" ];
          wantedBy = [ "multi-user.target" ];

          serviceConfig = {
            ExecStart = "${pkgs.pyroscope}/bin/pyroscope -config.file ${cfg}";
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
