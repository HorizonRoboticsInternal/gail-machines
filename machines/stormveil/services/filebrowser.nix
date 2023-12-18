{ config, pkgs, lib, ... }:

{
  config = let
    port = 7002;

    root = "/var/lib/nas/data";
    db = "/var/lib/nas/filebrowser.db";
    settings = "/var/lib/nas/settings.json";

    runner = {
      user = config.users.users.gail;
      group = config.users.extraGroups.users;
    };

  in {
    virtualisation.oci-containers.containers."filebrowser" = {
      image = "filebrowser/filebrowser:s6";
      environment = {
        "PUID" = "${toString runner.user.uid}";
        "PGID" = "${toString runner.group.gid}";
      };
      ports = [ "${toString port}:80" ];
      volumes = [
        "${root}:/srv"
        "${db}:/database/filebrowser.db"
        "${settings}:/config/settings.json"
      ];
    };

    systemd.tmpfiles.rules = [
      "d ${root} 775 gail users -"
      "d ${db}/db 775 gail users -"
      "d ${settings}/web 775 gail users -"
    ];

    # The nginx configuration to expose it if nginx is enabled.
    services.nginx.virtualHosts = lib.mkIf config.services.nginx.enable {
      "gailnas.breakds.net" = {
        locations."/".proxyPass = "http://localhost:${toString port}";
      };
    };
  };
}
