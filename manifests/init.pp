#
class profile_seaweedfs (
  String  $archive_name,
  String  $version,
  String  $ip_address,
  String  $filer_ip,
  Integer $filer_port,
  String  $master_ip,
  Integer $master_port,
  Boolean $manage_sd_service,
  Boolean $master,
  Hash    $masters,
  Hash    $master_defaults,
  Boolean $filer,
  Hash    $filers,
  Hash    $filer_defaults,
  Boolean $volume,
  Hash    $volumes,
  Hash    $volume_defaults,
  Boolean $mount,
  Hash    $mounts,
  Hash    $mount_defaults,
) {
  class { 'seaweedfs':
    archive_name => $archive_name,
    version      => $version,
    ipaddress    => $ip_address,
    filer_ip     => $filer_ip,
    filer_port   => $filer_port,
    master_ip    => $master_ip,
    master_port  => $master_port,
  }

  if $master {
    create_resources('profile_seaweedfs::master', $masters, $master_defaults)
  }

  if $filer {
    create_resources('profile_seaweedfs::filer', $filers, $filer_defaults)
  }

  if $volume {
    create_resources('profile_seaweedfs::volume', $volumes, $volume_defaults)
  }

  if $mount {
    package { 'fuse':
      ensure => installed,
    }

    create_resources('seaweedfs::mount', $mounts, $mount_defaults)
  }
}
