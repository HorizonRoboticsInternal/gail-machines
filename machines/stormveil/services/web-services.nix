{ config, lib, pkgs, ... }:

{
  services.nginx = {
    enable = true;
    package = pkgs.nginxMainline;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    clientMaxBodySize = "1000m";

    virtualHosts = {
      "gaildata.breakds.net" = {
        locations."/" = {
          root = "/var/lib/gaildata";
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
