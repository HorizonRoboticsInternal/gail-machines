{ config, lib, pkgs, ... }:

{
  users.users.breakds = {
    uid = 1000;
    description = "Break Yang";
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
	    "dialout"  # Access /dev/ttyUSB* devices
	    "uucp"  # Access /ev/ttyS... RS-232 serial ports and devices.
	    "audio"
	    "plugdev"  # Allow members to mount/umount removable devices via pmount.
      "gitea"
	    "lxd"
	    "docker"
      "nginx"
    ];
    packages = with pkgs; [
      tree
      lsd
    ];
    
    openssh.authorizedKeys.keyFiles = [
      ../data/keys/breakds_samaritan.pub
    ];
  };
}
