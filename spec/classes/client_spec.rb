require 'spec_helper'
describe 'netbackup::client' do

  describe 'packages' do

    context 'with class defaults on osfamily redhat with lsbmajdistrelease 5' do
      let :facts do
        {
          :osfamily          => 'RedHat',
          :lsbmajdistrelease => '5',
        }
      end

      ['SYMCnbclt', 'SYMCnbjava', 'SYMCnbjre', 'SYMCpddea', 'VRTSpbx', 'nbtar'].each do |package|
        it do
          should contain_package(package).with({
            'ensure' => 'installed',
          })
        end
      end
    end

    context 'with class defaults on osfamily redhat with lsbmajdistrelease 6' do
      let :facts do
        {
          :osfamily          => 'RedHat',
          :lsbmajdistrelease => '6',
        }
      end

      ['SYMCnbclt', 'SYMCnbjava', 'SYMCnbjre', 'SYMCpddea', 'VRTSpbx', 'nbtar'].each do |package|
        it do
          should contain_package(package).with({
            'ensure' => 'installed',
          })
        end
      end
    end

    context 'with class defaults on osfamily suse with lsbmajdistrelease 11' do
      let :facts do
        {
          :osfamily          => 'Suse',
          :lsbmajdistrelease => '11',
        }
      end

      ['SYMCnbclt', 'SYMCnbjava', 'SYMCnbjre', 'SYMCpddea', 'VRTSpbx', 'nbtar'].each do |package|
        it do
          should contain_package(package).with({
            'ensure' => 'installed',
          })
        end
      end
    end

    context 'with class defaults on osfamily solaris with kernelrelease 5.10 and hardwareisa i386' do
      let :facts do
        {
          :osfamily      => 'Solaris',
          :kernelrelease => '5.10',
          :hardwareisa   => 'i386',
        }
      end

      it do
        should contain_package('SYMCnbclt').with({'ensure' => 'installed', 'source' => '/var/tmp/nbclient/SYMCnbclt.pkg', 'adminfile' => '/var/tmp/nbclient/admin' })
        should contain_package('SYMCnbjava').with({'ensure' => 'installed', 'source' => '/var/tmp/nbclient/SYMCnbjava.pkg', 'adminfile' => '/var/tmp/nbclient/admin'})
        should contain_package('SYMCnbjre').with({'ensure' => 'installed', 'source' => '/var/tmp/nbclient/SYMCnbjre.pkg', 'adminfile' => '/var/tmp/nbclient/admin'})
        should contain_package('VRTSpbx').with({'ensure' => 'installed', 'source' => '/var/tmp/nbclient/VRTSpbx', 'adminfile' => '/var/tmp/nbclient/admin'})
        should contain_package('nbtar').with({'ensure' => 'installed', 'source' => '/var/tmp/nbclient/nbtar.pkg', 'adminfile' => '/var/tmp/nbclient/admin'})
      end

    end

    context 'with class defaults on osfamily solaris with kernelrelease 5.10 and hardwareisa sparc' do
      let :facts do
        {
          :osfamily      => 'Solaris',
          :kernelrelease => '5.10',
          :hardwareisa   => 'sparc',
        }
      end

      it do
        should contain_package('SYMCnbclt').with({'ensure' => 'installed', 'source' => '/var/tmp/nbclient/SYMCnbclt.pkg', 'adminfile' => '/var/tmp/nbclient/admin' })
        should contain_package('SYMCnbjava').with({'ensure' => 'installed', 'source' => '/var/tmp/nbclient/SYMCnbjava.pkg', 'adminfile' => '/var/tmp/nbclient/admin'})
        should contain_package('SYMCnbjre').with({'ensure' => 'installed', 'source' => '/var/tmp/nbclient/SYMCnbjre.pkg', 'adminfile' => '/var/tmp/nbclient/admin'})
        should contain_package('SYMCpddea').with({'ensure' => 'installed', 'source' => '/var/tmp/nbclient/SYMCpddea.pkg', 'adminfile' => '/var/tmp/nbclient/admin'})
        should contain_package('VRTSpbx').with({'ensure' => 'installed', 'source' => '/var/tmp/nbclient/VRTSpbx', 'adminfile' => '/var/tmp/nbclient/admin'})
        should contain_package('nbtar').with({'ensure' => 'installed', 'source' => '/var/tmp/nbclient/nbtar.pkg', 'adminfile' => '/var/tmp/nbclient/admin'})
      end

    end

    context 'with specifying client_packages on valid platform' do
      let :facts do
        {
          :osfamily          => 'RedHat',
          :lsbmajdistrelease => '6',
        }
      end

      let(:params) { {:client_packages => 'NetBackup'} }

      it do
        should contain_package('NetBackup').with({
          'ensure' => 'installed',
        })
      end
    end

    context 'with specifying package_source and package_adminfile on osfamily solaris with kernelrelease 5.10 and hardwareisa i386' do
      let :facts do
        {
          :osfamily      => 'Solaris',
          :kernelrelease => '5.10',
          :hardwareisa   => 'i386',
        }
      end
      let :params do
        {
          :symcnbclt_package_source     => '/var/tmp/SYMCnbclt.pkg',
          :symcnbclt_package_adminfile  => '/var/tmp/admin',
          :symcnbjava_package_source    => '/var/tmp/SYMCnbjava.pkg',
          :symcnbjava_package_adminfile => '/var/tmp/admin',
          :symcnbjre_package_source     => '/var/tmp/SYMCnbjre.pkg',
          :symcnbjre_package_adminfile  => '/var/tmp/admin',
          :vrtspbx_package_source       => '/var/tmp/VRTSpbx',
          :vrtspbx_package_adminfile    => '/var/tmp/admin',
          :nbtar_package_source         => '/var/tmp/nbtar.pkg',
          :nbtar_package_adminfile      => '/var/tmp/admin',
        }
      end
      it do
        should contain_package('SYMCnbclt').with({'ensure' => 'installed', 'source' => '/var/tmp/SYMCnbclt.pkg', 'adminfile' => '/var/tmp/admin' })
        should contain_package('SYMCnbjava').with({'ensure' => 'installed', 'source' => '/var/tmp/SYMCnbjava.pkg', 'adminfile' => '/var/tmp/admin'})
        should contain_package('SYMCnbjre').with({'ensure' => 'installed', 'source' => '/var/tmp/SYMCnbjre.pkg', 'adminfile' => '/var/tmp/admin'})
        should contain_package('VRTSpbx').with({'ensure' => 'installed', 'source' => '/var/tmp/VRTSpbx', 'adminfile' => '/var/tmp/admin'})
        should contain_package('nbtar').with({'ensure' => 'installed', 'source' => '/var/tmp/nbtar.pkg', 'adminfile' => '/var/tmp/admin'})
      end
    end

  end

  describe 'config files' do

    context 'defaults on osfamily redhat with lsbmajdistrelease 5' do
      let :facts do
        {
          :osfamily          => 'RedHat',
          :lsbmajdistrelease => '5',
          :domain            => 'example.com',
          :hostname          => 'host',
        }
      end

      it do
        should contain_file('bp_config').with({
          'ensure'  => 'present',
          'path'    => '/usr/openv/netbackup/bp.conf',
          'owner'   => 'root',
          'group'   => 'bin',
          'mode'    => '0644',
        })

        should contain_file('bp_config').with_content(
%{# This file is being maintained by Puppet.
# DO NOT EDIT
SERVER = netbackup.example.com
CLIENT_NAME = host
})
      end
    end

    context 'defaults on osfamily suse with lsbmajdistrelease 11' do
      let :facts do
        {
          :osfamily          => 'Suse',
          :lsbmajdistrelease => '11',
          :domain            => 'example.com',
          :hostname          => 'host',
        }
      end

      it do
        should contain_file('bp_config').with({
          'ensure'  => 'present',
          'path'    => '/usr/openv/netbackup/bp.conf',
          'owner'   => 'root',
          'group'   => 'bin',
          'mode'    => '0644',
        })

        should contain_file('bp_config').with_content(
%{# This file is being maintained by Puppet.
# DO NOT EDIT
SERVER = netbackup.example.com
CLIENT_NAME = host
})
      end
    end

    context 'defaults on osfamily solaris with kernelrelease 5.10' do
      let :facts do
        {
          :osfamily      => 'Solaris',
          :kernelrelease => '5.10',
          :domain        => 'example.com',
          :hostname      => 'host',
        }
      end

      it do
        should contain_file('bp_config').with({
          'ensure'  => 'present',
          'path'    => '/usr/openv/netbackup/bp.conf',
          'owner'   => 'root',
          'group'   => 'bin',
          'mode'    => '0644',
        })

        should contain_file('bp_config').with_content(
%{# This file is being maintained by Puppet.
# DO NOT EDIT
SERVER = netbackup.example.com
CLIENT_NAME = host
})
      end
    end

    context 'with specifying server on osfamily redhat with lsbmajdistrelease 6' do
      let :facts do
        {
          :osfamily          => 'RedHat',
          :lsbmajdistrelease => '6',
          :domain            => 'example.com',
          :hostname          => 'host',
        }
      end
      let :params do
        {
          :server => 'nb.example.com',
        }
      end

      it do
        should contain_file('bp_config').with({
          'ensure'  => 'present',
          'path'    => '/usr/openv/netbackup/bp.conf',
          'owner'   => 'root',
          'group'   => 'bin',
          'mode'    => '0644',
        })

        should contain_file('bp_config').with_content(
%{# This file is being maintained by Puppet.
# DO NOT EDIT
SERVER = nb.example.com
CLIENT_NAME = host
})
      end
    end

    context 'with specifying client_name and server on osfamily redhat with lsbmajdistrelease 6' do
      let :facts do
        {
          :osfamily          => 'RedHat',
          :lsbmajdistrelease => '6',
          :domain            => 'example.com',
          :hostname          => 'host',
        }
      end
      let :params do
        {
          :server      => 'nb.example.com',
          :client_name => 'realhost123',
        }
      end

      it do
        should contain_file('bp_config').with({
          'ensure'  => 'present',
          'path'    => '/usr/openv/netbackup/bp.conf',
          'owner'   => 'root',
          'group'   => 'bin',
          'mode'    => '0644',
        })

        should contain_file('bp_config').with_content(
%{# This file is being maintained by Puppet.
# DO NOT EDIT
SERVER = nb.example.com
CLIENT_NAME = realhost123
})
      end
    end

  end
end
