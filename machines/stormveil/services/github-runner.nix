# To add a new runner, go to GitHub page of Hobot, click Settings > Actions >
# Runners, and then click to create a new runner. The only thing you need to do
# manually is find the token and save it to a toke file. Duplicate the runner
# block below, and just modify the name and toke file and you are all set.

{ config, lib, pkgs, ... }:

{
  config = {
    services.github-runners."Hobot" = {
      name = "STORMVEIL-HOBOT-0";
      
      # Leave `user` and `workDir` as null (i.e. not configured) so that they
      # will be dynamically created at runtime.

      user = "root";
      enable = true;
      replace = true;  # Replace any existing runner with the same name.
      url = "https://github.com/HorizonRoboticsInternal/Hobot";
      tokenFile = "/home/breakds/.config/github/runner_registration_token.001";

      extraPackages = [ pkgs.docker ];
      extraLabels = [ "stormveil" ];
    };

    services.github-runners."Hobot002" = {
      name = "STORMVEIL-HOBOT-2";
      
      # Leave `user` and `workDir` as null (i.e. not configured) so that they
      # will be dynamically created at runtime.

      user = "root";      
      enable = true;
      replace = true;  # Replace any existing runner with the same name.
      url = "https://github.com/HorizonRoboticsInternal/Hobot";
      tokenFile = "/home/breakds/.config/github/runner_registration_token.002";

      extraPackages = [ pkgs.docker ];
      extraLabels = [ "stormveil" ];
    };
  };
}
