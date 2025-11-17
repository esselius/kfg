{ den, ... }:
{
  den.aspects.Fox = {
    darwin.system.stateVersion = 4;

    includes = [ den.aspects.determinate ];
  };
}
