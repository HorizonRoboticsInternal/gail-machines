{ config, lib, pkgs, ... }:

{
  users.users.haonan = {
    uid = 1005;
    description = "Haonan Yu";
    isNormalUser = true;
    extraGroups = [
	    "docker"
      "nginx"
      "gail"
    ];
    packages = with pkgs; [];
  };
}
