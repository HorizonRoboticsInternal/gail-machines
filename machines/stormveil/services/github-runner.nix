{ config, lib, pkgs, ... }:

{
  config = {
    services.github-runners."Hobot" = {
      enable = true;
    };
  };
}
