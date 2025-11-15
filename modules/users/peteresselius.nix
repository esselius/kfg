{ den, ... }:
{
  den.aspects.peteresselius = {
    darwin =
      { pkgs, ... }:
      {
        environment.shells = [ pkgs.fish ];
      };

    nixos = {
      nix.settings.trusted-users = [ "peteresselius" ];
      users.users.peteresselius = {
        description = "Peter Esselius";

        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFMdasDSm/XlOpv15asMENnQ/E9W9rXExBcUAVd/G6Mo"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKSArp+2Vu/AgbaiFYRLH/gtENAqwd6/aPVwgX429Tk+"
        ];
      };

      security.sudo.wheelNeedsPassword = false;
      users.mutableUsers = false;
    };

    homeManager.home.stateVersion = "24.05";

    includes = [
      den._.define-user
      den._.primary-user
      den._.home-manager
      (den._.user-shell "fish")
      den.aspects.hm-base
    ];
  };
}
