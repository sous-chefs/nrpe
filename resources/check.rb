#
# Author:: Jake Vanderdray <jvanderdray@customink.com>
# Author:: Tim Smith <tsmith@chef.io>
# Cookbook:: nrpe
# Resource:: check
#
# Copyright 2011, CustomInk LLC
# Copyright 2017, Chef Software, Inc.
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

# Name of the nrpe check, used for the filename and the command name
property :command_name, String, name_property: true
property :warning_condition, [Integer, String]
property :critical_condition, [Integer, String]
property :command, String
property :parameters, String
property :template, String

action :add do
  config_file = "#{node['nrpe']['conf_dir']}/nrpe.d/#{new_resource.command_name}.cfg"

  if new_resource.template
    raise 'You cannot specify command and template!' if new_resource.command

    template config_file do
      owner 'root'
      group node['nrpe']['group']
      mode '0640'
      source new_resource.template
      notifies node['nrpe']['check_action'], "service[#{node['nrpe']['service_name']}]"
    end
  else
    command = new_resource.command || "#{node['nrpe']['plugin_dir']}/#{new_resource.command_name}"
    file_contents = "command[#{new_resource.command_name}]=#{command}"
    file_contents += " -w #{new_resource.warning_condition}" unless new_resource.warning_condition.nil?
    file_contents += " -c #{new_resource.critical_condition}" unless new_resource.critical_condition.nil?
    file_contents += " #{new_resource.parameters}" unless new_resource.parameters.nil?
    file_contents += "\n"

    file config_file do
      owner 'root'
      group node['nrpe']['group']
      mode '0640'
      content file_contents
      notifies node['nrpe']['check_action'], "service[#{node['nrpe']['service_name']}]"
    end
  end
end

action :remove do
  config_file = "#{node['nrpe']['conf_dir']}/nrpe.d/#{new_resource.command_name}.cfg"

  file config_file do
    action :delete
    notifies node['nrpe']['check_action'], "service[#{node['nrpe']['service_name']}]", :delayed
  end
end
