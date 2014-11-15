# == Class: netbackup::client
#
class netbackup::client(
  $bp_config_path               = '/usr/openv/netbackup/bp.conf',
  $bp_config_owner              = 'root',
  $bp_config_group              = 'bin',
  $bp_config_mode               = '0644',
  $client_name                  = $::hostname,
  $client_packages              = undef,
  $init_script_path             = undef,
  $init_script_owner            = 'root',
  $init_script_group            = 'root',
  $init_script_mode             = '0755',
  $init_script_source           = '/usr/openv/netbackup/bin/goodies/netbackup',
  $nb_lib_new_file              = '/usr/openv/lib/libnbbaseST.so_new',
  $nb_lib_path                  = '/usr/openv/lib',
  $nb_bin_new_file              = '/usr/openv/netbackup/bin/bpcd_new',
  $nb_bin_path                  = '/usr/openv/netbackup/bin',
  $server                       = "netbackup.${::domain}",
  $symcnbclt_package_source     = '/var/tmp/nbclient/SYMCnbclt.pkg',
  $symcnbclt_package_adminfile  = '/var/tmp/nbclient/admin',
  $symcnbjava_package_source    = '/var/tmp/nbclient/SYMCnbjava.pkg',
  $symcnbjava_package_adminfile = '/var/tmp/nbclient/admin',
  $symcnbjre_package_source     = '/var/tmp/nbclient/SYMCnbjre.pkg',
  $symcnbjre_package_adminfile  = '/var/tmp/nbclient/admin',
  $symcpddea_package_source     = '/var/tmp/nbclient/SYMCpddea.pkg',
  $symcpddea_package_adminfile  = '/var/tmp/nbclient/admin',
  $vrtspbx_package_source       = '/var/tmp/nbclient/VRTSpbx',
  $vrtspbx_package_adminfile    = '/var/tmp/nbclient/admin',
  $nbtar_package_source         = '/var/tmp/nbclient/nbtar.pkg',
  $nbtar_package_adminfile      = '/var/tmp/nbclient/admin',
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
    'Solaris': {
      case $::kernelrelease {
        '5.10': {
          $default_client_packages = []
          $default_init_script_path = '/etc/init.d/netbackup'
        }
        default: {
          fail("netbackup::client is supported on Solaris with kernelrelease 5.10. Your kernelrelease is identified as ${::kernelrelease}")
        }
      }
    }
    default: {
      fail("netbackup::client is supported on osfamily RedHat, SuSE and Solaris. Your osfamily is identified as ${::osfamily}")
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

  if $::osfamily == 'Solaris' {

    validate_absolute_path($symcnbclt_package_source)
    validate_absolute_path($symcnbclt_package_adminfile)
    validate_absolute_path($symcnbjava_package_source)
    validate_absolute_path($symcnbjava_package_adminfile)
    validate_absolute_path($symcnbjre_package_source)
    validate_absolute_path($symcnbjre_package_adminfile)
    validate_absolute_path($vrtspbx_package_source)
    validate_absolute_path($vrtspbx_package_adminfile)
    validate_absolute_path($nbtar_package_source)
    validate_absolute_path($nbtar_package_adminfile)

    package { 'SYMCnbclt':
      ensure    => 'installed',
      source    => $symcnbclt_package_source,
      adminfile => $symcnbclt_package_adminfile,
      require   => Package['VRTSpbx'],
    }

    package { 'SYMCnbjava':
      ensure    => 'installed',
      source    => $symcnbjava_package_source,
      adminfile => $symcnbjava_package_adminfile,
    }

    package { 'SYMCnbjre':
      ensure    => 'installed',
      source    => $symcnbjre_package_source,
      adminfile => $symcnbjre_package_adminfile,
    }

    package { 'VRTSpbx':
      ensure    => 'installed',
      source    => $vrtspbx_package_source,
      adminfile => $vrtspbx_package_adminfile,
    }

    package { 'nbtar':
      ensure    => 'installed',
      source    => $nbtar_package_source,
      adminfile => $nbtar_package_adminfile,
    }

    if $::hardwareisa == 'sparc' {

      validate_absolute_path($symcpddea_package_source)
      validate_absolute_path($symcpddea_package_adminfile)

      package { 'SYMCpddea':
        ensure    => 'installed',
        source    => $symcpddea_package_source,
        adminfile => $symcpddea_package_adminfile,
      }
    }

    file { '/etc/rc2.d/S77netbackup':
      ensure  => 'link',
      target  => $my_init_script_path,
      require => File['init_script'],
    }

    file { '/etc/rc0.d/K01netbackup':
      ensure  => 'link',
      target  => $my_init_script_path,
      require => File['init_script'],
    }

    file { '/etc/rc1.d/K01netbackup':
      ensure  => 'link',
      target  => $my_init_script_path,
      require => File['init_script'],
    }

    Service['netbackup'] {
      provider => 'init',
    }

  } else {

    package { $my_client_packages:
      ensure => 'installed',
    }
  }

  file { 'bp_config':
    ensure  => 'present',
    path    => $bp_config_path,
    owner   => $bp_config_owner,
    group   => $bp_config_group,
    mode    => $bp_config_mode,
    content => template('netbackup/bp.conf.erb'),
    require => Package[$my_client_packages],
  }

  file { 'init_script':
    ensure  => 'present',
    path    => $my_init_script_path,
    owner   => $init_script_owner,
    group   => $init_script_group,
    mode    => $init_script_mode,
    source  => $init_script_source,
    require => Package[$my_client_packages],
  }

  exec { 'fix_nb_libs':
    path     => '/bin:/usr/bin',
    cwd      => $nb_lib_path,
    provider => 'shell',
    command  => "for i in `find . -type f -name \\*_new | awk -F_new '{print \$1}'`; do mv \${i}_new \$i; done",
    onlyif   => "test -f ${nb_lib_new_file}",
    require  => Package[$my_client_packages],
  }

  exec { 'fix_nb_bin':
    path     => '/bin:/usr/bin',
    cwd      => $nb_bin_path,
    provider => 'shell',
    command  => "for i in `find . -type f -name \\*_new | awk -F_new '{print \$1}'`; do mv \${i}_new \$i; done",
    onlyif   => "test -f ${nb_bin_new_file}",
    require  => Package[$my_client_packages],
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
