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
      "f ${db} 664 gail users -"
    ];

    systemd.services.init-filebrowser = {
      description = "Create files for filebrowser";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig.Type = "oneshot";

      script = ''
        # Path to the file
        file_path="/var/lib/nas/settings.json"

        # Check if the file exists
        if [ ! -f "$file_path" ]; then
            # If the file does not exist, create it and add the specified content
                echo '{
                  "port": 80,
                  "baseURL": "",
                  "address": "",
                  "log": "stdout",
                  "database": "/database/filebrowser.db",
                  "root": "/srv",
                  "branding": {
                    "name": "General AI Lab NAS"
                  }
                }' > "$file_path"

            # Change the ownership to user:gail and group:users
            chown gail:users "$file_path"

            echo "File created and ownership set to gail:users."
        fi
      '';
    };

    # The nginx configuration to expose it if nginx is enabled.
    services.nginx.virtualHosts = lib.mkIf config.services.nginx.enable {
      "gailnas.breakds.net" = {
        locations."/".proxyPass = "http://localhost:${toString port}";
      };
    };
  };
}
