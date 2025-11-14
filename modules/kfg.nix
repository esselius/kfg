{
  den.aspects.domain.nixos =
    { lib, config, ... }:
    {
      options = {
        kfg.domain = lib.mkOption {
          type = lib.types.str;
          default = "${config.networking.hostName}.esselius.dev";
        };
      };
    };
}
