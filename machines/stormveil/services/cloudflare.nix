{ config, lib, pkgs, ... }:

{
  config = {
    services.cloudflared = {
      enable = true;
      tunnels = {
        "e683fc73-ccf0-4278-97d7-c5a6ae8abf81" = {
          credentialsFile = "/var/lib/cloudflare/e683fc73-ccf0-4278-97d7-c5a6ae8abf81.json";
          ingress = {
            "*.breakds.net" = "http://localhost:2345";
          };
          default = "http_status:404";
        };
      };
    };
  };
}
