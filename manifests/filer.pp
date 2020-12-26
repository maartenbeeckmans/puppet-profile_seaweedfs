#
class profile_seaweedfs::filer (
  Integer $filer_port        = $::profile_seaweedfs::filer_port,
  String  $filer_replication = $::profile_seaweedfs::filer_replication,
) {
  class { 'seaweedfs::filer':
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
}

