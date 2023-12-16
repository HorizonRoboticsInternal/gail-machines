{ config, lib, pkgs, ... }:

{
  config = {
    services.cloudflared = {
      enable = true;
    };
  };
}
