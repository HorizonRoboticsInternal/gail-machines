{ config, lib, pkgs, ... }:

{
  users.users.haichao = {
    uid = 1001;
    description = "Haichao Zhang";
    isNormalUser = true;
    extraGroups = [
	    "docker"
      "nginx"
    ];
    packages = with pkgs; [];
  };
}
