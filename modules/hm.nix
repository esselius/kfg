{
  den.aspects.hm-base = rec {
    darwin = nixos;

    nixos = {
      home-manager = {
        backupFileExtension = "hm.bak";
      };
    };
  };
}
