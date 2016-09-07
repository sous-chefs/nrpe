#
# Author:: Jake Vanderdray <jvanderdray@customink.com>
# Cookbook Name:: nrpe
# Provider:: check
#
# Copyright 2011, CustomInk LLC
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

use_inline_resources

def whyrun_supported?
  true
end

action :add do
  Chef::Log.info "Adding #{new_resource.command_name} to #{node['nrpe']['conf_dir']}/nrpe.d/"

  config_file = "#{node['nrpe']['conf_dir']}/nrpe.d/#{new_resource.command_name}.cfg"

  begin
    _r = run_context.resource_collection.find("service[#{node['nrpe']['service_name']}]")
  rescue Chef::Exceptions::ResourceNotFound
    service node['nrpe']['service_name'] do
      action :nothing
      supports restart: true, reload: true, status: true
    end
  end

  if new_resource.template
    unless new_resource.command.nil?
      raise 'You cannot specify command and template!'
    end
    f = template config_file do
      owner 'root'
      group node['nrpe']['group']
      mode '0640'
      source new_resource.template
      notifies node['nrpe']['check_action'], "service[#{node['nrpe']['service_name']}]", :delayed
    end
  else
    command = new_resource.command || "#{node['nrpe']['plugin_dir']}/#{new_resource.command_name}"
    file_contents = "command[#{new_resource.command_name}]=#{command}"
    file_contents += " -w #{new_resource.warning_condition}" unless new_resource.warning_condition.nil?
    file_contents += " -c #{new_resource.critical_condition}" unless new_resource.critical_condition.nil?
    file_contents += " #{new_resource.parameters}" unless new_resource.parameters.nil?
    file_contents += "\n"

    f = file config_file do
      owner 'root'
      group node['nrpe']['group']
      mode '0640'
      content file_contents
      notifies node['nrpe']['check_action'], "service[#{node['nrpe']['service_name']}]", :delayed
    end
  end
  new_resource.updated_by_last_action(f.updated_by_last_action?)
end

action :remove do
  config_file = "#{node['nrpe']['conf_dir']}/nrpe.d/#{new_resource.command_name}.cfg"

  begin
    _r = run_context.resource_collection.find("service[#{node['nrpe']['service_name']}]")
  rescue Chef::Exceptions::ResourceNotFound
    service node['nrpe']['service_name'] do
      action :nothing
      supports restart: true, reload: true, status: true
    end
  end

  if ::File.exist?(config_file)
    Chef::Log.info "Removing #{new_resource.command_name} from #{node['nrpe']['conf_dir']}/nrpe.d/"
    f = file config_file do
      action :delete
      notifies node['nrpe']['check_action'], "service[#{node['nrpe']['service_name']}]", :delayed
    end
    new_resource.updated_by_last_action(f.updated_by_last_action?)
  end
end
