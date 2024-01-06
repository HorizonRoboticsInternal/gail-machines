{ config, lib, pkgs, ... }:

{
  config = {
    services.github-runners."Hobot" = {
      name = "STORMVEIL-HOBOT-0";
      
      # Leave `user` and `workDir` as null (i.e. not configured) so that they
      # will be dynamically created at runtime.
      
      enable = true;
      replace = true;  # Replace any existing runner with the same name.
      url = "https://github.com/HorizonRoboticsInternal/Hobot";
      tokenFile = "/home/breakds/.config/github/runner_registration_token.001";

      extraPackages = [ pkgs.docker ];
      extraLabels = [ "stormveil" ];
    };
  };
}
