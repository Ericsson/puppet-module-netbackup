puppet-module-netbackup
=======================

Puppet module to manage NetBackup

===

# Compatibility

netbackup::client is supported and tested on the following systems with Puppet v3.

 * EL 5
 * EL 6
 * Suse 11

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
name of client packages to install

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

