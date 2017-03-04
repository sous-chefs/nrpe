#
# Author:: Joshua Sierles <joshua@37signals.com>
# Author:: Joshua Timberman <joshua@getchef.com>
# Author:: Nathan Haneysmith <nathan@getchef.com>
# Author:: Seth Chisamore <schisamo@getchef.com>
# Author:: Tim Smith <tsmith84@gmail.com>
# Cookbook Name:: nrpe
# Attributes:: default
#
# Copyright 2009, 37signals
# Copyright 2009-2013, Chef Software, Inc.
# Copyright 2012, Webtrends, Inc
# Copyright 2013-2014, Limelight Networks, Inc
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

# nrpe package options
default['nrpe']['package']['options'] = nil

# default user / group for NRPE on most platforms
default['nrpe']['user']  = 'nagios'
default['nrpe']['group'] = 'nagios'

# config file options
default['nrpe']['allow_bash_command_substitution'] = nil
default['nrpe']['server_port']                     = 5666
default['nrpe']['server_address']                  = nil
default['nrpe']['command_prefix']                  = nil
default['nrpe']['log_facility']                    = nil
default['nrpe']['debug']                           = 0
default['nrpe']['dont_blame_nrpe']                 = 0
default['nrpe']['command_timeout']                 = 60
default['nrpe']['connection_timeout']              = nil

# for plugin from source installation
default['nrpe']['plugins']['url']      = 'https://www.monitoring-plugins.org/download'
default['nrpe']['plugins']['version']  = '2.1.2'
default['nrpe']['plugins']['checksum'] = '76c6b58f0867ab7b6c8c86c7e94fcce7183618f6daab63488990d0355f5600aa'

# for nrpe from source installation
default['nrpe']['url']      = 'http://prdownloads.sourceforge.net/sourceforge/nagios'
default['nrpe']['version']  = '2.15'
default['nrpe']['checksum'] = '66383b7d367de25ba031d37762d83e2b55de010c573009c6f58270b137131072'

# authorization options
default['nrpe']['server_role'] = 'monitoring'
default['nrpe']['allowed_hosts'] = nil
default['nrpe']['using_solo_search'] = false
default['nrpe']['multi_environment_monitoring'] = false
# this is mostly true except for centos-70
default['nrpe']['check_action'] = 'reload'

# attribute for storing information about checks on the node
default['nrpe']['checks'] = []

# different distros store systemd unit files in different locations
default['nrpe']['systemd_unit_dir'] = '/usr/lib/systemd/system'

# platform specific values
case node['platform_family']
when 'debian'
  default['nrpe']['install_method']    = 'package'
  default['nrpe']['pid_file']          = '/var/run/nagios/nrpe.pid'
  default['nrpe']['home']              = '/usr/lib/nagios'
  default['nrpe']['packages']          = {
    'nagios-nrpe-server' => {
      'version' => nil,
    },
    'nagios-plugins' => {
      'version' => nil,
    },
    'nagios-plugins-basic' => {
      'version' => nil,
    },
    'nagios-plugins-standard' => {
      'version' => nil,
    },
  }
  default['nrpe']['plugin_dir']        = '/usr/lib/nagios/plugins'
  default['nrpe']['conf_dir']          = '/etc/nagios'
  default['nrpe']['bin_dir']           = '/usr/sbin'
  default['nrpe']['systemd_unit_dir']  = '/lib/systemd/system'
  default['nrpe']['ssl_lib_dir']       = if node['kernel']['machine'] == 'i686'
                                           '/usr/lib/i386-linux-gnu'
                                         else
                                           '/usr/lib/x86_64-linux-gnu'
                                         end
  default['nrpe']['service_name']      = if node['nrpe']['install_method'] == 'package'
                                           'nagios-nrpe-server'
                                         else
                                           'nrpe'
                                         end
when 'rhel', 'fedora'
  # support systemd init script and the new NRPE user on modern RHEL / Fedora
  if node['platform_version'].to_i == 7 || node['platform'].to_i == 'fedora'
    default['nrpe']['check_action'] = 'restart'
  end
  default['nrpe']['user']  = 'nrpe'
  default['nrpe']['group'] = 'nrpe'
  default['nrpe']['install_method']    = 'package'
  default['nrpe']['install_yum-epel']  = true
  default['nrpe']['pid_file']          = '/var/run/nrpe/nrpe.pid'
  default['nrpe']['packages']          = {
    'nrpe' => {
      'version' => nil,
    },
    'nagios-plugins-disk' => {
      'version' => nil,
    },
    'nagios-plugins-load' => {
      'version' => nil,
    },
    'nagios-plugins-procs' => {
      'version' => nil,
    },
    'nagios-plugins-users' => {
      'version' => nil,
    },
  }
  if node['kernel']['machine'] == 'i686'
    default['nrpe']['home']            = '/usr/lib/nagios'
    default['nrpe']['ssl_lib_dir']     = '/usr/lib'
    default['nrpe']['plugin_dir']      = '/usr/lib/nagios/plugins'
  else
    default['nrpe']['home']            = '/usr/lib64/nagios'
    default['nrpe']['ssl_lib_dir']     = '/usr/lib64'
    default['nrpe']['plugin_dir']      = '/usr/lib64/nagios/plugins'
  end
  default['nrpe']['service_name']      = 'nrpe'
  default['nrpe']['conf_dir']          = '/etc/nagios'
  default['nrpe']['bin_dir']           = '/usr/sbin'
when 'freebsd'
  default['nrpe']['install_method']    = 'package'
  default['nrpe']['pid_file']          = '/var/run/nrpe2/nrpe2.pid'
  default['nrpe']['packages']          = {
    'nrpe' => {
      'version' => nil,
    },
  }
  default['nrpe']['log_facility']      = 'daemon'
  default['nrpe']['service_name']      = 'nrpe2'
  default['nrpe']['conf_dir']          = '/usr/local/etc'
  default['nrpe']['bin_dir']           = '/usr/sbin'
  default['nrpe']['plugin_dir']        = '/usr/local/libexec/nagios'
else
  # suse enterprise doesn't have a package, but modern opensuse does
  if node['platform'] == 'opensuseleap'
    default['nrpe']['install_method']    = 'package'
    default['nrpe']['pid_file']          = '/run/nrpe/nrpe.pid'
    default['nrpe']['home']              = '/usr/lib/nagios'
    default['nrpe']['ssl_lib_dir']       = '/usr/lib'
    default['nrpe']['service_name']      = 'nrpe'
    default['nrpe']['plugin_dir']        = '/usr/lib/nagios/plugins'
    default['nrpe']['conf_dir']          = '/etc'
    default['nrpe']['bin_dir']           = '/usr/sbin'
    default['nrpe']['packages']          = {
      'nrpe' => {
        'version' => nil,
      },
      'monitoring-plugins-nrpe' => {
        'version' => nil,
      },
    }
  else
    default['nrpe']['install_method']    = 'source'
    default['nrpe']['pid_file']          = '/var/run/nrpe.pid'
    default['nrpe']['home']              = '/usr/lib/nagios'
    default['nrpe']['ssl_lib_dir']       = '/usr/lib'
    default['nrpe']['service_name']      = 'nrpe'
    default['nrpe']['plugin_dir']        = '/usr/lib/nagios/plugins'
    default['nrpe']['conf_dir']          = '/etc/nagios'
    default['nrpe']['bin_dir']           = '/usr/sbin'
  end
end
