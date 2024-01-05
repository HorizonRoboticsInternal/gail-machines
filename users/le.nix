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

    openssh.authorizedKeys.keyFiles = [
      ../data/keys/breakds_samaritan.pub
    ];
  };


  home-manager.users.le = {
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

    programs.git = {
      enable = true;
      package = lib.mkDefault pkgs.gitAndTools.gitFull;
      userName = lib.mkDefault "Le Zhao";
      userEmail = lib.mkDefault "lzh@horizon.cc";

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
