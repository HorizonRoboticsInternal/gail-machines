{ config, lib, pkgs, ... }:

{
  users.users.wei = {
    uid = 1002;
    description = "Wei Xu";
    isNormalUser = true;
    extraGroups = [
	    "docker"
      "nginx"
    ];
    packages = with pkgs; [];
  };
}
