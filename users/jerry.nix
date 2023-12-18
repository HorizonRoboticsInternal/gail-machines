{ config, lib, pkgs, ... }:

{
  users.users.jerry = {
    uid = 1004;
    description = "Jerry Bai";
    isNormalUser = true;
    extraGroups = [
	    "docker"
      "nginx"
    ];
    packages = with pkgs; [];
  };
}
