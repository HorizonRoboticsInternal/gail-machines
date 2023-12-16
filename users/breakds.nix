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

  home-manager.users.breakds = {
    home.stateVersion = "23.11";
    
    home.file = {
      ".inputrc".text = ''
        "\e[A": history-search-backward
        "\e[B": history-search-forward
      '';
    };

    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv = {
        enable = true;
      };
    };

    programs.fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      defaultOptions = [ "--height 50%" "--border" ];
    };

    programs.git = {
      enable = true;
      package = lib.mkDefault pkgs.gitAndTools.gitFull;
      userName = lib.mkDefault "Break Yang";
      userEmail = lib.mkDefault "yiqing.yang@horizon.com";

      difftastic = {
        enable = true;
      };

      extraConfig = {
        pull.rebase = true;
        init.defaultBranch = "main";
        advice.addIgnoredFile = false;
      };
    };
  };
}
