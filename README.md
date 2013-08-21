puppet-module-netbackup
=======================

Puppet module to manage NetBackup

===

# Parameters netbackup::client

bp_config_path
--------------
path to bp.conf file

- *Default*: /usr/openv/netbackup/bp.conf

client_name
-----------
client name in bp.conf

- *Default*: $::hostname

client_packages
---------------
name of client packages

- *Default*: undef (OS default)

connect_options
---------------
connect options in bp.conf

- *Default*: localhost 1 0 2

init_script_path
----------------
path to NetBackup init script

- *Default*: undef (OS default)

server
------
NetBackup server to connect to

- *Default*: "netbackup.${::domain}"

