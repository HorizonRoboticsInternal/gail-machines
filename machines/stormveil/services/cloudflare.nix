{ config, lib, pkgs, ... }:

{
  config = {
    services.cloudflared = {
      enable = true;
      tunnels = {
        "e683fc73-ccf0-4278-97d7-c5a6ae8abf81" = {
          credentialsFile = "/home/breakds/.cloudflared/e683fc73-ccf0-4278-97d7-c5a6ae8abf81.json";
          ingress = {
            "*.breakds.net" = "http://localhost:80";
          };
          default = "http_status:404";
        };
      };
    };
  };
}
