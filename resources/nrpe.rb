# frozen_string_literal: true

provides :nrpe
unified_mode true

include NrpeCookbook::Helpers

property :instance_name, String, name_property: true
property :install_method, String, equal_to: %w(package source), default: lazy { default_install_method }
property :install_epel, [true, false], default: true
property :package_options, [String, Array]
property :packages, [Array, Hash], default: lazy { default_packages }
property :build_packages, Array, default: lazy { default_build_packages }
property :user, String, default: lazy { default_user }
property :group, String, default: lazy { default_group }
property :home, String, default: lazy { default_home }
property :pid_file, String, default: lazy { default_pid_file }
property :conf_dir, String, default: lazy { default_conf_dir }
property :bin_dir, String, default: '/usr/sbin'
property :plugin_dir, String, default: lazy { default_plugin_dir }
property :ssl_lib_dir, String, default: lazy { default_ssl_lib_dir }
property :systemd_unit_dir, String, default: '/usr/lib/systemd/system'
property :service_name, String, default: lazy { default_service_name(install_method) }
property :allow_bash_command_substitution, [Integer, String, nil], default: nil
property :server_port, [Integer, String], default: 5666
property :server_address, [String, nil]
property :command_prefix, [String, nil]
property :log_facility, [String, nil]
property :debug, [Integer, String], default: 0
property :dont_blame_nrpe, [Integer, String], default: 0
property :command_timeout, [Integer, String], default: 60
property :connection_timeout, [Integer, String, nil], default: nil
property :allowed_hosts, Array, default: []
property :server_role, String, default: 'monitoring'
property :using_solo_search, [true, false], default: false
property :multi_environment_monitoring, [true, false], default: false
property :nrpe_url, String, default: 'https://github.com/NagiosEnterprises/nrpe/releases/download'
property :nrpe_version, String, default: '4.1.3'
property :nrpe_checksum, [String, nil]
property :plugins_url, String, default: 'https://www.monitoring-plugins.org/download'
property :plugins_version, String, default: '2.4.0'
property :plugins_checksum, [String, nil]

default_action %i(install configure start)

action :install do
  if new_resource.install_method == 'package'
    package 'epel-release' if platform_family?('rhel') && new_resource.install_epel

    if new_resource.packages.is_a?(Array)
      package new_resource.packages do
        options new_resource.package_options if new_resource.package_options
      end
    else
      new_resource.packages.each do |pkg, pkg_details|
        package pkg do
          version pkg_details['version'] if pkg_details['version']
          options new_resource.package_options if new_resource.package_options
        end
      end
    end
  else
    build_essential 'nrpe'

    new_resource.build_packages.each do |pkg|
      package pkg
    end

    group new_resource.group

    user new_resource.user do
      system true
      group new_resource.group
    end

    remote_file "#{Chef::Config[:file_cache_path]}/nrpe-#{new_resource.nrpe_version}.tar.gz" do
      source "#{new_resource.nrpe_url}/nrpe-#{new_resource.nrpe_version}/nrpe-#{new_resource.nrpe_version}.tar.gz"
      checksum new_resource.nrpe_checksum if new_resource.nrpe_checksum
      action :create_if_missing
    end

    directory new_resource.conf_dir do
      group new_resource.group
      mode '0750'
    end

    bash 'compile-nagios-nrpe' do
      cwd Chef::Config[:file_cache_path]
      code <<~CODE
        tar zxvf nrpe-#{new_resource.nrpe_version}.tar.gz
        cd nrpe-#{new_resource.nrpe_version}
        ./configure --prefix=/usr \
                    --sysconfdir=/etc \
                    --localstatedir=/var \
                    --libexecdir=#{new_resource.plugin_dir} \
                    --libdir=#{new_resource.home} \
                    --enable-command-args \
                    --with-nagios-user=#{new_resource.user} \
                    --with-nagios-group=#{new_resource.group} \
                    --with-nrpe-user=#{new_resource.user} \
                    --with-nrpe-group=#{new_resource.group} \
                    --with-ssl=/usr/bin/openssl \
                    --with-ssl-lib=#{new_resource.ssl_lib_dir} \
                    --bindir=#{new_resource.bin_dir}/
        make all
        make install
      CODE
      not_if "#{new_resource.bin_dir}/nrpe --version | grep #{new_resource.nrpe_version}"
    end

    remote_file "#{Chef::Config[:file_cache_path]}/monitoring-plugins-#{new_resource.plugins_version}.tar.gz" do
      source "#{new_resource.plugins_url}/monitoring-plugins-#{new_resource.plugins_version}.tar.gz"
      checksum new_resource.plugins_checksum if new_resource.plugins_checksum
      action :create_if_missing
    end

    bash 'compile-monitoring-plugins' do
      cwd Chef::Config[:file_cache_path]
      code <<~CODE
        tar zxvf monitoring-plugins-#{new_resource.plugins_version}.tar.gz
        cd monitoring-plugins-#{new_resource.plugins_version}
        ./configure --with-nagios-user=#{new_resource.user} \
                    --with-nagios-group=#{new_resource.group} \
                    --prefix=/usr \
                    --libexecdir=#{new_resource.plugin_dir}
        make -s
        make install
      CODE
      creates "#{new_resource.plugin_dir}/check_users"
    end

    directory ::File.dirname(new_resource.pid_file) do
      owner new_resource.user
      group new_resource.group
      mode '0755'
      only_if { systemd? }
    end

    template '/usr/lib/tmpfiles.d/nrpe.conf' do
      cookbook 'nrpe'
      source 'nrpe-tmpfiles.d.erb'
      mode '0644'
      variables(pid_dir: ::File.dirname(new_resource.pid_file), user: new_resource.user, group: new_resource.group)
      only_if { systemd? }
    end
  end
end

action :configure do
  include_dir = "#{new_resource.conf_dir}/nrpe.d"

  service new_resource.service_name do
    action :nothing
    supports restart: true, reload: true, status: true
  end

  directory include_dir do
    group new_resource.group
    mode '0750'
  end

  template "#{new_resource.conf_dir}/nrpe.cfg" do
    cookbook 'nrpe'
    source 'nrpe.cfg.erb'
    group new_resource.group
    variables(
      nrpe: new_resource,
      mon_host: nrpe_allowed_hosts(new_resource),
      nrpe_directory: include_dir
    )
    notifies :restart, "service[#{new_resource.service_name}]", :delayed
  end

  systemd_unit "#{new_resource.service_name}.service" do
    content nrpe_systemd_unit(new_resource)
    action :create
    notifies :restart, "service[#{new_resource.service_name}]", :delayed
    only_if { systemd? && new_resource.install_method == 'source' }
  end
end

action :start do
  service new_resource.service_name do
    action %i(enable start)
    supports restart: true, reload: true, status: true
  end
end

action :remove do
  service new_resource.service_name do
    action %i(stop disable)
    supports restart: true, reload: true, status: true
  end

  file "#{new_resource.conf_dir}/nrpe.cfg" do
    action :delete
  end

  directory "#{new_resource.conf_dir}/nrpe.d" do
    recursive true
    action :delete
  end

  file '/usr/lib/tmpfiles.d/nrpe.conf' do
    action :delete
  end

  systemd_unit "#{new_resource.service_name}.service" do
    action :delete
    only_if { systemd? && new_resource.install_method == 'source' }
  end

  if new_resource.install_method == 'package'
    package_names = new_resource.packages.is_a?(Array) ? new_resource.packages : new_resource.packages.keys

    package package_names do
      action :remove
    end
  end
end

action_class do
  include NrpeCookbook::Helpers

  def nrpe_allowed_hosts(resource)
    mon_host = ['127.0.0.1', '::1']

    if resource.multi_environment_monitoring
      search(:node, "roles:#{resource.server_role}") { |n| mon_host << n['ipaddress'] }
    elsif !Chef::Config[:solo] || resource.using_solo_search
      search(:node, "roles:#{resource.server_role} AND chef_environment:#{node.chef_environment}") { |n| mon_host << n['ipaddress'] }
    end

    mon_host << node['ipaddress'] if node.run_list.roles.include?(resource.server_role) && !mon_host.include?(node['ipaddress'])
    mon_host.concat(resource.allowed_hosts)
    mon_host.uniq.sort
  end

  def nrpe_systemd_unit(resource)
    {
      Unit: {
        Description: 'Nagios Remote Program Executor',
        Documentation: 'http://www.nagios.org/documentation',
        Conflicts: 'nrpe.socket',
        Requires: 'network-online.target',
        After: 'var-run.mount nss-lookup.target network.target local-fs.target time-sync.target',
        Before: 'getty@tty1.service xdm.service',
      },
      Install: {
        WantedBy: 'multi-user.target',
      },
      Service: {
        Type: 'simple',
        User: resource.user,
        Group: resource.group,
        ExecStart: "#{resource.bin_dir}/nrpe -c #{resource.conf_dir}/nrpe.cfg -f $NRPE_SSL_OPT",
        ExecReload: '/bin/kill -HUP $MAINPID',
        ExecStopPost: "/bin/rm -f #{resource.pid_file}",
      },
    }
  end
end
