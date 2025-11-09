{ den, ... }:
{
  den.aspects.peteresselius = {
    homeManager.home.stateVersion = "24.05";

    includes = [
      den._.define-user
      den._.primary-user
      den._.home-manager
    ];
  };
}
