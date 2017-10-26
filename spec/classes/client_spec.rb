require 'spec_helper'
describe 'netbackup::client' do
  platform_matrix = {
    'Ubuntu1204-x86_64' =>
      {
        :osfamily          => 'Debian',
        :lsbmajdistrelease => '12',
        :architecture      => 'x86_64',
        :client_packages   => [ 'symcnbclt', 'symcnbjava', 'symcnbjre', 'symcpddea', 'vrtspbx', 'nbtar', ],
      },
    'Ubuntu1404-x86_64' =>
      {
        :osfamily          => 'Debian',
        :lsbmajdistrelease => '14',
        :architecture      => 'x86_64',
        :client_packages   => [ 'symcnbclt', 'symcnbjava', 'symcnbjre', 'symcpddea', 'vrtspbx', 'nbtar', ],
      },
    'RedHat5-x86_64' =>
      {
        :osfamily          => 'RedHat',
        :lsbmajdistrelease => '5',
        :architecture      => 'x86_64',
        :client_packages   => [ 'SYMCnbclt', 'SYMCnbjava', 'SYMCnbjre', 'SYMCpddea', 'VRTSpbx', 'nbtar', ],
      },
    'RedHat6-x86_64' =>
      {
        :osfamily          => 'RedHat',
        :lsbmajdistrelease => '6',
        :architecture      => 'x86_64',
        :client_packages   => [ 'SYMCnbclt', 'SYMCnbjava', 'SYMCnbjre', 'SYMCpddea', 'VRTSpbx', 'nbtar', ],
      },
    'RedHat7-x86_64' =>
      {
        :osfamily          => 'RedHat',
        :lsbmajdistrelease => '7',
        :architecture      => 'x86_64',
        :client_packages   => [ 'SYMCnbclt', 'SYMCnbjava', 'SYMCnbjre', 'SYMCpddea', 'VRTSpbx', ],
      },
    'Solaris10-i386' =>
      {
        :osfamily          => 'Solaris',
        :kernelrelease     => '5.10',
        :hardwareisa       => 'i386',
        :client_packages   => [ 'SYMCnbclt', 'SYMCnbjava', 'SYMCnbjre', 'VRTSpbx', 'nbtar', ],
      },
    'Solaris9-sparc' =>
      {
        :osfamily          => 'Solaris',
        :kernelrelease     => '5.9',
        :hardwareisa       => 'sparc',
        :client_packages   => [ 'SYMCnbclt', 'SYMCnbjava', 'SYMCnbjre', 'SYMCpddea', 'VRTSpbx', 'nbtar', ],
      },
    'Solaris10-sparc' =>
      {
        :osfamily          => 'Solaris',
        :kernelrelease     => '5.10',
        :hardwareisa       => 'sparc',
        :client_packages   => [ 'SYMCnbclt', 'SYMCnbjava', 'SYMCnbjre', 'SYMCpddea', 'VRTSpbx', 'nbtar', ],
      },
    'Solaris11-sparc' =>
      {
        :osfamily          => 'Solaris',
        :kernelrelease     => '5.11',
        :hardwareisa       => 'sparc',
        :client_packages   => [ 'SYMCnbclt', 'SYMCnbjava', 'SYMCnbjre', 'SYMCpddea', 'VRTSpbx', 'nbtar', ],
      },
    'Suse11-x86_64' =>
      {
        :osfamily          => 'Suse',
        :lsbmajdistrelease => '11',
        :architecture      => 'x86_64',
        :client_packages   => [ 'SYMCnbclt', 'SYMCnbjava', 'SYMCnbjre', 'SYMCpddea', 'VRTSpbx', 'nbtar', ],
      },
  }

  describe 'with class defaults' do
    platform_matrix.sort.each do |k,v|
      context "running on #{v[:osfamily]} #{v[:lsbmajdistrelease]}#{v[:kernelrelease]} (#{v[:architecture]}#{v[:hardwareisa]})" do
        let :facts do
          {
            :osfamily          => v[:osfamily],
            :lsbmajdistrelease => v[:lsbmajdistrelease],
            :architecture      => v[:architecture],
            :kernelrelease     => v[:kernelrelease],
            :hardwareisa       => v[:hardwareisa],
            :domain            => 'example.com',
            :hostname          => 'host',
          }
        end

        it { should compile.with_all_deps }

        # build package array for osfamily depended required packages, Solaris get special treatment
        if v[:osfamily] == 'Solaris'
          required_packages_array = 'Package[SYMCnbclt]'
        else
          required_packages_array = Array.new
          v[:client_packages].each do |package|
            required_packages_array.push('Package['+package+']')
          end
        end

        # testing Packages
        v[:client_packages].each do |package|
          if v[:osfamily] == 'Solaris'
            # Solaris specific part
            if package == 'SYMCnbclt'
              # SYMCnbclt requires VRTSpbx
              it do
                should contain_package(package).with({
                  'ensure'    => 'installed',
                  'provider'  => 'sun',
                  'source'    => "/var/tmp/nbclient/#{package}.pkg",
                  'adminfile' => '/var/tmp/nbclient/admin',
                  'require'   => 'Package[VRTSpbx]',
                })
              end
            else
              it do
                should contain_package(package).with({
                  'ensure'    => 'installed',
                  'provider'  => 'sun',
                  'source'    => "/var/tmp/nbclient/#{package}.pkg",
                  'adminfile' => '/var/tmp/nbclient/admin',
                })
              end
            end
          else
            # Linux specific part
            it do
              should contain_package(package).with({
                'ensure' => 'installed',
              })
            end
          end
        end

        # runlevel links (Solaris only) and service
        if v[:osfamily] == 'Solaris'
          it do
            should contain_file('/etc/rc2.d/S77netbackup').with({
              'ensure'  => 'link',
              'target'  => '/etc/init.d/netbackup',
              'require' => 'File[init_script]',
            })
          end

          it do
            should contain_file('/etc/rc0.d/K01netbackup').with({
              'ensure'  => 'link',
              'target'  => '/etc/init.d/netbackup',
              'require' => 'File[init_script]',
            })
          end

          it do
            should contain_file('/etc/rc1.d/K01netbackup').with({
              'ensure'  => 'link',
              'target'  => '/etc/init.d/netbackup',
              'require' => 'File[init_script]',
            })
          end
          # Solaris needs provider parameter to be set to 'init'
          it do
            should contain_service('netbackup').with({
              'ensure'    => 'running',
              'enable'    => true,
              'hasstatus' => false,
              'pattern'   => 'vnetd',
              'subscribe' => 'File[bp_config]',
              'require'   => [
                               'File[init_script]',
                               'Exec[fix_nb_libs]',
                               'Exec[fix_nb_bin]',
                             ],
              'provider'   => 'init',
            })
          end
        else
          it do
            should contain_service('netbackup').with({
              'ensure'    => 'running',
              'enable'    => true,
              'hasstatus' => false,
              'pattern'   => 'vnetd',
              'subscribe' => 'File[bp_config]',
              'require'   => [
                               'File[init_script]',
                               'Exec[fix_nb_libs]',
                               'Exec[fix_nb_bin]',
                             ],
            })
          end
        end

        it do
          should contain_file('bp_config').with({
            'ensure'  => 'file',
            'path'    => '/usr/openv/netbackup/bp.conf',
            'owner'   => 'root',
            'group'   => 'bin',
            'mode'    => '0644',
            'require' => required_packages_array,
          })
        end
        it { should contain_file('bp_config').with_content(/^SERVER = netbackup.example.com$/) }
        it { should contain_file('bp_config').with_content(/^CLIENT_NAME = host$/) }
        it { should contain_file('bp_config').without_content(%r{^DO_NOT_RESET_FILE_ACCESS_TIME.*$}) }
        it { should contain_file('bp_config').without_content(%r{^USE_CTIME_FOR_INCREMENTALS.*$}) }

        it do
          should contain_file('init_script').with({
            'ensure'  => 'file',
            'path'    => '/etc/init.d/netbackup',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0755',
            'source'  => '/usr/openv/netbackup/bin/goodies/netbackup',
            'require' => required_packages_array,
          })
        end

        it do
          should contain_exec('fix_nb_libs').with({
            'path'     => '/bin:/usr/bin',
            'cwd'      => '/usr/openv/lib',
            'provider' => 'shell',
            'command'  => "for i in `find . -type f -name \\*_new | awk -F_new '{print \$1}'`; do mv \${i}_new \$i; done",
            'onlyif'   => 'test -f /usr/openv/lib/libnbbaseST.so_new',
            'require'  => required_packages_array,
          })
        end

        it do
          should contain_exec('fix_nb_bin').with({
            'path'     => '/bin:/usr/bin',
            'cwd'      => '/usr/openv/netbackup/bin',
            'provider' => 'shell',
            'command'  => "for i in `find . -type f -name \\*_new | awk -F_new '{print \$1}'`; do mv \${i}_new \$i; done",
            'onlyif'   => 'test -f /usr/openv/netbackup/bin/bpcd_new',
            'require'  => required_packages_array,
          })
        end

      end
    end
  end

  describe 'with osfamily dependend parameters specified' do
    platform_matrix.select{ |key,val| key.start_with? 'Solaris' }.sort.each do |k,v|
      describe 'where package_source and package_adminfile are set to valid values (Solaris specific)' do
        context "running on #{v[:osfamily]} #{v[:kernelrelease]} (#{v[:hardwareisa]})" do
          let :facts do
            {
              :osfamily          => v[:osfamily],
              :kernelrelease     => v[:kernelrelease],
              :hardwareisa       => v[:hardwareisa],
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
              :symcpddea_package_source     => '/var/tmp/SYMCpddea.pkg',
              :symcpddea_package_adminfile  => '/var/tmp/admin',
              :vrtspbx_package_source       => '/var/tmp/VRTSpbx.pkg',
              :vrtspbx_package_adminfile    => '/var/tmp/admin',
              :nbtar_package_source         => '/var/tmp/nbtar.pkg',
              :nbtar_package_adminfile      => '/var/tmp/admin',
            }
          end

          v[:client_packages].each do |package|
            it do
              should contain_package(package).with({
                'ensure'    => 'installed',
                'source'    => "/var/tmp/#{package}.pkg",
                'adminfile' => '/var/tmp/admin',
              })
            end
          end

        end
      end
    end

    ['symcnbclt','symcnbjava','symcnbjre','symcpddea','vrtspbx','nbtar'].each do |value|
      let :facts do
        {
          :osfamily          => 'Solaris',
          :kernelrelease     => '5.10',
          :hardwareisa       => 'sparc',
        }
      end

      context "where #{value}_package_source is set to an invalid value running on Solaris 5.10" do
        let :params do
          {
            value+'_package_source'    => 'nether/ether/a/valid/path',
          }
        end
        it 'should fail' do
          expect {
            should contain_class('netbackup::client')
          }.to raise_error(Puppet::Error)
        end
      end

      context "where #{value}_package_adminfile is set to an invalid value running on Solaris 5.10" do
        let :params do
          {
            value+'_package_adminfile' => 'either/not/a/valid/path',
          }
        end
        it 'should fail' do
          expect {
            should contain_class('netbackup::client')
          }.to raise_error(Puppet::Error)
        end
      end
    end
  end

  describe 'with osfamily independend parameters specified' do
    let :facts do
      {
        :osfamily          => 'RedHat',
        :lsbmajdistrelease => '6',
        :architecture      => 'x86_64',
      }
    end

    context 'where bp_config_path/_owner/_group/_mode are set to valid values' do
      let :params do
        {
          :bp_config_path  => '/tmp/bp.conf',
          :bp_config_owner => 'special_owner',
          :bp_config_group => 'special_group',
          :bp_config_mode  => '0242',
        }
      end

      it do
        should contain_file('bp_config').with({
          'path'  => '/tmp/bp.conf',
          'owner' => 'special_owner',
          'group' => 'special_group',
          'mode'  => '0242',
        })
      end
    end

    context 'where init_script_path/_owner/_group/_mode/_source are set to valid values' do
      let :params do
        {
          :init_script_path   => '/etc/init.d/special_netbackup',
          :init_script_owner  => 'special_owner',
          :init_script_group  => 'special_group',
          :init_script_mode   => '0042',
          :init_script_source => '/some/other/path/to/netbackup',
        }
      end

      it do
        should contain_file('init_script').with({
          'path'   => '/etc/init.d/special_netbackup',
          'owner'  => 'special_owner',
          'group'  => 'special_group',
          'mode'   => '0042',
          'source' => '/some/other/path/to/netbackup',
        })
      end
    end

    context 'where client_packages is set to a valid value' do
      let :params do
        {
          :client_packages => [ 'for', 'newpackages', ],
        }
      end

      it do
        should contain_package('for').with({
          'ensure'    => 'installed',
        })
      end
      it do
        should contain_package('newpackages').with({
          'ensure'    => 'installed',
        })
      end

      it do
        should contain_file('bp_config').with({
          'require' => [ 'Package[for]', 'Package[newpackages]' ],
        })
      end

      it do
        should contain_file('init_script').with({
          'require' => [ 'Package[for]', 'Package[newpackages]' ],
        })
      end

      it do
        should contain_exec('fix_nb_libs').with({
          'require' => [ 'Package[for]', 'Package[newpackages]' ],
        })
      end

      it do
        should contain_exec('fix_nb_bin').with({
          'require' => [ 'Package[for]', 'Package[newpackages]' ],
        })
      end
    end

    context 'where client_name is set to a valid value' do
      let :params do
        {
          :client_name => 'me_different',
        }
      end

      it { should contain_file('bp_config').with_content(/^CLIENT_NAME = me_different$/) }
    end

    context 'where server is set to a valid value' do
      let :params do
        {
          :server => 'me_too',
        }
      end

      it {
        should contain_file('bp_config').with_content(/^SERVER = me_too$/)
        should contain_file('bp_config').without_content(/^MEDIA_SERVER\s*=/)
      }
    end

    context 'where media_server is set to a valid array' do
      let :params do
        {
          :media_server => [ 'my_media_server_1', 'my_media_server_2' ],
        }
      end

      it { should contain_file('bp_config').with_content(/^MEDIA_SERVER = my_media_server_1\nMEDIA_SERVER = my_media_server_2$/) }
    end

    context 'where media_server is set to a valid string' do
      let :params do
        {
          :media_server => 'my_media_server',
        }
      end

      it { should contain_file('bp_config').with_content(/^MEDIA_SERVER = my_media_server$/) }
    end

    context 'where nb_lib_new_file and nb_lib_path are set to valid values' do
      let :params do
        {
          :nb_lib_new_file => '/test/libnbbaseST.so_new',
          :nb_lib_path => '/path',
        }
      end

      it do
        should contain_exec('fix_nb_libs').with({
          'cwd' => '/path',
          'onlyif' => 'test -f /test/libnbbaseST.so_new',
        })
      end
    end

    context 'where nb_bin_new_file and nb_bin_path are set to valid values' do
      let :params do
        {
          :nb_bin_new_file => '/usr/openv/netbackup/bin/bpcd_not_so_new',
          :nb_bin_path     => '/path',
        }
      end

      it do
        should contain_exec('fix_nb_bin').with({
          'cwd'    => '/path',
          'onlyif' => 'test -f /usr/openv/netbackup/bin/bpcd_not_so_new',
        })
      end
    end

    context 'where do_not_reset_file_access_time are set to invalid values' do
      let :params do
        {
          :do_not_reset_file_access_time => 'foo',
        }
      end
      it 'should fail' do
        expect {
          should contain_class('netbackup::client')
          }.to raise_error(Puppet::Error)
      end
    end
    context 'where use_ctime_for_incrementals are set to invalid values' do
      let :params do
        {
          :use_ctime_for_incrementals => 'bar',
        }
      end
      it 'should fail' do
        expect {
          should contain_class('netbackup::client')
          }.to raise_error(Puppet::Error)
      end
    end
    context 'when do_not_reset_file_access_time set to valid true' do
      let(:params) { { :do_not_reset_file_access_time => true } }
      it { should contain_file('bp_config').with_content(%r{^DO_NOT_RESET_FILE_ACCESS_TIME = YES$}) }
    end
    context 'when use_ctime_for_incrementals set to valid true' do
      let(:params) { { :use_ctime_for_incrementals => true } }
      it { should contain_file('bp_config').with_content(%r{^USE_CTIME_FOR_INCREMENTALS = YES$}) }
    end
  end
end
