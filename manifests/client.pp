# == Class: netbackup::client
#
class netbackup::client(
  $bp_config_path     = '/usr/openv/netbackup/bp.conf',
  $bp_config_owner    = 'root',
  $bp_config_group    = 'bin',
  $bp_config_mode     = '0644',
  $client_name        = $::hostname,
  $client_packages    = undef,
  $init_script_path   = undef,
  $init_script_owner  = 'root',
  $init_script_group  = 'root',
  $init_script_mode   = '0755',
  $init_script_source = '/usr/openv/netbackup/bin/goodies/netbackup',
  $nb_lib_new_file    = '/usr/openv/lib/libnbbaseST.so_new',
  $nb_lib_path        = '/usr/openv/lib',
  $nb_bin_new_file    = '/usr/openv/netbackup/bin/bpcd_new',
  $nb_bin_path        = '/usr/openv/netbackup/lib',
  $server             = "netbackup.${::domain}",
) {

  case $::osfamily {
    'RedHat': {
      case $::lsbmajdistrelease {
        '5': {
          $default_client_packages = ['SYMCnbclt',
                              'SYMCnbjava',
                              'SYMCnbjre',
                              'SYMCpddea',
                              'VRTSpbx',
                              'nbtar']
          $default_init_script_path = '/etc/init.d/netbackup'
        }
        '6': {
          $default_client_packages = ['SYMCnbclt',
                              'SYMCnbjava',
                              'SYMCnbjre',
                              'SYMCpddea',
                              'VRTSpbx',
                              'nbtar']
          $default_init_script_path = '/etc/init.d/netbackup'
        }
        default: {
          fail("netbackup::client is supported on RedHat lsbmajdistrelease 5 and 6. Your lsbmajdistrelease is identified as ${::lsbmajdistrelease}")
        }
      }
    }
    'Suse': {
      case $::lsbmajdistrelease {
        '11': {
          $default_client_packages = ['SYMCnbclt',
                              'SYMCnbjava',
                              'SYMCnbjre',
                              'SYMCpddea',
                              'VRTSpbx',
                              'nbtar']
          $default_init_script_path = '/etc/init.d/netbackup'
        }
        default: {
          fail("netbackup::client is supported on Suse with lsbmajdistrelease 11. Your lsbmajdistrelease is identified as ${::lsbmajdistrelease}")
        }
      }
    }
    default: {
      fail("netbackup::client is supported on osfamily RedHat and SuSE. Your osfamily is identified as ${::osfamily}")
    }
  }

  if $client_packages == undef {
    $my_client_packages = $default_client_packages
  } else {
    $my_client_packages = $client_packages
  }

  if $init_script_path == undef {
    $my_init_script_path = $default_init_script_path
  } else {
    $my_init_script_path = $init_script_path
  }

  package { 'nb_client':
    ensure => 'installed',
    name   => $my_client_packages,
  }

  file { 'bp_config':
    ensure  => 'present',
    path    => $bp_config_path,
    owner   => $bp_config_owner,
    group   => $bp_config_group,
    mode    => $bp_config_mode,
    content => template('netbackup/bp.conf.erb'),
    require => Package['nb_client'],
  }

  file { 'init_script':
    ensure  => 'present',
    path    => $my_init_script_path,
    owner   => $init_script_owner,
    group   => $init_script_group,
    mode    => $init_script_mode,
    source  => $init_script_source,
    require => Package['nb_client'],
  }

  exec { 'fix_nb_libs':
    path     => '/bin:/usr/bin',
    cwd      => $nb_lib_path,
    provider => 'shell',
    command  => "for i in $(find . -type f -name \*_new | awk -F _new '{print \$1}'); do mv \${i}_new \$i; done",
    onlyif   => "test -f ${nb_lib_new_file}",
    require  => Package['nb_client'],
  }

  exec { 'fix_nb_bin':
    path     => '/bin:/usr/bin',
    cwd      => $nb_bin_path,
    provider => 'shell',
    command  => "for i in $(find . -type f -name \*_new | awk -F _new '{print \$1}'); do mv \${i}_new \$i; done",
    onlyif   => "test -f ${nb_bin_new_file}",
    require  => Package['nb_client'],
  }

  service { 'netbackup':
    ensure    => 'running',
    enable    => true,
    hasstatus => false,
    pattern   => 'vnetd',
    subscribe => File['bp_config'],
    require   => [File['init_script'],
                  Exec['fix_nb_libs'],
                  Exec['fix_nb_bin']],
  }

}
