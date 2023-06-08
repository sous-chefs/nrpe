name             'nrpe'
maintainer       'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license          'Apache-2.0'
description      'Installs and configures Nagios NRPE client'
version          '4.0.12'
issues_url       'https://github.com/sous-chefs/nrpe/issues'
source_url       'https://github.com/sous-chefs/nrpe'
chef_version     '>= 15.3'

depends 'yum-epel'

%w(debian ubuntu redhat centos fedora scientific amazon oracle freebsd suse opensuseleap).each do |os|
  supports os
end
