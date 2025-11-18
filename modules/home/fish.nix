{
  den.aspects.fish.homeManager =
    { pkgs, ... }:

    {
      programs = {
        command-not-found.enable = false;
        nix-index-database.comma.enable = true;

        fish = {
          enable = true;
          interactiveShellInit = ''
            ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
          '';
        };

        starship = {
          enable = true;
          enableFishIntegration = true;
          settings = {
            gcloud.disabled = true;
            git_status.disabled = true;
            python.disabled = true;
            scala.disabled = true;
          };
        };

        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };
      };
    };
}
