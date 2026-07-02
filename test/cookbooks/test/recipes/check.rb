# frozen_string_literal: true

apt_update 'update' if platform_family?('debian')

nrpe 'default' do
  action %i(install configure)
end

nrpe_check 'check_root_disk_space' do
  command '/usr/lib/nagios/plugins/check_disk'
  warning_condition '5%'
  critical_condition '1%'
  parameters '-p /'
end

nrpe 'default' do
  action :start
end
