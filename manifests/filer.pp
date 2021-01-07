#
define profile_seaweedfs::filer (
  String  $ip_address        = $::profile_seaweedfs::ip_address,
  Integer $filer_port        = 8888,
  String  $filer_replication = '001',
  Boolean $manage_sd_service = $::profile_seaweedfs::manage_sd_service,
) {
  seaweedfs::filer { $title:
    replication => $filer_replication,
    port        => $filer_port,
  }

  firewall { "0${filer_port} allow seaweedfs filer http":
    dport  => $filer_port,
    action => 'accept',
  }

  $_filer_grpc = $filer_port + 10000
  firewall { "${_filer_grpc} allow seaweedfs filer grpc":
    dport  => $_filer_grpc,
    action => 'accept',
  }

  if $manage_sd_service {
    consul::service { "seaweedfs-filer-${title}":
      checks => [
        {
          http     => "http://${ip_address}:${filer_port}",
          interval => '10s'
        }
      ],
      port   => $filer_port,
    }
  }
}

