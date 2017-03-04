apt_update 'update'

include_recipe 'nrpe::default'

nrpe_check 'check_root_disk_space' do
  command_name 'check_root_disk_space'
  command "#{node['nrpe']['plugin_dir']}/check_disk"
  warning_condition '5%'
  critical_condition '1%'
  parameters '-p /'
  action :add
end
