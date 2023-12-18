{ config, lib, pkgs, ... }:

{
  users.users.le = {
    uid = 1003;
    description = "Le Zhao";
    isNormalUser = true;
    extraGroups = [
	    "docker"
      "nginx"
      "gail"
    ];
    packages = with pkgs; [];
  };
}
