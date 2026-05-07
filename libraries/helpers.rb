# frozen_string_literal: true

module NrpeCookbook
  module Helpers
    def default_install_method
      return 'package' if platform?('opensuseleap')

      if platform_family?('debian', 'rhel', 'fedora', 'amazon', 'freebsd')
        'package'
      else
        'source'
      end
    end

    def default_user
      %w(rhel fedora amazon).include?(node['platform_family']) ? 'nrpe' : 'nagios'
    end

    def default_group
      default_user
    end

    def default_pid_file
      case node['platform_family']
      when 'debian'
        '/var/run/nagios/nrpe.pid'
      when 'rhel', 'fedora', 'amazon'
        '/var/run/nrpe/nrpe.pid'
      when 'freebsd'
        '/var/run/nrpe2/nrpe2.pid'
      else
        platform?('opensuseleap') ? '/run/nrpe/nrpe.pid' : '/var/run/nrpe.pid'
      end
    end

    def default_home
      return '/usr/lib64/nagios' if %w(rhel fedora amazon).include?(node['platform_family']) && node['kernel']['machine'] != 'i686'

      '/usr/lib/nagios'
    end

    def default_ssl_lib_dir
      case node['platform_family']
      when 'debian'
        node['kernel']['machine'] == 'i686' ? '/usr/lib/i386-linux-gnu' : '/usr/lib/x86_64-linux-gnu'
      when 'rhel', 'fedora', 'amazon'
        node['kernel']['machine'] == 'i686' ? '/usr/lib' : '/usr/lib64'
      else
        '/usr/lib'
      end
    end

    def default_plugin_dir
      case node['platform_family']
      when 'debian'
        '/usr/lib/nagios/plugins'
      when 'rhel', 'fedora', 'amazon'
        node['kernel']['machine'] == 'i686' ? '/usr/lib/nagios/plugins' : '/usr/lib64/nagios/plugins'
      when 'freebsd'
        '/usr/local/libexec/nagios'
      else
        '/usr/lib/nagios/plugins'
      end
    end

    def default_conf_dir
      case node['platform_family']
      when 'freebsd'
        '/usr/local/etc'
      when 'suse'
        platform?('opensuseleap') ? '/etc' : '/etc/nagios'
      else
        '/etc/nagios'
      end
    end

    def default_service_name(install_method)
      case node['platform_family']
      when 'debian'
        install_method == 'package' ? 'nagios-nrpe-server' : 'nrpe'
      when 'freebsd'
        'nrpe2'
      else
        'nrpe'
      end
    end

    def default_packages
      case node['platform_family']
      when 'debian'
        {
          'nagios-nrpe-server' => { 'version' => nil },
          'nagios-plugins' => { 'version' => nil },
          'nagios-plugins-basic' => { 'version' => nil },
          'nagios-plugins-standard' => { 'version' => nil },
        }
      when 'rhel', 'fedora', 'amazon'
        {
          'nrpe' => { 'version' => nil },
          'nagios-plugins-disk' => { 'version' => nil },
          'nagios-plugins-load' => { 'version' => nil },
          'nagios-plugins-procs' => { 'version' => nil },
          'nagios-plugins-users' => { 'version' => nil },
        }
      else
        platform?('opensuseleap') ? { 'nrpe' => { 'version' => nil }, 'monitoring-plugins-nrpe' => { 'version' => nil } } : { 'nrpe' => { 'version' => nil } }
      end
    end

    def default_build_packages
      case node['platform_family']
      when 'rhel', 'fedora', 'amazon'
        %w(openssl-devel tar which)
      when 'debian'
        %w(libssl-dev tar)
      when 'suse'
        %w(libopenssl-devel tar gzip which)
      else
        %w(libssl-dev tar)
      end
    end

    def default_check_action
      %w(rhel fedora amazon).include?(node['platform_family']) && systemd? ? :restart : :reload
    end
  end
end
