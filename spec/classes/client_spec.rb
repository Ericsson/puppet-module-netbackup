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

      it do
        should contain_package('nb_client').with({
          'ensure' => 'installed',
          'name'   => ['SYMCnbclt', 'SYMCnbjava', 'SYMCnbjre', 'SYMCpddea', 'VRTSpbx', 'nbtar'],
        })
      end
    end

    context 'with class defaults on osfamily redhat with lsbmajdistrelease 6' do
      let :facts do
        {
          :osfamily          => 'RedHat',
          :lsbmajdistrelease => '6',
        }
      end

      it do
        should contain_package('nb_client').with({
          'ensure' => 'installed',
          'name'   => ['SYMCnbclt', 'SYMCnbjava', 'SYMCnbjre', 'SYMCpddea', 'VRTSpbx', 'nbtar'],
        })
      end
    end

    context 'with class defaults on osfamily suse with lsbmajdistrelease 11' do
      let :facts do
        {
          :osfamily          => 'Suse',
          :lsbmajdistrelease => '11',
        }
      end

      it do
        should contain_package('nb_client').with({
          'ensure' => 'installed',
          'name'   => ['SYMCnbclt', 'SYMCnbjava', 'SYMCnbjre', 'SYMCpddea', 'VRTSpbx', 'nbtar'],
        })
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
        should contain_package('nb_client').with({
          'ensure' => 'installed',
          'name'   => 'NetBackup',
        })
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
