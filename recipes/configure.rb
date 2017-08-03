#
# Author:: Joshua Sierles <joshua@37signals.com>
# Author:: Joshua Timberman <joshua@getchef.com>
# Author:: Nathan Haneysmith <nathan@getchef.com>
# Author:: Seth Chisamore <schisamo@getchef.com>
# Cookbook Name:: nrpe
# Recipe:: default
#
# Copyright 2009, 37signals
# Copyright 2009-2013, Chef Software, Inc.
# Copyright 2012, Webtrends, Inc.
# Copyright 2013-2014, Limelight Networks, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# determine hosts that NRPE will allow monitoring from. Start with localhost
mon_host = ['127.0.0.1', '::1']

# search for nagios servers and add them to the mon_host array as well
if node['nrpe']['multi_environment_monitoring']
  search(:node, "roles:#{node['nrpe']['server_role']}") do |n|
    mon_host << n['ipaddress']
  end
elsif !Chef::Config[:solo] || node['nrpe']['using_solo_search']
  search(:node, "roles:#{node['nrpe']['server_role']} AND chef_environment:#{node.chef_environment}") do |n|
    mon_host << n['ipaddress']
  end
end

# the first run on a nagios server wont find itself via search so if we're the nagios server, go
# ahead and put our own IP address in the NRPE config (unless it's already there).
if node.run_list.roles.include?(node['nrpe']['server_role'])
  mon_host << node['ipaddress'] unless mon_host.include?(node['ipaddress'])
end

# add any extra nagios servers defined via the 'allowed_hosts attribute'
mon_host.concat node['nrpe']['allowed_hosts'] if node['nrpe']['allowed_hosts']

include_dir = "#{node['nrpe']['conf_dir']}/nrpe.d"

directory include_dir do
  group node['nrpe']['group']
  mode '0750'
end

template "#{node['nrpe']['conf_dir']}/nrpe.cfg" do
  source 'nrpe.cfg.erb'
  group node['nrpe']['group']
  variables(
    mon_host: mon_host.uniq.sort,
    nrpe_directory: include_dir
  )
  notifies :restart, "service[#{node['nrpe']['service_name']}]", :delayed
end

execute 'nrpe-reload-systemd' do
  command '/bin/systemctl daemon-reload'
  action :nothing
end

# if we use systemd, make the nrpe.service a template to correct the user
template "#{node['nrpe']['systemd_unit_dir']}/nrpe.service" do
  source 'nrpe.service.erb'
  notifies :run, 'execute[nrpe-reload-systemd]', :immediately
  notifies :restart, "service[#{node['nrpe']['service_name']}]", :delayed
  only_if  { ::File.exist?("#{node['nrpe']['systemd_unit_dir']}/nrpe.service") }
  only_if  { node['init_package'] == 'systemd' }
  variables(
    nrpe: node['nrpe']
  )
end

service node['nrpe']['service_name'] do
  action [:start, :enable]
  supports restart: true, reload: true, status: true
end
