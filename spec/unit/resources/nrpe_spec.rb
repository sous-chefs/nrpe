# frozen_string_literal: true

require 'spec_helper'

describe 'nrpe' do
  step_into :nrpe

  context 'on Ubuntu 24.04 with defaults' do
    platform 'ubuntu', '24.04'

    recipe do
      nrpe 'default'
    end

    it { is_expected.to install_package('nagios-nrpe-server') }
    it { is_expected.to install_package('nagios-plugins') }
    it { is_expected.to install_package('nagios-plugins-basic') }
    it { is_expected.to install_package('nagios-plugins-standard') }
    it { is_expected.to create_directory('/etc/nagios/nrpe.d').with(group: 'nagios', mode: '0750') }
    it { is_expected.to create_template('/etc/nagios/nrpe.cfg').with(group: 'nagios') }
    it { is_expected.to enable_service('nagios-nrpe-server') }
    it { is_expected.to start_service('nagios-nrpe-server') }

    it 'renders the default nrpe config' do
      expect(chef_run).to render_file('/etc/nagios/nrpe.cfg').with_content('nrpe_user=nagios')
      expect(chef_run).to render_file('/etc/nagios/nrpe.cfg').with_content('nrpe_group=nagios')
      expect(chef_run).to render_file('/etc/nagios/nrpe.cfg').with_content('allowed_hosts=127.0.0.1,::1')
      expect(chef_run).to render_file('/etc/nagios/nrpe.cfg').with_content('command_timeout=60')
      expect(chef_run).to render_file('/etc/nagios/nrpe.cfg').with_content('server_port=5666')
    end
  end

  context 'on Ubuntu 24.04 with custom properties' do
    platform 'ubuntu', '24.04'

    recipe do
      nrpe 'default' do
        allow_bash_command_substitution 0
        allowed_hosts %w(10.0.0.10 10.0.0.11)
        connection_timeout 20
        package_options '--no-install-recommends'
      end
    end

    it { is_expected.to install_package('nagios-nrpe-server').with(options: ['--no-install-recommends']) }

    it 'renders property-driven config' do
      expect(chef_run).to render_file('/etc/nagios/nrpe.cfg').with_content('allow_bash_command_substitution=0')
      expect(chef_run).to render_file('/etc/nagios/nrpe.cfg').with_content('connection_timeout=20')
      expect(chef_run).to render_file('/etc/nagios/nrpe.cfg').with_content('allowed_hosts=10.0.0.10,10.0.0.11,127.0.0.1,::1')
    end
  end

  context 'on AlmaLinux 9 with package install' do
    platform 'almalinux', '9'

    recipe do
      nrpe 'default'
    end

    it { is_expected.to install_package('epel-release') }
    it { is_expected.to install_package('nrpe') }
    it { is_expected.to install_package('nagios-plugins-disk') }
    it { is_expected.to install_package('nagios-plugins-load') }
    it { is_expected.to install_package('nagios-plugins-procs') }
    it { is_expected.to install_package('nagios-plugins-users') }
    it { is_expected.to start_service('nrpe') }
  end

  context 'with source install' do
    platform 'ubuntu', '24.04'

    before do
      stub_command('/usr/sbin/nrpe --version | grep 4.1.3').and_return(false)
    end

    recipe do
      nrpe 'default' do
        install_method 'source'
      end
    end

    it { is_expected.to install_build_essential('nrpe') }
    it { is_expected.to install_package('libssl-dev') }
    it { is_expected.to create_group('nagios') }
    it { is_expected.to create_user('nagios').with(system: true, group: 'nagios') }
    it { is_expected.to run_bash('compile-nagios-nrpe') }
    it { is_expected.to run_bash('compile-monitoring-plugins') }
  end

  context 'with action :remove' do
    platform 'ubuntu', '24.04'

    recipe do
      nrpe 'default' do
        action :remove
      end
    end

    it { is_expected.to stop_service('nagios-nrpe-server') }
    it { is_expected.to disable_service('nagios-nrpe-server') }
    it { is_expected.to delete_file('/etc/nagios/nrpe.cfg') }
    it { is_expected.to delete_directory('/etc/nagios/nrpe.d') }
    it { is_expected.to remove_package(%w(nagios-nrpe-server nagios-plugins nagios-plugins-basic nagios-plugins-standard)) }
  end
end
