{ config, lib, pkgs, ... }:

{
  users = {
    extraUsers.gail = {
      group = "gail";
      isNormalUser = false;
      uid = 602;
      extraGroups = [ "extraUsers" ];
    };

    extraGroups.gail = {
      gid = 602;
      members = [ "gail" ];
    };
  };
}
