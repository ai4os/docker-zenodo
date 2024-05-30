job "test-zenodo" {
  namespace = "default"
  type      = "service"
  region    = "global"
  id        = "test-zenodo"
  priority  = "50"

  group "usergroup" {

    task "storagetask" {
      // Running task in charge of mounting storage
	
      lifecycle {
        hook = "prestart"
        sidecar = true
      }
      
      driver = "docker"

      config {
        force_pull = true
        image   = "ignacioheredia/ai4-docker-storage"
        privileged = true
        volumes = [
          "/nomad-storage/test-zenodo:/storage:shared",
        ]
      }

      env {
        RCLONE_CONFIG               = "/srv/.rclone/rclone.conf"
        RCLONE_CONFIG_RSHARE_TYPE   = "webdav"
        RCLONE_CONFIG_RSHARE_URL    = "https://share.services.ai4os.eu/remote.php/webdav/"
        RCLONE_CONFIG_RSHARE_VENDOR = "nextcloud"
        RCLONE_CONFIG_RSHARE_USER   = "EGI USER"
        RCLONE_CONFIG_RSHARE_PASS   = "NEXTCLOUD PASSWORD"
        REMOTE_PATH                 = "rshare:/"
        LOCAL_PATH                  = "/storage"
      }

    }

    task "zenodo-preload" {

      lifecycle {
        hook = "prestart"
        sidecar = false
      }

      driver = "docker"

      config {
        force_pull = true
        image      = "sftobias/zenodo-download"
        volumes    = [
          "/nomad-storage/test-zenodo:/storage:shared",
        ]
      }

      env {
        RECORD_ID = "7139731"
      }

      resources {
        cpu    = 50        # minimum number of CPU MHz is 2
        memory = 8000
      }

    }

    task "usertask" {

      driver = "docker"

      config {
        force_pull = true
        image      = "DOCKER IMAGE"
        volumes    = [
          "/nomad-storage/test-zenodo:/storage:shared",
        ]
      }

      env {
        RCLONE_CONFIG               = "/srv/.rclone/rclone.conf"
        RCLONE_CONFIG_RSHARE_TYPE   = "webdav"
        RCLONE_CONFIG_RSHARE_URL    = "https://share.services.ai4os.eu/remote.php/webdav/"
        RCLONE_CONFIG_RSHARE_VENDOR = "nextcloud"
        RCLONE_CONFIG_RSHARE_USER   = "EGI USER"
        RCLONE_CONFIG_RSHARE_PASS   = "NEXTCLOUD PASSWORD"
      }

    }

    task "storagecleanup" {
      // Unmount empty storage folder and delete it from host

      lifecycle {
        hook = "poststop"
      }

      driver = "raw_exec"

      config {
        command = "/bin/bash"
        args = ["-c", "sudo umount /nomad-storage/test-zenodo && sudo rmdir /nomad-storage/test-zenodo" ]

      }
    }
  }
}
