#
class profile_seaweedfs::master (
  String  $master_ip          = $::profile_seaweedfs::master_ip,
  Integer $master_port        = $::profile_seaweedfs::master_port,
  String  $master_replication = $::profile_seaweedfs::master_replication,
  Array   $master_peers       = $::profile_seaweedfs::master_peers,
  Boolean $manage_sd_service  = $::profile_seaweedfs::manage_sd_service,
) {
  class { 'seaweedfs::master':
    replication => $master_replication,
    ipaddress   => $master_ip,
    port        => $master_port,
    peers       => $master_peers,
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
    consul::service { 'seaweedfs-master':
      checks => [
        {
          http     => "http://${master_ip}:${master_port}/cluster/status?pretty=y",
          interval => '10s'
        }
      ],
      port   => $master_port,
    }
  }
}
