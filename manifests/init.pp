#
class profile_seaweedfs (
  String  $ip_address,
  Boolean $filer,
  String  $filer_ip,
  Boolean $master,
  String  $master_ip,
  Boolean $volume,
  String  $archive_name,
  Integer $filer_port,
  String  $filer_replication,
  Integer $master_port,
  String  $master_replication,
  Array   $master_peers,
  Boolean $mount,
  Hash    $mounts,
  Hash    $mount_defaults,
  String  $version,
  String  $volume_data_dir,
  Integer $volume_max_volumes,
  Integer $volume_port,
  Boolean $manage_sd_service,
) {
  class { 'seaweedfs':
    archive_name => $archive_name,
    filer_ip     => $filer_ip,
    filer_port   => $filer_port,
    ipaddress    => $ip_address,
    master_ip    => $master_ip,
    master_port  => $master_port,
    version      => $version,
  }

  if $master {
    include profile_seaweedfs::master
  }

  if $filer {
    include profile_seaweedfs::filer
  }

  if $volume {
    include profile_seaweedfs::volume
  }

  if $mount {
    create_resources('seaweedfs::mount', $mounts, $mount_defaults)
  }
}
