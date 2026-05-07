# frozen_string_literal: true

require 'spec_helper'

describe 'nrpe_check' do
  step_into :nrpe_check
  platform 'ubuntu', '24.04'

  context 'with command content' do
    recipe do
      service 'nagios-nrpe-server'

      nrpe_check 'check_root_disk_space' do
        command '/usr/lib/nagios/plugins/check_disk'
        warning_condition '5%'
        critical_condition '1%'
        parameters '-p /'
      end
    end

    it 'creates the check config file' do
      expect(chef_run).to create_file('/etc/nagios/nrpe.d/check_root_disk_space.cfg')
        .with_content("command[check_root_disk_space]=/usr/lib/nagios/plugins/check_disk -w 5% -c 1% -p /\n")
    end
  end

  context 'with a template' do
    recipe do
      service 'nagios-nrpe-server'

      nrpe_check 'check_load' do
        template 'check_load.cfg.erb'
      end
    end

    it { is_expected.to create_template('/etc/nagios/nrpe.d/check_load.cfg') }
  end

  context 'with action :remove' do
    recipe do
      service 'nagios-nrpe-server'

      nrpe_check 'check_load' do
        action :remove
      end
    end

    it { is_expected.to delete_file('/etc/nagios/nrpe.d/check_load.cfg') }
  end
end
