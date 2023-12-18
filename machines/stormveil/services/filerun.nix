{ config, pkgs, lib, ... }:

{
  config = let
    port = 7001;
    workDir = "/var/lib/nas";
    dbPath = "${workDir}/db";
    dbContainerName = "filerun-db";
    # The filerun container will need to use the hostname to connect to
    # the databse. By convention:
    #
    # 1. Docker containers in the same network uses the container's
    #    name as the hostname to access each other.
    # 2. In NixOS the container's actual name will be docker-<name>.service
    # 3. Hence the composite hostname below.
    dbContainerHost = "${dbContainerName}";
    bridgeNetworkName = "filerun_network";

    runner = {
      user = config.users.users.gail;
      group = config.users.extraGroups.users;
    };

    dbPasswd = "filerunpasswd";

  in {
    # Note that both containers will be put in the same bridge network.

    # The database (MariaDB)
    virtualisation.oci-containers.containers."${dbContainerName}" = {
      image = "mariadb:10.1";
      environment = {
        "MYSQL_ROOT_PASSWORD" = dbPasswd;
        "MYSQL_USER" = "filerun";
        "MYSQL_PASSWORD" = dbPasswd;
        "MYSQL_DATABASE" = "filerundb";
      };
      volumes = [ "${dbPath}:/var/lib/mysql" ];
      extraOptions = [ "--network=${bridgeNetworkName}" ];
    };

    # The backend and web app (Filerun)
    virtualisation.oci-containers.containers."filerun" = {
      image = "filerun/filerun:8.1";
      environment = {
        "FR_DB_HOST" = "${dbContainerHost}";
        # This is the default port that mariadb runs at.
        "FR_DB_PORT" = "3306";
        "FR_DB_NAME" = "filerundb";
        "FR_DB_USER" = "filerun";
        "FR_DB_PASS" = dbPasswd;
        "APACHE_RUN_USER" = "${runner.user.name}";
        "APACHE_RUN_USER_ID" = "${toString runner.user.uid}";
        "APACHE_RUN_GROUP" = "${runner.group.name}";
        "APACHE_RUN_GROUP_ID" = "${toString runner.group.gid}";
      };
      ports = [ "${toString port}:80" ];
      volumes = [
        "${workDir}/web:/var/www/html"
        "${workDir}/data:/user-files"
      ];
      extraOptions = [ "--network=${bridgeNetworkName}" ];
      dependsOn = [ dbContainerName ];
    };

    # This is an one-shot systemd service to make sure that the
    # required network is there.
    systemd.services.init-filerun-network-and-files = {
      description = "Create the network bridge ${bridgeNetworkName} for filerun.";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig.Type = "oneshot";

      script = let dockercli = "${config.virtualisation.docker.package}/bin/docker";
               in ''
                 # Put a true at the end to prevent getting non-zero return code, which will
                 # crash the whole service.
                 check=$(${dockercli} network ls | grep "${bridgeNetworkName}" || true)
                 if [ -z "$check" ]; then
                   ${dockercli} network create ${bridgeNetworkName}
                 else
                   echo "${bridgeNetworkName} already exists in docker"
                 fi
               '';
    };

    systemd.tmpfiles.rules = [
      "d ${workDir} 775 gail users -"
      "d ${workDir}/db 775 gail users -"
      "d ${workDir}/web 775 gail users -"
      "d ${workDir}/user-files 775 gail users -"
    ];

    # The nginx configuration to expose it if nginx is enabled.
    services.nginx.virtualHosts = lib.mkIf config.services.nginx.enable {
      "gailnas.breakds.net" = {
        locations."/".proxyPass = "http://localhost:${toString port}";
      };
    };
  };
}
