#
# Author:: Seth Chisamore <schisamo@getchef.com>
# Author:: Tim Smith <tsmith84@gmail.com>
# Cookbook Name:: nrpe
# Recipe:: package_install
#
# Copyright 2013, Chef Software, Inc.
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

# nrpe packages are available in EPEL on rhel
if platform_family?('rhel') && node['nrpe']['install_yum-epel']
  include_recipe 'yum-epel'
end

# install the nrpe packages specified in the ['nrpe']['packages'] attribute
#
# For backward compatibility it can be defined as an array or as a Hash.
#
# If it is defined as a hash, by default versions for each packages is nil. So it will install the
# latest one available in repositories.
#
# By default followings are defined and can be adjusted for your tate in your wrapper cookbook
#   default['nrpe']['packages'] = {
#     'nagios-nrpe-server'      => {'version' => nil},
#     'nagios-plugins'          => {'version' => nil},
#     'nagios-plugins-basic'    => {'version' => nil},
#     'nagios-plugins-standard' => {'version' => nil}
#   }
# These version information can be overriden in your environment specific attributes so you can intall
# any version you prefer
#
# In case of defining as an array, it is as usual. It will install latest version found in repositories

if node['nrpe']['packages'].is_a?(Array)
  package node['nrpe']['packages'] do
    options node['nrpe']['package']['options'] unless node['nrpe']['package']['options'].nil?
  end
else
  node['nrpe']['packages'].each do |pkg, pkg_details|
    package pkg do
      version pkg_details['version'] unless pkg_details['version'].nil?
      options node['nrpe']['package']['options'] unless node['nrpe']['package']['options'].nil?
    end
  end
end
