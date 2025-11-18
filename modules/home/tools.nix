{ den, ... }:
{
  den.aspects.tools.provides = {
    home.includes = with den.aspects.tools._; [
      ripgrep
      other
    ];

    work.includes = with den.aspects.tools._; [
      data
      google-cloud
      k8s
      other
      ripgrep
      work-extras
    ];

    ripgrep.homeManager = {
      programs = {
        fish = {
          shellAbbrs = {
            rg = "rg -S --hidden --glob '!.git/*'";
          };
        };
        ripgrep = {
          enable = true;
        };
      };
    };

    k8s.homeManager =
      { pkgs, ... }:
      {
        programs = {
          fish = {
            shellAbbrs = {
              k = "kubectl";
              kcuc = "kubectl config use-context";
              kccc = "kubectl config current-context";
            };
          };
        };

        home.packages = with pkgs; [
          k9s
          stern
          kubectl
        ];

        programs.krewfile = {
          enable = true;
          plugins = [ "oidc-login" ];
        };
      };

    google-cloud.homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          google-cloud-sdk
        ];
      };

    data.homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          minio-client
          trino-cli
        ];
      };

    other.homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          file
          jq
          nixos-rebuild
          nmap
          tree
          watch
          yq
          zstd
        ];
      };
    work-extras.homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          socat
        ];
      };
  };
}
