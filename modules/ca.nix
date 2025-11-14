{
  den.aspects.ca-server.nixos =
    { config, ... }:
    {
      services.step-ca = {
        enable = true;

        port = 8400;
        address = "0.0.0.0";

        intermediatePasswordFile = config.secrets.acme-intermediate-password.path;

        settings = {
          root = config.secrets.acme-root-cert.path;
          crt = config.secrets.acme-intermediate-cert.path;
          key = config.secrets.acme-intermediate-key.path;

          dnsNames = [ ("acme." + config.kfg.domain) ];

          db = {
            type = "badgerv2";
            dataSource = "/var/lib/step-ca/db";
          };

          authority.provisioners = [
            {
              type = "ACME";
              name = "my-acme-provisioner";
            }
          ];
        };
      };

      secrets.acme-root-cert = {
        owner = "step-ca";
        literal = builtins.readFile ../certs/root-ca.crt;
      };
      secrets.acme-intermediate-cert = {
        owner = "step-ca";
        literal = builtins.readFile ../certs/intermediate-ca.crt;
      };
      secrets.acme-intermediate-key = {
        owner = "step-ca";
        literal = builtins.readFile ../certs/intermediate-ca.key;
      };
      secrets.acme-intermediate-password = {
        owner = "step-ca";
        literalPath = "/dev/null";
      };
    };

  den.aspects.ca-client.nixos =
    { config, ... }:
    {
      security.acme = {
        defaults = {
          server = "https://acme.${config.kfg.domain}:8400/acme/my-acme-provisioner/directory";

          email = "e@mail.com";
        };
        acceptTerms = true;
      };
    };

  den.aspects.ca-trust.nixos = {
    security.pki.certificateFiles = [ ../certs/root-ca.crt ];
  };
}
