# == Class: netbackup::client
#
class netbackup::client(
  $bp_config_path   = '/usr/openv/netbackup/bp.conf',
  $client_name      = $::hostname,
  $client_packages  = undef,
  $connect_options  = 'localhost 1 0 2',
  $init_script_path = undef,
  $server           = "netbackup.${::domain}",
) {

  case $::osfamily {
    'RedHat','Suse': {
      $default_client_packages = ['SYMCnbclt',
                          'SYMCnbjava',
                          'SYMCnbjre',
                          'SYMCpddea',
                          'VRTSpbx']
      $default_init_script_path = '/etc/init.d/netbackup'
    }
    default: {
      fail("Module ${module_name} is supported on osfamily RedHat and SuSE. Your osfamily is identified as ${::osfamily}")
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
    mode    => '0644',
    owner   => 'root',
    group   => 'bin',
    content => template('netbackup/bp.conf.erb'),
    require => Package['nb_client'],
  }

  file { 'init_script':
    ensure  => 'present',
    path    => $my_init_script_path,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    source  => '/usr/openv/netbackup/bin/goodies/netbackup',
    require => Package['nb_client'],
  }

  exec { 'fix_nb_libs':
    path    => ['/bin','/usr/bin'],
    cwd     => '/usr/openv/lib',
    command => 'rename _new "" *_new',
    onlyif  => 'test -f /usr/openv/lib/libnbbaseST.so_new',
    require => Package['nb_client'],
  }

  exec { 'fix_nb_bin':
    path    => ['/bin','/usr/bin'],
    cwd     => '/usr/openv/netbackup/bin',
    command => 'rename _new "" *_new',
    onlyif  => 'test -f /usr/openv/netbackup/bin/bpcd_new',
    require => Package['nb_client'],
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
