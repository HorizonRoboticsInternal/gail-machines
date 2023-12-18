{ config, lib, pkgs, ... }:

{
  users = {
    extraUsers.gail = {
      group = "gail";
      isNormalUser = false;
      uid = 602;
      extraGroups = [ "users" ];
    };

    extraGroups.gail = {
      gid = 602;
      members = [ "gail" "haonan" "le" "breakds" "jerry" "haichao" "wei"];
    };
  };
}
