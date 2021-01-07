#
define profile_seaweedfs::volume (
  String  $ip_address         = $::profile_seaweedfs::ip_address,
  String  $volume_data_dir    = '/srv/seaweedfs',
  Integer $volume_max_volumes = 7,
  Integer $volume_port        = 8080,
  Boolean $manage_sd_service  = $::profile_seaweedfs::manage_sd_service,
) {
  seaweedfs::volume { $title:
    data_dir    => $volume_data_dir,
    max_volumes => $volume_max_volumes,
    port        => $volume_port,
  }

  firewall { "0${volume_port} allow seaweedfs volume http":
    dport  => $volume_port,
    action => 'accept',
  }

  $_volume_grpc = $volume_port + 10000
  firewall { "${_volume_grpc} allow seaweedfs volume grpc":
    dport  => $_volume_grpc,
    action => 'accept',
  }

  if $manage_sd_service {
    consul::service { 'seaweedfs-volume':
      checks => [
        {
          http     => "http://${ip_address}:${volume_port}/status?pretty=y",
          interval => '10s'
        }
      ],
      port   => $volume_port,
    }
  }
}

