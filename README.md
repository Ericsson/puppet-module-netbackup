puppet-module-netbackup
=======================

[![Build Status](
https://api.travis-ci.org/Ericsson/puppet-module-netbackup.png?branch=master)](https://travis-ci.org/Ericsson/puppet-module-netbackup)

Puppet module to manage NetBackup

===

# Compatibility

This module has been tested to work on the following systems with the latest
Puppet v3, v3 with future parser, v4, v5 and v6. See `.travis.yml` for the
exact matrix of supported Puppet and ruby versions.

 * EL 5
 * EL 6
 * EL 7
 * Suse 11
 * Solaris 9,10 and 11
 * Ubuntu 12.04
 * Ubuntu 14.04

Client packages can be extracted from a NetBackup Master server
with script found here: https://github.com/Ericsson/package-netbackup

===

# Parameters netbackup::client

bp_config_path
--------------
path to bp.conf file

- *Default*: /usr/openv/netbackup/bp.conf

bp_config_owner
---------------
bp.conf's owner

- *Default*: root

bp_config_group
---------------
bp.conf's group

- *Default*: root

bp_config_mode
--------------
bp.conf's mode

- *Default*: 0644

client_name
-----------
client name in bp.conf. Used as index on Master server

- *Default*: $::hostname

client_packages
---------------
name of client packages to install. Not applicable on osfamily Solaris.

- *Default*: undef (OS default)

init_script_path
----------------
init script path

- *Default*: undef (OS default)

init_script_owner
-----------------
init script owner

- *Default*: root

init_script_group
-----------------
init script group

- *Default*: root

init_script_mode
----------------
init script mode

- *Default*: 0755

init_script_source
------------------
init script source

- *Default*: /usr/openv/netbackup/bin/goodies/netbackup

media_server (array)
------------
Array of hostname(s) of NetBackup Media Servers. Support for strings is provided for backward compatibility and migration only and will be deprecated soon.

- *Default*: []

do_not_reset_file_access_time (bool)
------------
Boolean to chose if netbackup should change the access time on backuped files. The bool is translated to YES or NO in the conf file.

- *Default*: false

use_ctime_for_incrementals (bool)
------------
Boolean to chose if netbackup should change the change time on backuped files. The bool is translated to YES or NO in the conf file.

- *Default*: false

nb_lib_path
-----------
path where netbackup libs are stored

- *Default*: /usr/openv/lib

nb_lib_new_file
---------------
file to look for when enabling netbackup libs

- *Default*: /usr/openv/lib/libnbbaseST.so_new

nb_bin_path
-----------
path where netbackup binaries are stored

- *Default*: /usr/openv/netbackup/bin

nb_bin_new_file
---------------
file to look for when enabling netbackup binaries

- *Default*: /usr/openv/netbackup/bin/bpcd_new

server
------
netbackup server to connect to

- *Default*: "netbackup.${::domain}"

symcnbclt_package_source
------------------------
*Solaris only.* Full path to SYMCnbclt package

- *Default*: /var/tmp/nbclient/SYMCnbclt.pkg

symcnbclt_package_adminfile
---------------------------
*Solaris only.* Full path to SYMCnbclt admin file

- *Default*: /var/tmp/nbclient/admin

symcnbjava_package_source
-------------------------
*Solaris only.* Full path to SYMCnbjava package

- *Default*: /var/tmp/nbclient/SYMCnbjava.pkg

symcnbjava_package_adminfile
----------------------------
*Solaris only.* Full path to SYMCnbjava admin file

- *Default*: /var/tmp/nbclient/admin

symcnbjre_package_source
------------------------
*Solaris only.* Full path to SYMCnbjre package

- *Default*: /var/tmp/nbclient/SYMCnbjre.pkg

symcnbjre_package_adminfile
---------------------------
*Solaris only.* Full path to SYMCnbjre admin file

- *Default*: /var/tmp/nbclient/admin

symcpddea_package_source
------------------------
*Solaris only.* Full path to SYMCpddea package

- *Default*: /var/tmp/nbclient/SYMCpddea.pkg

symcpddea_package_adminfile
---------------------------
*Solaris only.* Full path to SYMCpddea admin file

- *Default*: /var/tmp/nbclient/admin

vrtspbx_package_source
----------------------
*Solaris only.* Full path to directory containing VRTSpbx package

- *Default*: /var/tmp/nbclient/VRTSpbx

vrtspbx_package_adminfile
-------------------------
*Solaris only.* Full path to VRTSpbx admin file

- *Default*: /var/tmp/nbclient/admin

nbtar_package_source
--------------------
*Solaris only.* Full path to nbtar package

- *Default*: /var/tmp/nbclient/nbtar.pkg

nbtar_package_adminfile
-----------------------
*Solaris only.* Full path to nbtar admin file

- *Default*: /var/tmp/nbclient/admin

