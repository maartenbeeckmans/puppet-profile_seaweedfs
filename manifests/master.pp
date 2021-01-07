#
define profile_seaweedfs::master (
  String  $ip_address         = $::profile_seaweedfs::master_ip,
  Integer $master_port        = 9333,
  String  $master_replication = '001',
  Array   $master_peers       = [],
  Integer $volume_size_limit  = 25600,
  Boolean $manage_sd_service  = $::profile_seaweedfs::manage_sd_service,
) {
  seaweedfs::master { $title:
    replication       => $master_replication,
    ipaddress         => $ip_address,
    port              => $master_port,
    peers             => $master_peers,
    volume_size_limit => $volume_size_limit,
  }

  firewall { "0${master_port} allow seaweedfs master http":
    dport  => $master_port,
    action => 'accept',
  }

  $_master_grpc = $master_port + 10000
  firewall { "${_master_grpc} allow seaweedfs master grpc":
    dport  => $_master_grpc,
    action => 'accept',
  }

  if $manage_sd_service {
    consul::service { "seaweedfs-master-${title}":
      checks => [
        {
          http     => "http://${ip_address}:${master_port}/cluster/status?pretty=y",
          interval => '10s'
        }
      ],
      port   => $master_port,
    }
  }
}
