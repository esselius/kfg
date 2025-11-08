{ den, ... }:
{
  den.aspects.peteresselius = {
    homeManager.home.stateVersion = "24.05";

    includes = [
      den._.define-user
      den._.primary-user

      # Add home-manager configurations to host configurations
      (
        { userToHost }:
        {
          includes = [ (den._.home-manager { inherit (userToHost) host; }) ];
        }
      )
    ];
  };
}
