{ ... }:

{
  virtualisation.docker = {
    enable = true;
    # Weekly cleanup of dangling images/containers.
    autoPrune.enable = true;
  };
}
