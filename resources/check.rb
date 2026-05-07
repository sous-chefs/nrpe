# frozen_string_literal: true

provides :nrpe_check
unified_mode true

include NrpeCookbook::Helpers

# Name of the nrpe check, used for the filename and the command name
property :command_name, String, name_property: true
property :warning_condition, [Integer, String]
property :critical_condition, [Integer, String]
property :command, String
property :parameters, String
property :template, String
property :conf_dir, String, default: lazy { default_conf_dir }
property :plugin_dir, String, default: lazy { default_plugin_dir }
property :service_name, String, default: lazy { default_service_name(default_install_method) }
property :check_action, Symbol, equal_to: %i(reload restart), default: lazy { default_check_action }

default_action :add

action :add do
  config_file = "#{new_resource.conf_dir}/nrpe.d/#{new_resource.command_name}.cfg"

  service new_resource.service_name do
    action :nothing
    supports restart: true, reload: true, status: true
  end

  if new_resource.template
    raise 'You cannot specify command and template!' if new_resource.command

    template config_file do
      source new_resource.template
      notifies new_resource.check_action, "service[#{new_resource.service_name}]"
    end
  else
    command = new_resource.command || "#{new_resource.plugin_dir}/#{new_resource.command_name}"
    file_contents = "command[#{new_resource.command_name}]=#{command}"
    file_contents += " -w #{new_resource.warning_condition}" unless new_resource.warning_condition.nil?
    file_contents += " -c #{new_resource.critical_condition}" unless new_resource.critical_condition.nil?
    file_contents += " #{new_resource.parameters}" unless new_resource.parameters.nil?
    file_contents += "\n"

    file config_file do
      content file_contents
      notifies new_resource.check_action, "service[#{new_resource.service_name}]"
    end
  end
end

action :remove do
  config_file = "#{new_resource.conf_dir}/nrpe.d/#{new_resource.command_name}.cfg"

  service new_resource.service_name do
    action :nothing
    supports restart: true, reload: true, status: true
  end

  file config_file do
    action :delete
    notifies new_resource.check_action, "service[#{new_resource.service_name}]", :delayed
  end
end

action_class do
  include NrpeCookbook::Helpers
end
